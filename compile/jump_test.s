.org 0x0
 	.global _start
_start:
	addi x1,x0,0x001
	addi x2,x0,0x001
	jal x6,_loop
	addi x3,x0,0x001
	addi x4,x0,0x001
_loop:
	addi x5,x0,0x001

