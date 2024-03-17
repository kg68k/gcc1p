	.title	libgcc.a(_negdf2.o)

* double __negdf2 (double);
*	doubleを符号反転してdoubleで返す.

* 1997/10/24 立花.
*	+0.0を-0.0にして返す不具合を修正.


	.cpu	68000

	.text

___negsf2::
	move.l	(4,sp),d0
	beq	@f
	bchg	#31,d0
@@:	rts

	.end
