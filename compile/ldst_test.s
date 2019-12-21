.org 0x0
 	.global _start
_start:
	addi x1,x0,0x0FF 
	sw		x1,0(x0)		# save $(x1) into 0 address in ram 
	lw		x2,0(x0)		# fetch the stored $(x1) from ram into x2
	lw		x3,0(x0)
	lw		x4,0(x0)
	lw		x5,0(x0)
	lw		x6,0(x0)
	lw		x7,0(x0)
	lw		x8,0(x0)
	lw		x9,0(x0)
	lw		x10,0(x0)
