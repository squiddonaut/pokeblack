#!/usr/bin/env python3
"""build the species data NARCs from res/pokemon"""

import argparse
import json
import os
import struct
import sys

from narc import write_narc

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CONSTANTS_DIR = os.path.join(ROOT, 'generated')
POKEMON_DIR = os.path.join(ROOT, 'res', 'pokemon')

PERSONAL_PATH = 'a/0/1/6'
LEARNSET_PATH = 'a/0/1/8'
EVOLUTION_PATH = 'a/0/1/9'
OFFSPRING_PATH = 'a/0/2/0'
EGG_MOVES_PATH = 'a/1/2/3'

PERSONAL_SIZE = 0x3C
NUM_TMS = 95
NUM_HMS = 6
NUM_EVOLUTIONS = 7
PERSONAL_668_NONE = 999
LEARNSET_END = 0xFFFF

STATS = ('hp', 'attack', 'defense', 'speed', 'special_attack', 'special_defense')
HELD_ITEMS = ('common', 'rare', 'rare_2')
TMS = [f'TM{i:02d}' for i in range(1, NUM_TMS + 1)] + [f'HM{i:02d}' for i in range(1, NUM_HMS + 1)]

EVO_PARAMS = {
    'EVO_LEVEL': 'level',
    'EVO_TRADE_WITH_HELD_ITEM': 'item',
    'EVO_USE_ITEM': 'item',
    'EVO_LEVEL_ATK_GT_DEF': 'level',
    'EVO_LEVEL_ATK_EQ_DEF': 'level',
    'EVO_LEVEL_ATK_LT_DEF': 'level',
    'EVO_LEVEL_PID_LOW': 'level',
    'EVO_LEVEL_PID_HIGH': 'level',
    'EVO_LEVEL_NINJASK': 'level',
    'EVO_LEVEL_SHEDINJA': 'level',
    'EVO_LEVEL_BEAUTY': 'level',
    'EVO_USE_ITEM_MALE': 'item',
    'EVO_USE_ITEM_FEMALE': 'item',
    'EVO_LEVEL_WITH_HELD_ITEM_DAY': 'item',
    'EVO_LEVEL_WITH_HELD_ITEM_NIGHT': 'item',
    'EVO_LEVEL_KNOW_MOVE': 'move',
    'EVO_LEVEL_SPECIES_IN_PARTY': 'species',
    'EVO_LEVEL_MALE': 'level',
    'EVO_LEVEL_FEMALE': 'level',
}
PARAM_TABLES = {'item': 'items', 'move': 'moves', 'species': 'species'}


class Constants:
    def __init__(self, name):
        self.names = []
        self.values = {}
        for line in open(os.path.join(CONSTANTS_DIR, name + '.txt')):
            line = line.split('#')[0].strip()
            if not line:
                continue
            ident, _, value = line.partition('=')
            ident = ident.strip()
            self.values[ident] = int(value, 0) if value else len(self.names)
            self.names.append(ident)
        self.by_value = {v: k for k, v in self.values.items()}

    def __getitem__(self, ident):
        if isinstance(ident, int):
            return ident
        try:
            return self.values[ident]
        except KeyError:
            raise ValueError(f"unknown constant {ident}") from None

    def name(self, value):
        return self.by_value.get(value, value)


def load_constants():
    tables = ('species', 'moves', 'items', 'abilities', 'pokemon_types', 'egg_groups', 'exp_rates',
              'gender_ratios', 'pokemon_colors', 'evolution_methods')
    return {table: Constants(table) for table in tables}


def load_json(path):
    with open(path, encoding='utf-8') as f:
        return json.load(f)


def dump_json(obj, indent=0):
    pad = ' ' * indent
    inner = ' ' * (indent + 4)
    if isinstance(obj, dict):
        if not obj:
            return '{}'
        items = [f'{inner}{json.dumps(k)}: {dump_json(v, indent + 4)}' for k, v in obj.items()]
        return '{\n' + ',\n'.join(items) + '\n' + pad + '}'
    if isinstance(obj, list):
        if not obj:
            return '[]'
        if len(obj) <= 2 and not any(isinstance(v, (dict, list)) for v in obj):
            return '[ ' + ', '.join(json.dumps(v, ensure_ascii=False) for v in obj) + ' ]'
        return '[\n' + ',\n'.join(inner + dump_json(v, indent + 4) for v in obj) + '\n' + pad + ']'
    return json.dumps(obj, ensure_ascii=False)


