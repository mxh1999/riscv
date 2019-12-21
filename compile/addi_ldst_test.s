.org 0x0
 	.global _start
_start:
	addi x1,x0,0x00F	# lets $(x1) <- 0x101. Stall four cycles. 
	addi x1,x1,0x200	# $(x1) = 0x20F
	sw	 x1,1(x0)  		# save $(x1) into 16 address in ram 
	lw	 x2,1(x0)
	addi x3,x2,0x0F0	# $(x3) = 0x2FF
