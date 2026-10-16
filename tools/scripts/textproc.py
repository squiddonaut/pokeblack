#!/usr/bin/env python3
"""build the message bank NARCs from res/text and res/pokemon"""

import argparse
import collections
import os
import sys

from gen5text import encode
from narc import write_narc
import speciesproc as sp

TEXT_DIR = os.path.join(sp.ROOT, 'res', 'text')
TEXT_ARCS = ('a/0/0/2', 'a/0/0/3')
SPECIES_BANKS = {'a/0/0/2': (70, 235, 236, 244, 245, 260, 268, 281, 284)}


def bank_path(arc, index):
    return os.path.join(TEXT_DIR, arc, f'{index:03d}.json')


def to_json(decoded):
    entries = decoded['sections'][0]
    flags = collections.Counter(e['flags'] for e in entries).most_common(1)[0][0] if entries else 0
    out = {'flags': flags, 'entries': [e['text'] if e['flags'] == flags else e for e in entries]}
    if 'pad' in decoded:
        out['pad'] = decoded['pad'][0]
    return out


def from_json(bank, texts):
    entries = [{'text': t, 'flags': bank['flags']} if isinstance(t, str) else t for t in texts]
    decoded = {'sections': [entries]}
    if 'pad' in bank:
        decoded['pad'] = [bank['pad']]
    return encode(decoded)


def bank_count(arc):
    names = [n for n in os.listdir(os.path.join(TEXT_DIR, arc)) if n.endswith('.json')]
    indices = sorted(int(n[:-len('.json')]) for n in names)
    if indices != list(range(len(indices))):
        raise ValueError(f"{arc}: bank numbering is not contiguous from 0")
    return len(indices)


def build(out_dir):
    c = sp.load_constants()
    mons, _, _ = sp.load_species(c)
    written = []
    for arc in TEXT_ARCS:
        species_banks = SPECIES_BANKS.get(arc, ())
        members = []
        for index in range(bank_count(arc)):
            bank = sp.load_json(bank_path(arc, index))
            if index in species_banks:
                texts = [mon['text'][str(index)] for mon in mons] + bank['tail']
            else:
                texts = bank['entries']
            members.append(from_json(bank, texts))
        dest = os.path.join(out_dir, arc)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        with open(dest, 'wb') as f:
            f.write(write_narc(members))
        written.append(arc)
    return written


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-o', '--output', default=os.path.join(sp.ROOT, 'build', 'files'),
                        help="directory the a/x/y/z files are written under")
    parser.add_argument('--compare', metavar='DIR',
                        help="compare the built files against the ones under DIR, e.g. files")
    args = parser.parse_args()

    try:
        written = build(args.output)
    except (OSError, ValueError, KeyError) as e:
        sys.exit(f"error: {e}")
    if args.compare:
        failed = 0
        for path in written:
            same = open(os.path.join(args.output, path), 'rb').read() == open(os.path.join(args.compare, path), 'rb').read()
            print(f"{'OK  ' if same else 'FAIL'} {path}")
            failed += not same
        if failed:
            return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
