.org 0x0
 	.global _start
_start:
	addi x1,x0,0x001 # lets $(x1) <- 0x101. Stall four cycles. 
	addi x1,x1,0x001
	addi x1,x1,0x001
	addi x1,x1,0x001
	addi x1,x1,0x001
	addi x1,x1,0x001
	addi x1,x1,0x001
	addi x1,x1,0x001
	addi x1,x1,0x001
