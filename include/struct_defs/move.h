#ifndef STRUCT_MOVE_H
#define STRUCT_MOVE_H

typedef struct {
    u8  type;                  // 0x00
    u8  category;              // 0x01
    u8  class;                 // 0x02
    u8  power;                 // 0x03
    u8  accuracy;              // 0x04
    u8  pp;                    // 0x05
    s8  priority;              // 0x06
    u8  minHits : 4;           // 0x07
    u8  maxHits : 4;           // 0x07
    u16 status;                // 0x08
    u8  statusChance;          // 0x0A
    u8  effectDuration;        // 0x0B
    u8  minTurns;              // 0x0C
    u8  maxTurns;              // 0x0D
    u8  critModifier;          // 0x0E
    u8  flinchChance;          // 0x0F
    u16 aiScript;              // 0x10
    u8  recoveryByDamage;      // 0x12
    u8  recoveryByMaxHP;       // 0x13
    u8  range;                 // 0x14
    u8  stats[3];              // 0x17
    s8  statChanges[3];        // 0x1A
    u8  statChangeChances[3];  // 0x1D
    u16 unk_1E;                // 0x1E (Set to 0x5353 for every single move)
    u32 flags;                 // 0x20
} MoveData;

#endif // STRUCT_MOVE_H
