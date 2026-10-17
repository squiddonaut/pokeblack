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
	.extern thunk_FUN_overlay_d_93__021b8d08
	.extern thunk_FUN_overlay_d_93__021d4cec

	.text
	thumb_func_start FUN_021EEAE0
FUN_021EEAE0: ; 0x021EEAE0
	ldr r3, _021EEAE4 ; =Heap_Free
	bx r3
	.balign 4, 0
	thumb_func_end FUN_021EEAE0
_021EEAE4:
	.word ADDR_020307B0

	thumb_func_start FUN_overlay_d_93__021eeae8
FUN_overlay_d_93__021eeae8: ; 0x021EEAE8
	push {r3, lr}
	ldr r0, _021EEAF8 ; =0x021F6384
	ldr r0, [r0]
	cmp r0, #0
	beq _021EEAF6
	bl thunk_FUN_overlay_d_93__021d4cec
	thumb_func_end FUN_overlay_d_93__021eeae8
_021EEAF6:
	pop {r3, pc}
	.balign 4, 0
_021EEAF8:
	.word ADDR_021F6384

	thumb_func_start FUN_overlay_d_93__021eeafc
FUN_overlay_d_93__021eeafc: ; 0x021EEAFC
	bx lr
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021eeafc

	thumb_func_start FUN_overlay_d_93__021eeb00
