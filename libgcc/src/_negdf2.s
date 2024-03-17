	.title	libgcc.a(_negdf2.o)

* double __negdf2 (double);
*	doubleを符号反転してdoubleで返す(ただし、+0.0の場合のみ+0.0を返す)。

	.cpu	68000

	.text

___negdf2::
	movem.l	(4,sp),d0-d1
	move.l	d0,d2
	or.l	d1,d2
	beq	zeroskip
	bchg	#31,d0
zeroskip:
	rts

	.end
