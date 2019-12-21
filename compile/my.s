.org 0x0
	.globl _start

_start:
	lui	x3,0x0eeff		# x3 = 0eeff000
	srli x3, x3, 12		# x3 = 0000eeff 
	addi x1,x0,0xaa
	addi x2,x0,0xbb
	sb	x1,0(x3)			# [0xeeff] = 0xaa
	sb	x2,1(x3)			#					=0xbb
	lb x1,1(x3)				# x1 = x2_old = 0xbb, x2 vice versa. 
	lb x2, 0(x3)			
	bge x1, x2, s2		# (5) s3 < 0, not jump
	addi x1, x0, 0x111

s2: 
	

_loop:
	j _loop
