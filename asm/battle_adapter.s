	.include "macros/function.inc"

	.extern ADDR_0201EF40
	.extern ADDR_020307B0
	.extern ADDR_021EF204
	.extern ADDR_021EF3A4
	.extern ADDR_021EF460
	.extern ADDR_021EF508
	.extern ADDR_021EF594
	.extern ADDR_021F39A0
	.extern ADDR_021F39D8
	.extern ADDR_021F39DC
	.extern ADDR_021F6384
	.extern ADDR_021F6388
	.extern ADDR_021F6398
	.extern ADDR_021F63C8
	.extern ADDR_021F63D8
	.extern BattleMon_GetPokemon
	.extern BattleMon_GetVisibleMon
	.extern battle_adapter_data
	.extern FUN_0201D5C4
	.extern FUN_0201D5CC
	.extern FUN_0201D5F4
	.extern FUN_0201D658
	.extern FUN_0201D670
	.extern FUN_0201D688
	.extern FUN_0201EC64
	.extern FUN_0201ED04
	.extern FUN_0201EE0C
	.extern FUN_0201EE84
	.extern FUN_0201EEF4
	.extern FUN_0201EF34
	.extern FUN_0201EF40
	.extern FUN_0201EF8C
	.extern FUN_0201EFA4
	.extern FUN_0201F020
	.extern FUN_0201F02C
	.extern FUN_0201F0F8
	.extern FUN_0201F134
	.extern FUN_0201F250
	.extern FUN_0202A3CC
	.extern FUN_020457B0
	.extern FUN_02045808
	.extern FUN_02045A90
	.extern FUN_02045A98
	.extern FUN_02045B38
	.extern FUN_02045C04
	.extern FUN_02045CAC
	.extern FUN_02082D44
	.extern FUN_overlay_d_93__021b86b8
	.extern FUN_overlay_d_93__021b8bd0
	.extern FUN_overlay_d_93__021b8ce8
	.extern FUN_overlay_d_93__021b9940
	.extern FUN_overlay_d_93__021b9f70
	.extern FUN_overlay_d_93__021b9fac
	.extern FUN_overlay_d_93__021ba004
	.extern FUN_overlay_d_93__021ba020
	.extern FUN_overlay_d_93__021ba064
	.extern FUN_overlay_d_93__021ba080
	.extern FUN_overlay_d_93__021ba1a8
	.extern FUN_overlay_d_93__021d4b58
	.extern FUN_overlay_d_93__021d4b98
	.extern FUN_overlay_d_93__021d4bd4
	.extern FUN_overlay_d_93__021d4c60
	.extern FUN_overlay_d_93__021d4c6c
	.extern FUN_overlay_d_93__021d4c84
	.extern Heap_AllocDebug
	.extern Heap_Free
	.extern _021F39A0
	.extern _021F39D8
	.extern _021F39DC
	.extern _021F3AE8
	.extern thunk_FUN_overlay_d_93__021b8d08
	.extern thunk_FUN_overlay_d_93__021d4cec

	.text
	thumb_func_start FUN_overlay_d_93__021eea30
FUN_overlay_d_93__021eea30: ; 0x021EEA30
	push {r3, r4}
	mov r4, #0
	ldr r1, _021EEA4C ; =0x021F6388
	add r3, r4, #0
	thumb_func_end FUN_overlay_d_93__021eea30
_021EEA38:
	lsl r2, r4, #2
	add r4, r4, #1
	str r3, [r1, r2]
	cmp r4, #4
	blt _021EEA38
	ldr r1, _021EEA50 ; =0x021F6384
	str r0, [r1]
	pop {r3, r4}
	bx lr
	nop
_021EEA4C:
	.word ADDR_021F6388
_021EEA50:
	.word ADDR_021F6384

	thumb_func_start FUN_overlay_d_93__021eea54
FUN_overlay_d_93__021eea54: ; 0x021EEA54
	bx lr
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021eea54

	thumb_func_start FUN_overlay_d_93__021eea58
FUN_overlay_d_93__021eea58: ; 0x021EEA58
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r1, #0
	ldr r6, _021EEAC4 ; =0x021F6388
	lsl r4, r5, #2
	ldr r1, [r6, r4]
	add r7, r0, #0
	mov r0, #0
	str r2, [sp, #4]
	cmp r1, #0
	bne _021EEAA6
	mov r0, #0x7e
	str r0, [sp]
	add r0, r3, #0
	mov r1, #0xbd
	ldr r3, _021EEAC8 ; =_021F3AE8
	lsl r1, r1, #4
	mov r2, #1
	blx Heap_AllocDebug
	str r7, [r0]
	strb r5, [r0, #0xd]
	ldrb r1, [r0, #0xc]
	mov r2, #0xf0
	bic r1, r2
	ldr r2, [sp, #4]
	lsl r2, r2, #0x18
	lsr r2, r2, #0x18
	lsl r2, r2, #0x1c
	lsr r2, r2, #0x18
	orr r1, r2
	strb r1, [r0, #0xc]
	mov r1, #0
	strb r1, [r0, #0xe]
	strb r1, [r0, #0xf]
	ldrb r2, [r0, #0xc]
	mov r1, #0xf
	bic r2, r1
	strb r2, [r0, #0xc]
	thumb_func_end FUN_overlay_d_93__021eea58
_021EEAA6:
	ldr r1, _021EEACC ; =0x021F6384
	ldr r1, [r1]
	cmp r1, #0
	bne _021EEABC
	ldr r1, [r6, r4]
	cmp r1, #0
	bne _021EEAB6
	str r0, [r6, r4]
_021EEAB6:
	add sp, #8
	ldr r0, [r6, r4]
	pop {r3, r4, r5, r6, r7, pc}
_021EEABC:
	str r0, [r6, r4]
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EEAC4:
	.word ADDR_021F6388
_021EEAC8: .word battle_adapter_data
_021EEACC:
	.word ADDR_021F6384
