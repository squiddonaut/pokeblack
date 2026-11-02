#!/usr/bin/env python3

import argparse
import collections
import json
import os
import struct
import sys

from narc import read_narc, write_narc

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

KEY_BASE = 0x7C89
KEY_STEP = 0x2983
CHAR_VAR = 0xF000
CHAR_NEWLINE = 0xFFFE
CHAR_END = 0xFFFF
VERIFY_ARCS = ('files/a/0/0/2', 'files/a/0/0/3')


def crypt(chars, index):
    key = (KEY_BASE + index * KEY_STEP) & 0xFFFF
    out = []
    for c in chars:
        out.append(c ^ key)
        key = ((key << 3) | (key >> 13)) & 0xFFFF
    return out


def read_bank(data):
    sections, count, _, _ = struct.unpack_from('<HHII', data, 0)
    offsets = struct.unpack_from(f'<{sections}I', data, 12)
    banks = []
    pads = []
    for base in offsets:
        entries = []
        end = 4 + count * 8
        for i in range(count):
            offset, length, flags = struct.unpack_from('<IHH', data, base + 4 + i * 8)
            chars = struct.unpack_from(f'<{length}H', data, base + offset)
            entries.append((crypt(chars, i), flags))
            end = max(end, offset + length * 2)
        size = struct.unpack_from('<I', data, base)[0]
        banks.append(entries)
        pads.append(data[base + end:base + size])
    return banks, pads


def write_bank(banks, pads=None):
    count = len(banks[0])
    blocks = []
    for n, entries in enumerate(banks):
        if len(entries) != count:
            raise ValueError("sections have different entry counts")
        table = bytearray()
        text = bytearray()
        start = 4 + count * 8
        for i, (chars, flags) in enumerate(entries):
            table += struct.pack('<IHH', start + len(text), len(chars), flags)
            text += struct.pack(f'<{len(chars)}H', *crypt(chars, i))
        size = start + len(text)
        size += -size & 3
        block = struct.pack('<I', size) + table + text
        pad = pads[n] if pads and len(pads[n]) == size - len(block) else bytes(size - len(block))
        blocks.append(block + pad)
    header_size = 12 + 4 * len(blocks)
    offsets = []
    pos = header_size
    for block in blocks:
        offsets.append(pos)
        pos += len(block)
    largest = max(len(block) for block in blocks)
    header = struct.pack('<HHII', len(blocks), count, largest, 0)
    header += struct.pack(f'<{len(blocks)}I', *offsets)
    return header + b''.join(blocks)


def is_plain(c):
    return 0x20 <= c < CHAR_VAR and not 0xD800 <= c < 0xE000 and c not in (0x7B, 0x7D)


def chars_to_str(chars):
    out = []
    terminated = bool(chars) and chars[-1] == CHAR_END
    if terminated:
        chars = chars[:-1]
    i = 0
    while i < len(chars):
        c = chars[i]
        if c == CHAR_NEWLINE:
            out.append('\n')
        elif c == CHAR_VAR and i + 2 < len(chars) and i + 3 + chars[i + 2] <= len(chars):
            command, argc = chars[i + 1], chars[i + 2]
            args = chars[i + 3:i + 3 + argc]
            out.append('{VAR ' + ' '.join(f'{v:04X}' for v in (command, *args)) + '}')
            i += 3 + argc
            continue
        elif is_plain(c):
            out.append(chr(c))
        else:
            out.append(f'{{{c:04X}}}')
        i += 1
    text = ''.join(out)
    return text if terminated else text + '{NOEND}'


def str_to_chars(text):
    terminated = True
    if text.endswith('{NOEND}'):
        text = text[:-len('{NOEND}')]
        terminated = False
    chars = []
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == '\n':
            chars.append(CHAR_NEWLINE)
        elif ch == '{':
            end = text.index('}', i)
            token = text[i + 1:end].split()
            if token[0] == 'VAR':
                values = [int(v, 16) for v in token[1:]]
                chars += [CHAR_VAR, values[0], len(values) - 1] + values[1:]
            else:
                chars.append(int(token[0], 16))
            i = end + 1
            continue
        else:
            chars.append(ord(ch))
        i += 1
    if terminated:
        chars.append(CHAR_END)
    return chars


