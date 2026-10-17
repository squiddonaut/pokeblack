#include "battle_adapter_c.h"

void FUN_overlay_d_93__021eead0(void *obj)
{
    u8 val = ((u8*)obj)[0xc];
    ((u8*)obj)[0xe] = (u8)0x0;
    ((u8*)obj)[0xf] = (u8)0x0;
    val &= ~0xf;
    ((u8*)obj)[0xc] = val; 
}
