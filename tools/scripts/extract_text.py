#!/usr/bin/env python3
"""extract message bank NARCs to res/text"""

import argparse
import os
import sys

from gen5text import ROOT, bank_prefix, decode, write_json
from narc import read_narc

TEXT_ARCS = ('a/0/0/2', 'a/0/0/3')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--files', default=os.path.join(ROOT, 'files'))
    parser.add_argument('-o', '--output', default=os.path.join(ROOT, 'res', 'text'))
    args = parser.parse_args()

    total = 0
    for arc in TEXT_ARCS:
        banks, _ = read_narc(open(os.path.join(args.files, arc), 'rb').read())
        out_dir = os.path.join(args.output, arc)
        os.makedirs(out_dir, exist_ok=True)
        for index, data in enumerate(banks):
            write_json(os.path.join(out_dir, f'{index:03d}.json'), decode(data, bank_prefix(arc, index)))
        total += len(banks)
    print(f"{total} banks")
    return 0


if __name__ == '__main__':
    sys.exit(main())