def to_lines(text):
    lines = text.splitlines(keepends=True)
    return lines if len(lines) > 1 else text


def from_lines(content):
    return ''.join(content) if isinstance(content, list) else content


def decode(data, prefix):
    banks, pads = read_bank(data)
    if len(banks) != 1:
        raise ValueError(f"{len(banks)} sections, only one is supported")
    entries = banks[0]
    flags = collections.Counter(f for _, f in entries).most_common(1)[0][0] if entries else 0
    messages = []
    for i, (chars, f) in enumerate(entries):
        msg = {'id': f'{prefix}_{i:04d}', 'en_US': to_lines(chars_to_str(chars))}
        if f != flags:
            msg['flags'] = f
        messages.append(msg)
    out = {'flags': flags}
    if pads[0].strip(b'\0'):
        out['pad'] = pads[0].hex()
    out['messages'] = messages
    return out


def encode(bank):
    flags = bank.get('flags', 0)
    entries = []
    for msg in bank['messages']:
        if 'en_US' not in msg:
            raise ValueError(f"message {msg.get('id')} has no en_US text")
        entries.append((str_to_chars(from_lines(msg['en_US'])), msg.get('flags', flags)))
    pads = [bytes.fromhex(bank['pad'])] if 'pad' in bank else None
    return write_bank([entries], pads)


def merge(paths):
    bank = {'messages': []}
    for path in paths:
        part = json.load(open(path, encoding='utf-8'))
        bank['messages'] += part.get('messages', [])
        for key in ('flags', 'pad'):
            if key in part:
                bank[key] = part[key]
    return bank


def bank_prefix(arc, index):
    return 'a' + ''.join(arc.split('/')[1:]) + f'_{index:03d}'


def verify(arcs):
    total = failed = 0
    for arc in arcs:
        members, _ = read_narc(open(arc, 'rb').read())
        for i, data in enumerate(members):
            if not data:
                continue
            total += 1
            try:
                bank = json.loads(json.dumps(decode(data, f'msg_{i:03d}')))
                ok = encode(bank) == data
            except (ValueError, struct.error) as e:
                print(f"{arc} {i}: {e}")
                ok = False
            if not ok:
                failed += 1
                print(f"FAIL {os.path.relpath(arc, ROOT)} {i}")
    print(f"{total - failed}/{total} banks round-trip")
    return failed


def write_json(path, obj):
    with open(path, 'w', encoding='utf-8') as f:
        f.write(json.dumps(obj, indent=4, ensure_ascii=False) + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    p = sub.add_parser('decode', help="message bank to json")
    p.add_argument('bank', help="a bank file, or ARC:INDEX to read one from a NARC")
    p.add_argument('--id-prefix', default='msg')
    p.add_argument('-o', '--output')
    p = sub.add_parser('encode', help="json to message bank")
    p.add_argument('json', nargs='+', help="files whose messages are joined in order")
    p.add_argument('-o', '--output', required=True)
    p = sub.add_parser('pack', help="json banks to a message NARC")
    p.add_argument('banks', nargs='+', metavar='BANK', help="one json per bank, or A.json+B.json to join several")
    p.add_argument('-o', '--output', required=True)
    p = sub.add_parser('verify', help="re-encode every bank and compare byte for byte")
    p.add_argument('arcs', nargs='*', help="default a/0/0/2 and a/0/0/3")
    args = parser.parse_args()

    try:
        if args.command == 'decode':
            path, _, index = args.bank.partition(':')
            data = open(path, 'rb').read()
            if index:
                data = read_narc(data)[0][int(index)]
            bank = decode(data, args.id_prefix)
            if args.output:
                write_json(args.output, bank)
            else:
                sys.stdout.write(json.dumps(bank, indent=4, ensure_ascii=False) + '\n')
        elif args.command == 'encode':
            with open(args.output, 'wb') as f:
                f.write(encode(merge(args.json)))
        elif args.command == 'pack':
            members = [encode(merge(spec.split('+'))) for spec in args.banks]
            with open(args.output, 'wb') as f:
                f.write(write_narc(members))
        else:
            arcs = args.arcs or [os.path.join(ROOT, arc) for arc in VERIFY_ARCS]
            if verify(arcs):
                return 1
    except (OSError, ValueError) as e:
        sys.exit(f"error: {e}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
