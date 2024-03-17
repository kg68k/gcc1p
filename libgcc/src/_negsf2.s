	.title	libgcc.a(_negdf2.o)

* double __negdf2 (double);
*	doubleを符号反転してdoubleで返す。

	.cpu	68000

	.text

___negsf2::
	move.l	(4,sp),d0
	beq	@f
	bchg	#31,d0
@@:	rts

	.end
