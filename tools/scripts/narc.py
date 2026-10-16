#!/usr/bin/env python3
"""unpack, pack and round-trip verify NARC archives"""

import argparse
import glob
import os
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

NARC_MAGIC = b'NARC'
HEADER_SIZE = 0x10
DEFAULT_FNT = struct.pack('<IHH', 4, 0, 1)
FNT_NAME = 'fnt.bin'
PAD = b'\xFF'
VERIFY_DIRS = ('files', 'white.us/files')


def align4(value):
    return (value + 3) & ~3


def read_narc(data):
    magic, bom, _, size, header_size, sections = struct.unpack_from('<4sHHIHH', data, 0)
    if magic != NARC_MAGIC or bom != 0xFFFE or sections != 3:
        raise ValueError("not a NARC")
    if size != len(data):
        raise ValueError(f"size field {size:#x} does not match file size {len(data):#x}")
    blocks = {}
    offset = header_size
    for _ in range(sections):
        magic, block_size = struct.unpack_from('<4sI', data, offset)
        blocks[magic] = data[offset + 8:offset + block_size]
        offset += block_size
    btaf, btnf, gmif = blocks[b'BTAF'], blocks[b'BTNF'], blocks[b'GMIF']
    count = struct.unpack_from('<H', btaf, 0)[0]
    members = []
    for i in range(count):
        start, end = struct.unpack_from('<II', btaf, 4 + i * 8)
        members.append(gmif[start:end])
    return members, btnf


def write_narc(members, fnt=DEFAULT_FNT):
    fat = bytearray(struct.pack('<HH', len(members), 0))
    image = bytearray()
    for member in members:
        fat += struct.pack('<II', len(image), len(image) + len(member))
        image += member
        image += PAD * (align4(len(image)) - len(image))
    fnt = fnt + PAD * (align4(len(fnt)) - len(fnt))
    body = bytearray()
    for magic, block in ((b'BTAF', fat), (b'BTNF', fnt), (b'GMIF', image)):
        body += struct.pack('<4sI', magic, len(block) + 8) + block
    header = struct.pack('<4sHHIHH', NARC_MAGIC, 0xFFFE, 0x0100, HEADER_SIZE + len(body), HEADER_SIZE, 3)
    return header + bytes(body)


def unpack(path, out_dir):
    members, fnt = read_narc(open(path, 'rb').read())
    os.makedirs(out_dir, exist_ok=True)
    width = len(str(max(len(members) - 1, 0)))
    for i, member in enumerate(members):
        with open(os.path.join(out_dir, f'{i:0{width}d}.bin'), 'wb') as f:
            f.write(member)
    if fnt != DEFAULT_FNT:
        with open(os.path.join(out_dir, FNT_NAME), 'wb') as f:
            f.write(fnt)
    return len(members)


def pack(in_dir):
    indices = {}
    for name in os.listdir(in_dir):
        stem, ext = os.path.splitext(name)
        if ext == '.bin' and stem.isdigit():
            indices[int(stem)] = name
    if sorted(indices) != list(range(len(indices))):
        raise ValueError(f"{in_dir}: member numbering is not contiguous from 0")
    members = [open(os.path.join(in_dir, indices[i]), 'rb').read() for i in range(len(indices))]
    fnt_path = os.path.join(in_dir, FNT_NAME)
    fnt = open(fnt_path, 'rb').read() if os.path.exists(fnt_path) else DEFAULT_FNT
    return write_narc(members, fnt)


def find_narcs():
    paths = []
    for directory in VERIFY_DIRS:
        for path in sorted(glob.glob(os.path.join(ROOT, directory, '**'), recursive=True)):
            if os.path.isfile(path):
                with open(path, 'rb') as f:
                    if f.read(4) == NARC_MAGIC:
                        paths.append(path)
    return paths


def verify(paths):
    failed = 0
    for path in paths:
        data = open(path, 'rb').read()
        try:
            members, fnt = read_narc(data)
            ok = write_narc(members, fnt) == data
        except (ValueError, KeyError, struct.error) as e:
            print(f"{os.path.relpath(path, ROOT)}: {e}")
            ok = False
        if not ok:
            failed += 1
            print(f"FAIL {os.path.relpath(path, ROOT)}")
    print(f"{len(paths) - failed}/{len(paths)} NARCs round-trip")
    return failed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    p = sub.add_parser('unpack', help="write each member to DIR as NNNN.bin")
    p.add_argument('narc')
    p.add_argument('dir')
    p = sub.add_parser('pack', help="build a NARC from a directory made by unpack")
    p.add_argument('dir')
    p.add_argument('-o', '--output', required=True)
    p = sub.add_parser('verify', help="repack NARCs and compare byte for byte")
    p.add_argument('narcs', nargs='*', help="default every NARC under files/ and white.us/files/")
    args = parser.parse_args()

    try:
        if args.command == 'unpack':
            count = unpack(args.narc, args.dir)
            print(f"{count} members -> {args.dir}")
        elif args.command == 'pack':
            data = pack(args.dir)
            with open(args.output, 'wb') as f:
                f.write(data)
        else:
            if verify(args.narcs or find_narcs()):
                return 1
    except (OSError, ValueError) as e:
        sys.exit(f"error: {e}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