FUN_overlay_d_93__021eeb00: ; 0x021EEB00
	push {r4, lr}
	add r4, r0, #0
	mov r0, #1
	strb r0, [r4, #0xe]
	add r0, r2, #0
	strb r1, [r4, #0xf]
	strh r1, [r4, #0x10]
	add r1, r4, #0
	add r1, #0x14
	add r2, r3, #0
	strh r3, [r4, #0x12]
	blx FUN_02082D44
	mov r0, #0
	ldrb r1, [r4, #0xc]
	str r0, [r4, #4]
	str r0, [r4, #8]
	mov r0, #0xf
	bic r1, r0
	strb r1, [r4, #0xc]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021eeb00

	thumb_func_start FUN_overlay_d_93__021eeb2c
FUN_overlay_d_93__021eeb2c: ; 0x021EEB2C
	push {r4, lr}
	add r4, r0, #0
	ldrb r1, [r4, #0xe]
	cmp r1, #1
	beq _021EEB40
	cmp r1, #3
	beq _021EEB4C
	cmp r1, #4
	beq _021EEB5A
	b _021EEB5E
	thumb_func_end FUN_overlay_d_93__021eeb2c
_021EEB40:
	bl FUN_overlay_d_93__021eeb84
	cmp r0, #0
	beq _021EEB5E
	mov r0, #3
	strb r0, [r4, #0xe]
_021EEB4C:
	add r0, r4, #0
	bl FUN_overlay_d_93__021eeba4
	cmp r0, #0
	beq _021EEB5E
	mov r0, #4
	strb r0, [r4, #0xe]
_021EEB5A:
	mov r0, #1
	pop {r4, pc}
_021EEB5E:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0

	thumb_func_start FUN_overlay_d_93__021eeb64
FUN_overlay_d_93__021eeb64: ; 0x021EEB64
	cmp r1, #0
	beq _021EEB6C
	ldr r2, [r0, #8]
	str r2, [r1]
	thumb_func_end FUN_overlay_d_93__021eeb64
_021EEB6C:
	ldr r0, [r0, #4]
	bx lr

	thumb_func_start FUN_overlay_d_93__021eeb70
FUN_overlay_d_93__021eeb70: ; 0x021EEB70
	push {r3, lr}
	mov r1, #0
	strb r1, [r0, #0xe]
	ldrb r0, [r0, #0xc]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1c
	beq _021EEB82
	bl thunk_FUN_overlay_d_93__021d4cec
	thumb_func_end FUN_overlay_d_93__021eeb70
_021EEB82:
	pop {r3, pc}

	thumb_func_start FUN_overlay_d_93__021eeb84
FUN_overlay_d_93__021eeb84: ; 0x021EEB84
	push {r3, lr}
	ldrb r1, [r0, #0xc]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1c
	beq _021EEB9E
	add r1, r0, #0
	add r1, #0x10
	ldrh r2, [r1, #2]
	ldrb r0, [r0, #0xd]
	add r2, r2, #4
	bl FUN_overlay_d_93__021d4b58
	pop {r3, pc}
	thumb_func_end FUN_overlay_d_93__021eeb84
_021EEB9E:
	mov r0, #1
	pop {r3, pc}
	.balign 4, 0

	thumb_func_start FUN_overlay_d_93__021eeba4
FUN_overlay_d_93__021eeba4: ; 0x021EEBA4
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xc]
	lsl r1, r0, #0x18
	lsr r1, r1, #0x1c
	beq _021EEBD4
	bl FUN_overlay_d_93__021d4b98
	cmp r0, #0
	beq _021EEBD0
	ldrb r0, [r4, #0xd]
	add r1, r4, #4
	bl FUN_overlay_d_93__021d4bd4
	str r0, [r4, #8]
	ldrb r1, [r4, #0xc]
	mov r0, #0xf
	bic r1, r0
	mov r0, #1
	orr r1, r0
	strb r1, [r4, #0xc]
	pop {r4, pc}
	thumb_func_end FUN_overlay_d_93__021eeba4
_021EEBD0:
	mov r0, #0
	pop {r4, pc}
_021EEBD4:
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	pop {r4, pc}
	.balign 4, 0

	thumb_func_start FUN_overlay_d_93__021eebdc
FUN_overlay_d_93__021eebdc: ; 0x021EEBDC
	mov r1, #0
	strh r1, [r0, #0x10]
	mov r1, #4
	strh r1, [r0, #0x12]
	bx lr
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021eebdc

	thumb_func_start FUN_overlay_d_93__021eebe8
FUN_overlay_d_93__021eebe8: ; 0x021EEBE8
	push {r3, lr}
	ldrb r1, [r0, #0xc]
	lsl r2, r1, #0x18
	lsr r2, r2, #0x1c
	beq _021EEC0E
	bl FUN_overlay_d_93__021d4c60
	cmp r0, #0
	beq _021EEC0A
	add r0, sp, #0
	bl FUN_overlay_d_93__021d4c6c
	ldr r0, [sp]
	ldrh r0, [r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r3, pc}
	thumb_func_end FUN_overlay_d_93__021eebe8
_021EEC0A:
	mov r0, #0
	pop {r3, pc}
_021EEC0E:
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	bne _021EEC1C
	ldrh r0, [r0, #0x10]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r3, pc}
_021EEC1C:
	mov r0, #0
	pop {r3, pc}

	thumb_func_start FUN_overlay_d_93__021eec20
FUN_overlay_d_93__021eec20: ; 0x021EEC20
	push {r3, r4, lr}
	sub sp, #4
	add r4, r1, #0
	ldrb r1, [r0, #0xc]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1c
	beq _021EEC40
	add r0, sp, #0
	bl FUN_overlay_d_93__021d4c6c
	ldr r1, [sp]
	add sp, #4
	add r0, r1, #4
	str r0, [r4]
	ldrh r0, [r1, #2]
	pop {r3, r4, pc}
	thumb_func_end FUN_overlay_d_93__021eec20
_021EEC40:
	add r1, r0, #0
	add r1, #0x14
	str r1, [r4]
	ldrh r0, [r0, #0x12]
	add sp, #4
	pop {r3, r4, pc}

	thumb_func_start FUN_overlay_d_93__021eec4c
FUN_overlay_d_93__021eec4c: ; 0x021EEC4C
	push {r4, lr}
	ldrb r3, [r0, #0xc]
	lsl r4, r3, #0x18
	lsr r4, r4, #0x1c
	beq _021EEC60
	add r0, r1, #0
	add r1, r2, #0
	bl FUN_overlay_d_93__021d4c84
	pop {r4, pc}
	thumb_func_end FUN_overlay_d_93__021eec4c
_021EEC60:
	lsl r4, r3, #0x1c
	lsr r4, r4, #0x1c
	bne _021EEC74
	str r1, [r0, #4]
	mov r1, #0xf
	bic r3, r1
	mov r1, #1
	orr r1, r3
	str r2, [r0, #8]
	strb r1, [r0, #0xc]
_021EEC74:
	mov r0, #1
	pop {r4, pc}

	thumb_func_start FUN_overlay_d_93__021eec78
FUN_overlay_d_93__021eec78: ; 0x021EEC78
	push {r3, r4, r5, r6, r7, lr}
	ldr r6, _021EECCC ; =0x021F6398
	ldr r7, _021EECD0 ; =0x021F63D8
	str r0, [r6]
	add r5, r3, #0
	str r2, [r6, #4]
	strh r5, [r7, #0x10]
	str r1, [r6, #0x54]
	mov r1, #2
	lsl r1, r1, #8
	bl FUN_overlay_d_93__021ba1a8
	strh r0, [r7, #0x18]
	mov r4, #0
	strh r4, [r7, #0x1a]
	add r0, r5, #0
	bl FUN_0201EC64
	str r0, [r6, #8]
	mov r0, #2
	lsl r0, r0, #8
	lsr r0, r0, #1
	add r1, r5, #0
	blx FUN_020457B0
	ldr r7, _021EECD4 ; =_021F3990
	str r0, [r6, #0xc]
	thumb_func_end FUN_overlay_d_93__021eec78
_021EECAE:
	lsl r2, r4, #1
	ldrh r2, [r7, r2]
	mov r0, #0
	mov r1, #2
	add r3, r5, #0
	blx FUN_02045B38
	lsl r1, r4, #2
	add r1, r6, r1
	add r4, r4, #1
	str r0, [r1, #0x10]
	cmp r4, #8
	blt _021EECAE
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EECCC:
	.word ADDR_021F6398
_021EECD0:
	.word ADDR_021F63D8
_021EECD4: .word _021F3990

	thumb_func_start FUN_overlay_d_93__021eecd8
FUN_overlay_d_93__021eecd8: ; 0x021EECD8
	push {r3, r4, r5, lr}
	ldr r4, _021EECFC ; =0x021F6398
	ldr r0, [r4, #8]
	bl FUN_0201ED04
	ldr r0, [r4, #0xc]
	blx FUN_02045808
	mov r5, #0
	thumb_func_end FUN_overlay_d_93__021eecd8
_021EECEA:
	lsl r0, r5, #2
	add r0, r4, r0
	ldr r0, [r0, #0x10]
	blx FUN_02045C04
	add r5, r5, #1
	cmp r5, #8
	blt _021EECEA
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EECFC:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021eed00
FUN_overlay_d_93__021eed00: ; 0x021EED00
	push {r3, r4, r5, lr}
	ldr r4, _021EED20 ; =0x021F6398
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r5, r1, #0
	add r1, r2, #0
	bl FUN_overlay_d_93__021b9940
	bl BattleMon_GetVisibleMon
	add r2, r0, #0
	ldr r0, [r4, #8]
	add r1, r5, #0
	bl FUN_0201EEF4
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021eed00
_021EED20:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021eed24
FUN_overlay_d_93__021eed24: ; 0x021EED24
	push {r3, r4, r5, lr}
	ldr r4, _021EED44 ; =0x021F6398
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r5, r1, #0
	add r1, r2, #0
	bl FUN_overlay_d_93__021b9940
	bl BattleMon_GetPokemon
	add r2, r0, #0
	ldr r0, [r4, #8]
	add r1, r5, #0
	bl FUN_0201EEF4
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021eed24
_021EED44:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021eed48
FUN_overlay_d_93__021eed48: ; 0x021EED48
	push {r3, r4, r5, lr}
	ldr r4, _021EED68 ; =0x021F6398
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r5, r1, #0
	add r1, r2, #0
	bl FUN_overlay_d_93__021b9940
	bl BattleMon_GetVisibleMon
	add r2, r0, #0
	ldr r0, [r4, #8]
	add r1, r5, #0
	bl FUN_0201EE84
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021eed48
_021EED68:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021eed6c
FUN_overlay_d_93__021eed6c: ; 0x021EED6C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021EED8C ; =0x021F6398
	add r4, r1, #0
	ldr r0, [r0]
	add r1, r2, #0
	bl FUN_overlay_d_93__021ba020
	add r2, r0, #0
	lsl r2, r2, #0x18
	add r0, r5, #0
	add r1, r4, #0
	lsr r2, r2, #0x18
	bl FUN_0201F0F8
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021eed6c
_021EED8C:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021eed90
FUN_overlay_d_93__021eed90: ; 0x021EED90
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r2, #0
	add r5, r0, #0
	add r4, r1, #0
	cmp r6, #4
	beq _021EEE0A
	ldr r7, _021EEE20 ; =0x021F6398
	add r1, r6, #0
	ldr r0, [r7]
	bl FUN_overlay_d_93__021b9f70
	cmp r0, #0
	ldr r0, [r7]
	beq _021EEDF6
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #1
	ldr r0, [r7]
	bne _021EEDCE
	add r1, r6, #0
	bl FUN_overlay_d_93__021ba004
	add r2, r0, #0
	beq _021EEE1C
	add r0, r5, #0
	add r1, r4, #0
	bl FUN_0201F134
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end FUN_overlay_d_93__021eed90
_021EEDCE:
	add r1, r6, #0
	add r2, sp, #8
	bl FUN_overlay_d_93__021b9fac
	add r6, r0, #0
	ldr r0, [sp, #8]
	bl FUN_0202A3CC
	add r3, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl FUN_0201EE0C
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_021EEDF6:
	add r1, r6, #0
	bl FUN_overlay_d_93__021ba064
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl FUN_0201F02C
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_021EEE0A:
	ldr r0, _021EEE20 ; =0x021F6398
	ldr r0, [r0]
	bl FUN_overlay_d_93__021ba080
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl FUN_0201F02C
_021EEE1C:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021EEE20:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021eee24
FUN_overlay_d_93__021eee24: ; 0x021EEE24
	push {r0, r1, r2, r3}
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	add r7, r1, #0
	add r1, sp, #0x20
	mov r0, #3
	bic r1, r0
	ldr r3, [sp, #0x20]
	add r1, r1, #4
	mov r2, #0
	cmp r3, #0
	bls _021EEE50
	ldr r6, _021EEE78 ; =0x021F6398
	thumb_func_end FUN_overlay_d_93__021eee24
_021EEE3E:
	add r1, r1, #4
	sub r0, r1, #4
	lsl r5, r2, #2
	ldr r0, [r0]
	add r5, r6, r5
	add r2, r2, #1
	str r0, [r5, #0x30]
	cmp r2, r3
	blo _021EEE3E
_021EEE50:
	cmp r2, #8
	bhs _021EEE64
	ldr r1, _021EEE78 ; =0x021F6398
	mov r3, #0
_021EEE58:
	lsl r0, r2, #2
	add r0, r1, r0
	add r2, r2, #1
	str r3, [r0, #0x30]
	cmp r2, #8
	blo _021EEE58
_021EEE64:
	ldr r2, _021EEE7C ; =0x021F63C8
	add r0, r4, #0
	add r1, r7, #0
	bl FUN_overlay_d_93__021eee80
	pop {r3, r4, r5, r6, r7}
	pop {r3}
	add sp, #0x10
	bx r3
	nop
_021EEE78:
	.word ADDR_021F6398
_021EEE7C:
	.word ADDR_021F63C8

	thumb_func_start FUN_overlay_d_93__021eee80
FUN_overlay_d_93__021eee80: ; 0x021EEE80
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r4, r2, #0
	ldr r1, _021EEEC0 ; =_021F39A0
	add r6, r0, #0
	mov r2, #0
	thumb_func_end FUN_overlay_d_93__021eee80
_021EEE8C:
	lsl r0, r2, #1
	ldrh r0, [r1, r0]
	cmp r5, r0
	bne _021EEEAE
	ldr r0, _021EEEC4 ; =0x021F6398
	ldr r1, [r4]
	ldr r0, [r0]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FUN_overlay_d_93__021b8bd0
	cmp r0, #0
	bne _021EEEB4
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	b _021EEEB4
_021EEEAE:
	add r2, r2, #1
	cmp r2, #0x1b
	blo _021EEE8C
_021EEEB4:
	add r0, r6, #0
	add r1, r5, #0
	add r2, r4, #0
	bl FUN_overlay_d_93__021eeec8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EEEC0:
	.word ADDR_021F39A0
_021EEEC4:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021eeec8
FUN_overlay_d_93__021eeec8: ; 0x021EEEC8
	push {r4, r5, r6, lr}
	ldr r4, _021EEEF0 ; =0x021F6398
	add r5, r0, #0
	add r6, r2, #0
	ldr r0, [r4, #0x10]
	ldr r2, [r4, #0xc]
	blx FUN_02045CAC
	ldr r0, [r4, #0xc]
	ldr r2, [r4, #8]
	add r1, r6, #0
	bl FUN_overlay_d_93__021eefe0
	ldr r0, [r4, #8]
	ldr r2, [r4, #0xc]
	add r1, r5, #0
	bl FUN_0201F250
	pop {r4, r5, r6, pc}
	nop
	thumb_func_end FUN_overlay_d_93__021eeec8
_021EEEF0:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021eeef4
FUN_overlay_d_93__021eeef4: ; 0x021EEEF4
	push {r4, r5, r6, lr}
	ldr r4, _021EEF18 ; =_021F39D8
	mov r6, #0
	thumb_func_end FUN_overlay_d_93__021eeef4
_021EEEFA:
	lsl r5, r6, #3
	ldrh r3, [r4, r5]
	cmp r1, r3
	bne _021EEF0A
	ldr r3, _021EEF1C ; =_021F39DC
	ldr r3, [r3, r5]
	blx r3
	pop {r4, r5, r6, pc}
_021EEF0A:
	add r6, r6, #1
	cmp r6, #0xe
	blo _021EEEFA
	bl FUN_overlay_d_93__021ef1cc
	pop {r4, r5, r6, pc}
	nop
_021EEF18:
	.word ADDR_021F39D8
_021EEF1C:
	.word ADDR_021F39DC

	thumb_func_start FUN_overlay_d_93__021eef20
FUN_overlay_d_93__021eef20: ; 0x021EEF20
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	add r7, r1, #0
	str r2, [sp]
	str r3, [sp, #4]
	cmp r5, #0
	beq _021EEF90
	blx FUN_02045A98
	add r4, r0, #0
	bl FUN_0201D5C4
	add r6, r0, #0
	ldrh r0, [r5]
	cmp r0, r4
	beq _021EEF8A
	thumb_func_end FUN_overlay_d_93__021eef20
_021EEF42:
	cmp r0, r6
	bne _021EEF82
	add r0, r5, #0
	bl FUN_0201D5CC
	cmp r0, #0
	beq _021EEF78
	add r0, r5, #0
	mov r1, #0
	bl FUN_0201D670
	ldr r1, [sp, #4]
	strb r0, [r1]
	add r0, r5, #0
	bl FUN_0201D5F4
	str r0, [r7]
	add r0, r5, #0
	bl FUN_0201D658
	ldr r1, [sp]
	strh r0, [r1]
	add r0, r5, #0
	bl FUN_0201D688
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_021EEF78:
	add r0, r5, #0
	bl FUN_0201D688
	add r5, r0, #0
	b _021EEF84
_021EEF82:
	add r5, r5, #2
_021EEF84:
	ldrh r0, [r5]
	cmp r0, r4
	bne _021EEF42
_021EEF8A:
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021EEF90:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0

	thumb_func_start FUN_overlay_d_93__021eef98
FUN_overlay_d_93__021eef98: ; 0x021EEF98
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	blx FUN_02045A90
	mov r5, #0
	cmp r0, #0
	beq _021EEFDA
	add r7, sp, #0
	add r6, sp, #4
	add r7, #2
	add r4, sp, #0
	thumb_func_end FUN_overlay_d_93__021eef98
_021EEFAE:
	add r1, r6, #0
	add r2, r7, #0
	add r3, sp, #0
	bl FUN_overlay_d_93__021eef20
	cmp r0, #0
	beq _021EEFD6
	ldr r1, [sp, #4]
	cmp r1, #1
	bne _021EEFD6
	ldrh r1, [r4, #2]
	cmp r1, #1
	beq _021EEFD0
	cmp r1, #2
	beq _021EEFD0
	cmp r1, #0xc
	bne _021EEFD6
_021EEFD0:
	add r1, r5, #1
	lsl r1, r1, #0x18
	lsr r5, r1, #0x18
_021EEFD6:
	cmp r0, #0
	bne _021EEFAE
_021EEFDA:
	add r0, r5, #0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}

	thumb_func_start FUN_overlay_d_93__021eefe0
FUN_overlay_d_93__021eefe0: ; 0x021EEFE0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	str r0, [sp, #8]
	add r6, r1, #0
	str r2, [sp, #0xc]
	blx FUN_02045A98
	str r0, [sp, #0x14]
	bl FUN_0201D5C4
	mov r2, #0
	str r0, [sp, #0x10]
	add r1, r2, #0
	add r0, sp, #0x18
	thumb_func_end FUN_overlay_d_93__021eefe0
_021EEFFC:
	strb r1, [r0, r2]
	add r2, r2, #1
	cmp r2, #8
	blo _021EEFFC
	ldr r0, [sp, #8]
	blx FUN_02045A90
	add r5, r0, #0
	ldrh r0, [r5]
	ldr r1, [sp, #0x14]
	cmp r0, r1
	beq _021EF06E
	add r4, sp, #0x18
_021EF016:
	ldr r1, [sp, #0x10]
	cmp r0, r1
	bne _021EF064
	add r0, r5, #0
	bl FUN_0201D5CC
	cmp r0, #0
	beq _021EF05A
	add r0, r5, #0
	mov r1, #0
	bl FUN_0201D670
	add r7, r0, #0
	add r0, r5, #0
	bl FUN_0201D5F4
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r0, #1
	bne _021EF05A
	add r0, r5, #0
	bl FUN_0201D658
	cmp r0, #0xe
	bne _021EF05A
	add r1, r7, #1
	cmp r1, #8
	bhs _021EF05A
_021EF04E:
	ldrb r0, [r4, r1]
	add r0, r0, #1
	strb r0, [r4, r1]
	add r1, r1, #1
	cmp r1, #8
	blo _021EF04E
_021EF05A:
	add r0, r5, #0
	bl FUN_0201D688
	add r5, r0, #0
	b _021EF066
_021EF064:
	add r5, r5, #2
_021EF066:
	ldrh r0, [r5]
	ldr r1, [sp, #0x14]
	cmp r0, r1
	bne _021EF016
_021EF06E:
	ldr r0, [sp, #8]
	blx FUN_02045A90
	add r7, r0, #0
	ldrh r1, [r7]
	ldr r0, [sp, #0x14]
	cmp r1, r0
	bne _021EF080
	b _021EF1C2
_021EF080:
	ldr r0, [sp, #0x10]
	cmp r1, r0
	beq _021EF088
	b _021EF1B6
_021EF088:
	add r0, r7, #0
	bl FUN_0201D5CC
	cmp r0, #0
	bne _021EF094
	b _021EF1AC
_021EF094:
	add r0, r7, #0
	mov r1, #0
	bl FUN_0201D670
	add r4, r0, #0
	add r0, r7, #0
	add r5, r4, #0
	bl FUN_0201D5F4
	add r1, sp, #0x18
	lsl r0, r0, #0x18
	ldrb r1, [r1, r4]
	lsr r0, r0, #0x18
	cmp r4, r1
	blo _021EF0B4
	sub r5, r4, r1
_021EF0B4:
	cmp r0, #2
	bne _021EF0DA
	add r0, r7, #0
	bl FUN_0201D658
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r3, r0, #0x18
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	lsl r2, r5, #2
	str r0, [sp, #4]
	ldr r0, [sp, #0xc]
	ldr r2, [r6, r2]
	add r1, r4, #0
	bl FUN_0201EFA4
	b _021EF1AC
_021EF0DA:
	add r0, r7, #0
	bl FUN_0201D658
	cmp r0, #0xf
	bhi _021EF1AC
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EF0F0: ; jump table
	.hword 0x0032 ; case 0
	.hword 0x0070 ; case 1
	.hword 0x0046 ; case 2
	.hword 0x0082 ; case 3
	.hword 0x00BA ; case 4
	.hword 0x00BA ; case 5
	.hword 0x0084 ; case 6
	.hword 0x0092 ; case 7
	.hword 0x00BA ; case 8
	.hword 0x00A0 ; case 9
	.hword 0x00BA ; case 10
	.hword 0x00BA ; case 11
	.hword 0x006E ; case 12
	.hword 0x00BA ; case 13
	.hword 0x001E ; case 14
	.hword 0x00AE ; case 15
_021EF110:
	lsl r2, r5, #2
	ldr r2, [r6, r2]
	lsl r1, r4, #0x18
	lsl r2, r2, #0x18
	ldr r0, [sp, #0xc]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	bl FUN_overlay_d_93__021eed6c
	b _021EF1AC
_021EF124:
	lsl r2, r5, #2
	ldr r2, [r6, r2]
	lsl r1, r4, #0x18
	lsl r2, r2, #0x18
	ldr r0, [sp, #0xc]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	bl FUN_overlay_d_93__021eed90
	b _021EF1AC
_021EF138:
	ldr r0, _021EF1C8 ; =0x021F63D8
	ldrh r0, [r0, #0x1a]
	cmp r0, #0
	bne _021EF150
	lsl r0, r5, #2
	ldr r0, [r6, r0]
	add r1, r4, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl FUN_overlay_d_93__021eed00
	b _021EF1AC
_021EF150:
	lsl r0, r5, #2
	ldr r0, [r6, r0]
	add r1, r4, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl FUN_overlay_d_93__021eed24
	b _021EF1AC
_021EF160:
	b _021EF150
_021EF162:
	lsl r0, r5, #2
	ldr r0, [r6, r0]
	lsl r1, r4, #0x18
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	lsr r1, r1, #0x18
	bl FUN_overlay_d_93__021eed48
	b _021EF1AC
_021EF174:
	b _021EF1A0
_021EF176:
	lsl r2, r5, #2
	ldr r0, [sp, #0xc]
	ldr r2, [r6, r2]
	add r1, r4, #0
	bl FUN_0201EF8C
	b _021EF1AC
_021EF184:
	lsl r2, r5, #2
	ldr r0, [sp, #0xc]
	ldr r2, [r6, r2]
	add r1, r4, #0
	bl FUN_0201EF34
	b _021EF1AC
_021EF192:
	lsl r2, r5, #2
	ldr r0, [sp, #0xc]
	ldr r2, [r6, r2]
	add r1, r4, #0
	bl FUN_0201EF40
	b _021EF1AC
_021EF1A0:
	lsl r2, r5, #2
	ldr r0, [sp, #0xc]
	ldr r2, [r6, r2]
	add r1, r4, #0
	bl FUN_0201F020
_021EF1AC:
	add r0, r7, #0
	bl FUN_0201D688
	add r7, r0, #0
	b _021EF1B8
_021EF1B6:
	add r7, r7, #2
_021EF1B8:
	ldrh r1, [r7]
	ldr r0, [sp, #0x14]
	cmp r1, r0
	beq _021EF1C2
	b _021EF080
_021EF1C2:
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EF1C8:
	.word ADDR_021F63D8

	thumb_func_start FUN_overlay_d_93__021ef1cc
FUN_overlay_d_93__021ef1cc: ; 0x021EF1CC
	push {r3, r4, r5, r6, r7, lr}
	ldr r7, _021EF200 ; =0x021F6398
	add r5, r0, #0
	add r6, r2, #0
	ldr r0, [r7, #0x14]
	ldr r2, [r7, #0xc]
	add r4, r1, #0
	blx FUN_02045CAC
	ldr r0, [r7, #0xc]
	bl FUN_overlay_d_93__021eef98
	cmp r0, #2
	bne _021EF1F4
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl FUN_overlay_d_93__021ef280
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end FUN_overlay_d_93__021ef1cc
_021EF1F4:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl FUN_overlay_d_93__021ef204
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EF200:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021ef204
FUN_overlay_d_93__021ef204: ; 0x021EF204
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	ldr r1, _021EF278 ; =0x021F63D8
	add r7, r2, #0
	add r6, r0, #0
	ldr r0, [r7]
	ldrh r1, [r1, #0x18]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r1, #0
	bne _021EF24E
	bl thunk_FUN_overlay_d_93__021b8d08
	ldr r5, _021EF27C ; =0x021F6398
	add r2, r0, #0
	ldr r1, [r5, #0x54]
	ldr r0, [r5]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FUN_overlay_d_93__021b8ce8
	cmp r0, #0
	beq _021EF24E
	ldr r0, [r5]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #0
	beq _021EF246
	ldr r0, [r5]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #4
	bne _021EF24A
	thumb_func_end FUN_overlay_d_93__021ef204
_021EF246:
	mov r1, #1
	b _021EF250
_021EF24A:
	mov r1, #2
	b _021EF250
_021EF24E:
	mov r1, #0
_021EF250:
	ldr r5, _021EF27C ; =0x021F6398
	add r1, r4, r1
	lsl r1, r1, #0x10
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0xc]
	lsr r1, r1, #0x10
	blx FUN_02045CAC
	ldr r0, [r5, #0xc]
	ldr r2, [r5, #8]
	add r1, r7, #0
	bl FUN_overlay_d_93__021eefe0
	ldr r0, [r5, #8]
	ldr r2, [r5, #0xc]
	add r1, r6, #0
	bl FUN_0201F250
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EF278:
	.word ADDR_021F63D8
_021EF27C:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021ef280
FUN_overlay_d_93__021ef280: ; 0x021EF280
	push {r3, r4, r5, r6, r7, lr}
	add r7, r2, #0
	str r0, [sp]
	ldr r0, [r7, #4]
	add r5, r1, #0
	ldr r1, _021EF39C ; =0x021F63D8
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	ldr r0, [r7]
	ldrh r1, [r1, #0x18]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r1, #0
	bne _021EF2D0
	bl thunk_FUN_overlay_d_93__021b8d08
	ldr r4, _021EF3A0 ; =0x021F6398
	add r2, r0, #0
	ldr r1, [r4, #0x54]
	ldr r0, [r4]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FUN_overlay_d_93__021b8ce8
	cmp r0, #0
	beq _021EF2D0
	ldr r0, [r4]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #0
	beq _021EF2C8
	ldr r0, [r4]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #4
	bne _021EF2CC
	thumb_func_end FUN_overlay_d_93__021ef280
_021EF2C8:
	mov r4, #1
	b _021EF2D2
_021EF2CC:
	mov r4, #2
	b _021EF2D2
_021EF2D0:
	mov r4, #0
_021EF2D2:
	cmp r4, #0
	beq _021EF2E0
	cmp r4, #1
	beq _021EF324
	cmp r4, #2
	beq _021EF328
	b _021EF32E
_021EF2E0:
	ldr r0, _021EF39C ; =0x021F63D8
	ldrh r0, [r0, #0x18]
	cmp r0, #0
	bne _021EF31E
	add r0, r6, #0
	bl thunk_FUN_overlay_d_93__021b8d08
	ldr r4, _021EF3A0 ; =0x021F6398
	add r2, r0, #0
	ldr r1, [r4, #0x54]
	ldr r0, [r4]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FUN_overlay_d_93__021b8ce8
	cmp r0, #0
	beq _021EF31E
	ldr r0, [r4]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #0
	beq _021EF316
	ldr r0, [r4]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #4
	bne _021EF31A
_021EF316:
	mov r0, #1
	b _021EF320
_021EF31A:
	mov r0, #2
	b _021EF320
_021EF31E:
	mov r0, #0
_021EF320:
	add r0, r5, r0
	b _021EF374
_021EF324:
	add r0, r5, #3
	b _021EF32A
_021EF328:
	add r0, r5, #5
_021EF32A:
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
_021EF32E:
	ldr r0, _021EF39C ; =0x021F63D8
	ldrh r0, [r0, #0x18]
	cmp r0, #0
	bne _021EF36C
	add r0, r6, #0
	bl thunk_FUN_overlay_d_93__021b8d08
	ldr r6, _021EF3A0 ; =0x021F6398
	add r2, r0, #0
	ldr r1, [r6, #0x54]
	ldr r0, [r6]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FUN_overlay_d_93__021b8ce8
	cmp r0, #0
	beq _021EF36C
	ldr r0, [r6]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #0
	beq _021EF364
	ldr r0, [r6]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #4
	bne _021EF368
_021EF364:
	mov r0, #1
	b _021EF36E
_021EF368:
	mov r0, #2
	b _021EF36E
_021EF36C:
	mov r0, #0
_021EF36E:
	cmp r4, r0
	bne _021EF378
	add r0, r5, #1
_021EF374:
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
_021EF378:
	ldr r4, _021EF3A0 ; =0x021F6398
	add r1, r5, #0
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0xc]
	blx FUN_02045CAC
	ldr r0, [r4, #0xc]
	ldr r2, [r4, #8]
	add r1, r7, #0
	bl FUN_overlay_d_93__021eefe0
	ldr r0, [r4, #8]
	ldr r1, [sp]
	ldr r2, [r4, #0xc]
	bl FUN_0201F250
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EF39C:
	.word ADDR_021F63D8
_021EF3A0:
	.word ADDR_021F6398
_021EF3A4:
	.byte 0xF8, 0xB5, 0x14, 0x1C, 0x00, 0x90, 0xA0, 0x68, 0x0D, 0x1C, 0x40, 0x1E
	.byte 0x00, 0x06, 0x07, 0x0E, 0xE0, 0x68, 0x00, 0x21, 0x03, 0x28, 0x00, 0xDB, 0x02, 0x21, 0x02, 0x28
	.byte 0x00, 0xD1, 0x01, 0x21, 0x15, 0x20, 0x48, 0x43, 0x00, 0x04, 0x00, 0x0C, 0x28, 0x18, 0x22, 0x49
	.byte 0x00, 0x04, 0x05, 0x0C, 0x20, 0x68, 0x09, 0x8B, 0x00, 0x06, 0x00, 0x0E, 0x00, 0x29, 0x19, 0xD1
	.byte 0xC9, 0xF7, 0xFC, 0xFC, 0x1D, 0x4E, 0x02, 0x1C, 0x71, 0x6D, 0x30, 0x68, 0x09, 0x06, 0x09, 0x0E
	.byte 0xC9, 0xF7, 0x7A, 0xFC, 0x00, 0x28, 0x0D, 0xD0, 0x30, 0x68, 0xC9, 0xF7, 0x5D, 0xF9, 0x00, 0x28
	.byte 0x04, 0xD0, 0x30, 0x68, 0xC9, 0xF7, 0x58, 0xF9, 0x04, 0x28, 0x01, 0xD1, 0x01, 0x26, 0x02, 0xE0
	.byte 0x02, 0x26, 0x00, 0xE0, 0x00, 0x26, 0x20, 0x68, 0x00, 0x21, 0x00, 0x06, 0x00, 0x0E, 0xFF, 0xF7
	.byte 0x6F, 0xFC, 0x0E, 0x48, 0x62, 0x68, 0x80, 0x68, 0x01, 0x21
	bl ADDR_0201EF40
	.byte 0x79, 0x00
	.byte 0x79, 0x18, 0x0A, 0x48, 0x69, 0x18, 0x09, 0x4A, 0x89, 0x19, 0x09, 0x04, 0x40, 0x69, 0xD2, 0x68
	.byte 0x09, 0x0C
	blx FUN_02045CAC
	.byte 0x05, 0x48, 0x04, 0x4A, 0x80, 0x68, 0x00, 0x99, 0xD2, 0x68
	bl FUN_0201F250
	.byte 0xF8, 0xBD, 0xC0, 0x46
	.word ADDR_021F63D8
	.word ADDR_021F6398
	.byte 0xF8, 0xB5, 0x14, 0x1C, 0x07, 0x1C, 0x60, 0x68, 0x0D, 0x1C, 0x40, 0x1E, 0x00, 0x06, 0x06, 0x0E
	.byte 0xA0, 0x68, 0x00, 0x21, 0x03, 0x28, 0x00, 0xDB, 0x02, 0x21

	non_word_aligned_thumb_func_start LAB_overlay_d_93__021ef47a
LAB_overlay_d_93__021ef47a: ; 0x021EF47A
	cmp r0, #2
	bne _021EF480
	mov r1, #1
	thumb_func_end LAB_overlay_d_93__021ef47a
_021EF480:
	mov r0, #0x15
	mul r0, r1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	add r0, r5, r0
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	ldr r0, [r4]
	mov r1, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl FUN_overlay_d_93__021eed00
	ldr r1, _021EF500 ; =0x021F63D8
	ldr r0, [r4]
	ldrh r1, [r1, #0x18]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r1, #0
	bne _021EF4DC
	bl thunk_FUN_overlay_d_93__021b8d08
	ldr r4, _021EF504 ; =0x021F6398
	add r2, r0, #0
	ldr r1, [r4, #0x54]
	ldr r0, [r4]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FUN_overlay_d_93__021b8ce8
	cmp r0, #0
	beq _021EF4DC
	ldr r0, [r4]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #0
	beq _021EF4D4
	ldr r0, [r4]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #4
	bne _021EF4D8
_021EF4D4:
	mov r1, #1
	b _021EF4DE
_021EF4D8:
	mov r1, #2
	b _021EF4DE
_021EF4DC:
	mov r1, #0
_021EF4DE:
	lsl r2, r6, #1
	add r2, r6, r2
	ldr r4, _021EF504 ; =0x021F6398
	add r2, r5, r2
	add r1, r2, r1
	lsl r1, r1, #0x10
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0xc]
	lsr r1, r1, #0x10
	blx FUN_02045CAC
	ldr r0, [r4, #8]
	ldr r2, [r4, #0xc]
	add r1, r7, #0
	bl FUN_0201F250
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EF500:
	.word ADDR_021F63D8
_021EF504:
	.word ADDR_021F6398
_021EF508:
	.byte 0xF8, 0xB5, 0x14, 0x1C, 0x07, 0x1C, 0x60, 0x68
	.byte 0x0E, 0x1C, 0x40, 0x1E, 0x00, 0x06, 0x05, 0x0E, 0x20, 0x68, 0x00, 0x21, 0x00, 0x06, 0x00, 0x0E
	.byte 0xFF, 0xF7, 0xEE, 0xFB, 0x19, 0x49, 0x20, 0x68, 0x09, 0x8B, 0x00, 0x06, 0x00, 0x0E, 0x00, 0x29
	.byte 0x19, 0xD1, 0xC9, 0xF7, 0x53, 0xFC, 0x16, 0x4C, 0x02, 0x1C, 0x61, 0x6D, 0x20, 0x68, 0x09, 0x06
	.byte 0x09, 0x0E, 0xC9, 0xF7, 0xD1, 0xFB, 0x00, 0x28, 0x0D, 0xD0, 0x20, 0x68, 0xC9, 0xF7, 0xB4, 0xF8
	.byte 0x00, 0x28, 0x04, 0xD0, 0x20, 0x68, 0xC9, 0xF7, 0xAF, 0xF8, 0x04, 0x28, 0x01, 0xD1, 0x01, 0x21
	.byte 0x02, 0xE0, 0x02, 0x21, 0x00, 0xE0, 0x00, 0x21, 0x6A, 0x00, 0xAA, 0x18, 0x08, 0x4C, 0xB2, 0x18
	.byte 0x51, 0x18, 0x09, 0x04, 0x60, 0x69, 0xE2, 0x68, 0x09, 0x0C
	blx FUN_02045CAC
	.byte 0xA0, 0x68
	.byte 0xE2, 0x68, 0x39, 0x1C
	bl FUN_0201F250
	.byte 0xF8, 0xBD, 0xC0, 0x46
	.word ADDR_021F63D8
	.word ADDR_021F6398
	.byte 0xF8, 0xB5, 0x16, 0x1C, 0x04, 0x1C, 0x30, 0x68, 0x11, 0x4F, 0x00, 0x06
	.byte 0x05, 0x0E, 0x38, 0x68, 0xC9, 0xF7, 0x26, 0xFD, 0x85, 0x42, 0x09, 0xD0, 0x38, 0x68, 0x29, 0x1C
	.byte 0xCA, 0xF7, 0xDE, 0xFC, 0x00, 0x28, 0x01, 0xD0, 0x23, 0x21, 0x02, 0xE0, 0x22, 0x21, 0x00, 0xE0
	.byte 0x21, 0x21, 0x08, 0x4D, 0x28, 0x69, 0xEA, 0x68
	blx FUN_02045CAC
	.byte 0xE8, 0x68, 0xAA, 0x68
	.byte 0x31, 0x1C, 0xFF, 0xF7, 0x05, 0xFD, 0xA8, 0x68, 0xEA, 0x68, 0x21, 0x1C
	bl FUN_0201F250
	.byte 0xF8, 0xBD, 0xC0, 0x46
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021ef5e8
FUN_overlay_d_93__021ef5e8: ; 0x021EF5E8
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	ldr r0, _021EF65C ; =0x021F63D8
	add r4, r1, #0
	ldrh r0, [r0, #0x18]
	add r6, r2, #0
	cmp r0, #0
	bne _021EF62E
	add r0, r4, #0
	bl thunk_FUN_overlay_d_93__021b8d08
	ldr r5, _021EF660 ; =0x021F6398
	add r2, r0, #0
	ldr r1, [r5, #0x54]
	ldr r0, [r5]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FUN_overlay_d_93__021b8ce8
	cmp r0, #0
	beq _021EF62E
	ldr r0, [r5]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #0
	beq _021EF626
	ldr r0, [r5]
	bl FUN_overlay_d_93__021b86b8
	cmp r0, #4
	bne _021EF62A
	thumb_func_end FUN_overlay_d_93__021ef5e8
_021EF626:
	mov r5, #1
	b _021EF630
_021EF62A:
	mov r5, #2
	b _021EF630
_021EF62E:
	mov r5, #0
_021EF630:
	add r0, r4, #0
	mov r1, #0
	bl FUN_overlay_d_93__021eed00
	ldr r4, _021EF660 ; =0x021F6398
	lsl r1, r6, #1
	add r1, r6, r1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	add r1, r1, r5
	lsl r1, r1, #0x10
	ldr r0, [r4, #0x18]
	ldr r2, [r4, #0xc]
	lsr r1, r1, #0x10
	blx FUN_02045CAC
	ldr r0, [r4, #8]
	ldr r2, [r4, #0xc]
	add r1, r7, #0
	bl FUN_0201F250
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EF65C:
	.word ADDR_021F63D8
_021EF660:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021ef664
FUN_overlay_d_93__021ef664: ; 0x021EF664
	push {r3, lr}
	add r3, r0, #0
	cmp r1, #0
	beq _021EF68E
	sub r1, r1, #1
	lsl r0, r1, #1
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	cmp r2, #0
	bne _021EF67E
	add r0, r0, #1
	b _021EF680
	thumb_func_end FUN_overlay_d_93__021ef664
_021EF67E:
	add r0, r0, #2
_021EF680:
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	ldr r0, _021EF690 ; =0x021F6398
	add r2, r3, #0
	ldr r0, [r0, #0x2c]
	blx FUN_02045CAC
_021EF68E:
	pop {r3, pc}
	.balign 4, 0
_021EF690:
	.word ADDR_021F6398

	thumb_func_start FUN_overlay_d_93__021ef694
FUN_overlay_d_93__021ef694: ; 0x021EF694
	add r2, r0, #0
	ldr r0, _021EF6A0 ; =0x021F6398
	ldr r3, _021EF6A4 ; =FUN_02045CAC
	ldr r0, [r0, #0x1c]
	bx r3
	nop
	thumb_func_end FUN_overlay_d_93__021ef694
_021EF6A0:
	.word ADDR_021F6398
_021EF6A4: .word FUN_02045CAC

	thumb_func_start FUN_overlay_d_93__021ef6a8
FUN_overlay_d_93__021ef6a8: ; 0x021EF6A8
	ldr r3, _021EF6AC ; =LAB_overlay_d_93__021ef6b0
	bx r3
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021ef6a8
_021EF6AC: .word LAB_overlay_d_93__021ef6b0

	thumb_func_start LAB_overlay_d_93__021ef6b0
LAB_overlay_d_93__021ef6b0: ; 0x021EF6B0
	push {r3, r4, r5, r6, r7, lr}
	ldr r4, _021EF6E0 ; =0x021F6398
	add r5, r0, #0
	add r6, r2, #0
	ldr r0, [r4, #0x24]
	ldr r2, [r4, #0xc]
	blx FUN_02045CAC
	ldr r7, _021EF6E4 ; =0x021F63D8
	mov r0, #1
	strh r0, [r7, #0x1a]
	ldr r0, [r4, #0xc]
	ldr r2, [r4, #8]
	add r1, r6, #0
	bl FUN_overlay_d_93__021eefe0
	mov r0, #0
	strh r0, [r7, #0x1a]
	ldr r0, [r4, #8]
	ldr r2, [r4, #0xc]
	add r1, r5, #0
	bl FUN_0201F250
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end LAB_overlay_d_93__021ef6b0
_021EF6E0:
	.word ADDR_021F6398
_021EF6E4:
	.word ADDR_021F63D8

	thumb_func_start FUN_overlay_d_93__021ef6e8
FUN_overlay_d_93__021ef6e8: ; 0x021EF6E8
	ldr r3, _021EF6EC ; =LAB_overlay_d_93__021ef6f0
	bx r3
	.balign 4, 0
	thumb_func_end FUN_overlay_d_93__021ef6e8
_021EF6EC: .word LAB_overlay_d_93__021ef6f0

	thumb_func_start LAB_overlay_d_93__021ef6f0
LAB_overlay_d_93__021ef6f0: ; 0x021EF6F0
	push {r4, r5, r6, lr}
	ldr r4, _021EF718 ; =0x021F6398
	add r5, r0, #0
	add r6, r2, #0
	ldr r0, [r4, #0x28]
	ldr r2, [r4, #0xc]
	blx FUN_02045CAC
	ldr r0, [r4, #0xc]
	ldr r2, [r4, #8]
	add r1, r6, #0
	bl FUN_overlay_d_93__021eefe0
	ldr r0, [r4, #8]
	ldr r2, [r4, #0xc]
	add r1, r5, #0
	bl FUN_0201F250
	pop {r4, r5, r6, pc}
	nop
	thumb_func_end LAB_overlay_d_93__021ef6f0
_021EF718: .word ADDR_021F6398



	.section .rodata, 4
	.global battle_adapter_rodata
battle_adapter_rodata:
_021F3990:
	.byte 0x0F, 0x00, 0x0E, 0x00, 0x0D, 0x00, 0x10, 0x00, 0xB6, 0x00, 0xCC, 0x00, 0xE9, 0x00, 0xB8, 0x00
	.byte 0x94, 0x00, 0x96, 0x00, 0x98, 0x00, 0x9A, 0x00, 0x9C, 0x00, 0x9E, 0x00, 0xA0, 0x00, 0xA2, 0x00
	.byte 0xB0, 0x00, 0x84, 0x00, 0x86, 0x00, 0x80, 0x00, 0x82, 0x00, 0x7C, 0x00, 0x7E, 0x00, 0x88, 0x00
	.byte 0x8A, 0x00, 0x8C, 0x00, 0x8E, 0x00, 0x90, 0x00, 0x92, 0x00, 0xA4, 0x00, 0xA6, 0x00, 0xA8, 0x00
	.byte 0xAA, 0x00, 0xAC, 0x00, 0xAE, 0x00, 0x00, 0x00, 0x1B, 0x00, 0x00, 0x00
	.word ADDR_021EF460 + 1
	.byte 0x5A, 0x00, 0x00, 0x00
	.word ADDR_021EF460 + 1
	.byte 0x99, 0x00, 0x00, 0x00
	.word ADDR_021EF508 + 1
	.byte 0xAE, 0x00, 0x00, 0x00
	.word ADDR_021EF508 + 1
	.byte 0xAA, 0x03, 0x00, 0x00
	.word ADDR_021EF3A4 + 1
	.byte 0x21, 0x00, 0x00, 0x00
	.word ADDR_021EF594 + 1
	.byte 0x14, 0x04, 0x00, 0x00
	.word ADDR_021EF204 + 1
	.byte 0x17, 0x04, 0x00, 0x00
	.word ADDR_021EF204 + 1
	.byte 0x4D, 0x01, 0x00, 0x00
	.word ADDR_021EF204 + 1
	.byte 0x71, 0x04, 0x00, 0x00
	.word ADDR_021EF204 + 1
	.byte 0x09, 0x00, 0x00, 0x00
	.word ADDR_021EF204 + 1
	.byte 0x0C, 0x00, 0x00, 0x00
	.word ADDR_021EF204 + 1
	.byte 0x12, 0x00, 0x00, 0x00
	.word ADDR_021EF204 + 1
	.byte 0x15, 0x00, 0x00, 0x00
	.word ADDR_021EF204 + 1

	.section .data, 4
	.global battle_adapter_data
battle_adapter_data:
_021F3AE8:
	.byte 0x62, 0x74, 0x6C, 0x5F, 0x61, 0x64, 0x61, 0x70, 0x74, 0x65, 0x72, 0x2E, 0x63, 0x00, 0x00, 0x00
