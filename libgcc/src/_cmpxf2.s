	.title	libgcc.a(_cmpxf2.o)

* int __cmpxf2 (long double, long double);
*	long double同士を比較し、大小関係をintで返す.

* 1997/11/11 立花.
*	新規作成.


	.cpu	68000

	.offset	4
ld1h:	.ds	1
	.ds	1
ld1m:	.ds.l	1
ld1l:	.ds.l	1
ld2h:	.ds	1
	.ds	1
ld2m:	.ds.l	1
ld2l:	.ds.l	1

	.text

___cmpxf2::
	move	(ld1h,sp),d0
	bmi	minus
	move	(ld2h,sp),d1
	bmi	plus_minus		;正 - 負(+0.0 - -0.0の可能性あり)
cmpxf2_sub:
	sub	d1,d0			;正 - 正
	bhi	return_plus
	bcs	return_minus
	move.l	(ld1m,sp),d0		;仮数上位
	sub.l	(ld2m,sp),d0
	bhi	return_plus
	bcs	return_minus
	move.l	(ld1l,sp),d0		;仮数下位
	sub.l	(ld2l,sp),d0
	bhi	return_plus
	bcs	return_minus
**	moveq	#0,d0
	rts
return_minus:
	moveq	#-1,d0
	rts

minus:
	move	(ld2h,sp),d1
	bpl	minus_plus		;負 - 正(-0.0 - +0.0の可能性あり)

	bsr	cmpxf2_sub		;負 - 負
	neg.l	d0
	rts

plus_minus:
	add	d1,d1			;正 > 負
cmpxf2_sub0:
	or	d1,d0
	bne	return_plus
	move.l	(ld1m,sp),d0
	or.l	(ld2m,sp),d0
	bne	return_plus
	move.l	(ld1l,sp),d0
	or.l	(ld2l,sp),d0
	beq	@f			;+0.0 == -0.0
return_plus:
	moveq	#1,d0
@@:	rts

minus_plus:
	add	d0,d0			;負 < 正
	bsr	cmpxf2_sub0
	neg.l	d0
	rts

	.end
