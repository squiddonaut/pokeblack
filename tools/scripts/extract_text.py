#!/usr/bin/env python3
"""extract the message bank NARCs to res/text, moving species entries into res/pokemon"""

import argparse
import os
import sys

from gen5text import decode
from narc import read_narc
import speciesproc as sp
import textproc as tp


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--files', default=os.path.join(sp.ROOT, 'files'))
    args = parser.parse_args()

    c = sp.load_constants()
    mons, _, _ = sp.load_species(c)
    count = len(mons)
    paths = [os.path.join(sp.species_dir(ident), 'data.json') for ident in c['species'].names[:count]]
    for mon in mons:
        mon['text'] = {}

    for arc in tp.TEXT_ARCS:
        banks, _ = read_narc(open(os.path.join(args.files, arc), 'rb').read())
        species_banks = tp.SPECIES_BANKS.get(arc, ())
        for index, data in enumerate(banks):
            bank = tp.to_json(decode(data))
            if index in species_banks:
                entries = bank.pop('entries')
                if not all(isinstance(e, str) for e in entries[:count]):
                    sys.exit(f"error: {arc} bank {index} has per-entry flags in the species range")
                for mon, text in zip(mons, entries):
                    mon['text'][str(index)] = text
                bank['tail'] = entries[count:]
            sp.write_json(tp.bank_path(arc, index), bank)

    for path, mon in zip(paths, mons):
        sp.write_json(path, mon)
    print(f"{sum(len(read_narc(open(os.path.join(args.files, a), 'rb').read())[0]) for a in tp.TEXT_ARCS)} banks")
    return 0


if __name__ == '__main__':
    sys.exit(main())