def write_json(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(dump_json(obj) + '\n')


def species_dir(ident):
    return os.path.join(POKEMON_DIR, ident[len('SPECIES_'):].lower())


def pack_personal(mon, c, form_base):
    stats = [mon['base_stats'][s] for s in STATS]
    evs = sum(mon['ev_yields'][s] << (i * 2) for i, s in enumerate(STATS))
    evs |= mon.get('unk_0A', 0)
    items = [c['items'][mon['held_items'][k]] for k in HELD_ITEMS]
    color = c['pokemon_colors'][mon['body_color']] | mon['flip_sprite'] << 6 | mon.get('unk_21', 0)
    tms = sum(1 << TMS.index(tm) for tm in mon['learnset']['by_tm'])
    data = struct.pack('<6B2BBBH3HBBBB2B3BBHHBBHHH',
                       *stats,
                       *(c['pokemon_types'][t] for t in mon['types']),
                       mon['catch_rate'], mon['evolution_stage'], evs, *items,
                       c['gender_ratios'][mon['gender_ratio']], mon['hatch_cycles'],
                       mon['base_friendship'], c['exp_rates'][mon['exp_rate']],
                       *(c['egg_groups'][g] for g in mon['egg_groups']),
                       *(c['abilities'][a] for a in mon['abilities']),
                       mon['unk_1B'], form_base, mon['unk_1E'], mon['form_count'],
                       color, mon['base_exp_reward'],
                       mon['pokedex_data']['height'], mon['pokedex_data']['weight'])
    data += tms.to_bytes(16, 'little') + struct.pack('<I', mon['tutor_flags'])
    return data[:mon.get('personal_size', PERSONAL_SIZE)]


def pack_learnset(mon, c):
    data = b''.join(struct.pack('<HH', c['moves'][move], level) for level, move in mon['learnset']['by_level'])
    return data + struct.pack('<HH', LEARNSET_END, LEARNSET_END)


def pack_evolutions(mon, c):
    data = b''
    for evo in mon['evolutions']:
        method, *param, target = evo
        kind = EVO_PARAMS.get(method)
        value = c[PARAM_TABLES[kind]][param[0]] if param and kind in PARAM_TABLES else (param[0] if param else 0)
        data += struct.pack('<HHH', c['evolution_methods'][method], value, c['species'][target])
    return data + bytes(NUM_EVOLUTIONS * 6 - len(data))


def pack_egg_moves(mon, c):
    if 'egg_moves' not in mon['learnset']:
        return b''
    moves = [c['moves'][m] for m in mon['learnset']['egg_moves']]
    return struct.pack(f'<H{len(moves)}H', len(moves), *moves)


def load_species(c):
    mons = []
    for ident in c['species'].names:
        path = os.path.join(species_dir(ident), 'data.json')
        if not os.path.exists(path):
            break
        mons.append(load_json(path))
    registry = load_json(os.path.join(POKEMON_DIR, 'form_registry.json'))
    forms = []
    form_bases = {}
    for species, entries in registry.items():
        for form, kind in entries.items():
            if kind != 'data':
                continue
            form_bases.setdefault(species, len(mons) + len(forms))
            forms.append(load_json(os.path.join(POKEMON_DIR, species, 'forms', form, 'data.json')))
    return mons, forms, form_bases


def build(out_dir):
    c = load_constants()
    mons, forms, form_bases = load_species(c)
    names = [ident[len('SPECIES_'):].lower() for ident in c['species'].names]

    personal = [pack_personal(mon, c, form_bases.get(names[i], 0)) for i, mon in enumerate(mons)]
    personal += [pack_personal(form, c, 0) for form in forms]
    table = [PERSONAL_668_NONE] * len(mons)
    for number, ident in enumerate(load_json(os.path.join(POKEMON_DIR, 'personal_668.json'))):
        table[c['species'][ident]] = number
    personal.append(struct.pack(f'<{len(table)}H', *table))

    everything = mons + forms
    outputs = {
        PERSONAL_PATH: personal,
        LEARNSET_PATH: [pack_learnset(mon, c) for mon in everything],
        EVOLUTION_PATH: [pack_evolutions(mon, c) for mon in everything],
        OFFSPRING_PATH: [struct.pack('<H', c['species'][mon['offspring']]) for mon in mons],
        EGG_MOVES_PATH: [pack_egg_moves(mon, c) for mon in mons],
    }
    written = []
    for path, members in outputs.items():
        dest = os.path.join(out_dir, path)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        with open(dest, 'wb') as f:
            f.write(write_narc(members))
        written.append(path)
    return written


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-o', '--output', default=os.path.join(ROOT, 'build', 'files'),
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
