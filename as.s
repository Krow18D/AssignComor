	.text 
	.global main
	.global printf
	.global scanf
printneg:
	push {lr}
	ldr r0,=neg
	bl printf
	pop {pc}	
printint:
	push {lr}
	ldr r0,=intfo
	bl printf
	pop {pc}
printfrac:
	push {lr}
	ldr r0,=floatfo
	bl printf
	pop {pc}
main:
	mov r10,#0
	ldr r1,=return
	str lr,[r1]
load:
	ldr r1,=testval
	ldr r1,[r1,r10]
	cmp r1, #0
	beq exit
@------------printnegative--------
	mov r2,r1,lsr #31
	cmp r2,#1
	push {r1}
	bleq printneg
	pop {r1}
@----------------int--------------
	mov r2,r1,lsl #1
	mov r2,r2,lsr #24
	sub r2,r2,#126 @exponent
	mov r3,r1,lsl #8
	orr r3,r3,#0x80000000
	rsb r4,r2,#32
	
@	mov r6,r3,lsl r2 @fraction 
	mov r5,r3,lsr r4 @integer
	push {r1,r2,r3,r6}
	mov r1,r5
	bl printint
	pop {r1,r2,r3,r6}
@---------------------------------
 	cmp r2,#0
	blt nega
	mov r6,r3,lsl r2
	b frac
nega:
	mov r11,#-1
	mov r7,r2
	mul r2,r7,r11
	mov r6,r3,lsr r2

@------------fraction-------------
frac:
	mov r9,#10
	umull r6,r1,r9,r6
	bl printfrac
	cmp r6,#0
	bne frac
@---------------end---------------
	add r10,r10,#4
	push {r1}
	ldr r0,=mes1
	bl printf
	pop {r1}
	b load
exit:
	ldr lr,=return
	ldr lr,[lr]
	bx lr

	.data 
return:	.word 0
mes1:	.asciz "\n"
intfo:	.asciz "%d."
floatfo:	.asciz "%d"
neg:	.asciz "-"
testval: 	
	.float 0.5
	.float 0.25
	.float -1.0
	.float 100.0
	.float 1234.567
	.float -9876.543
	.float 7070.7070
	.float 3.3333
	.float 694.3e-9
	.float 6.0221e2
	.float 6.0221e23
	.word 0 @ end of list
