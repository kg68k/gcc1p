	.title	libgcc.a(_cmpsf2.o)

* int __cmpsf2 (float, float);
*	float同士を比較し、大小関係をintで返す。

	.cpu	68000

	.offset	4
fval1:	.ds.l	1
fval2:	.ds.l	1

	.text

___cmpsf2::
	move.l	(fval1,sp),d0
	bmi	minus
	move.l	(fval2,sp),d1
	bmi	plus_minus		;正 - 負(+0.0 - -0.0の可能性あり)

	sub.l	d1,d0			;正 - 正
	rts

minus:
	move.l	(fval2,sp),d1
	bpl	minus_plus		;負 - 正(-0.0 - +0.0の可能性あり)

	sub.l	d1,d0			;負 - 負
	neg.l	d0
	rts

plus_minus:
	bchg	#31,d1			;正 > 負
	or.l	d1,d0			;or +0.0 == -0.0
	rts

minus_plus:
	bchg	#31,d0			;負 < 正
	or.l	d1,d0			;or -0.0 == +0.0
	neg.l	d0
	rts

	.end
