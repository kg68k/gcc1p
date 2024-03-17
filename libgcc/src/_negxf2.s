	.title	libgcc.a(_negxf2.o)

* long double __negxf2 (long double);
*	long doubleを符号反転して返す(ただし、+0.0の場合のみ+0.0を返す)。

	.cpu	68000

	.text

___negxf2::
	movem.l	(4,sp),d0-d2
	movea.l	d2,a0
	clr	d0
	or.l	d0,d2
	or.l	d1,d2
	beq	zeroskip	;d0=d1=d2=0
	bchg	#31,d0
	move.l	a0,d2
zeroskip:
	rts

	.end
