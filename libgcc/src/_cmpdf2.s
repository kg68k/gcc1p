	.title	libgcc.a(_cmpdf2.o)

* int __cmpdf2 (double, double);
*	double同士を比較し、大小関係をintで返す.

* 1997/11/11 立花.
*	新規作成.


	.cpu	68000

	.offset	4
dval1h:	.ds.l	1
dval1l:	.ds.l	1
dval2h:	.ds.l	1
dval2l:	.ds.l	1

	.text

__f_cmpdf2::
** これで正しいのか自信がない(^^;
**	.cpu	68020
**	fmove.d	(dval1h,sp),fp0
**	fsub.d	(dval2h,sp),fp0
**	fbgt	return_plus
**	fblt	return_minus
**	moveq	#0,d0
**	rts
**	.cpu	68000

__fpu_cmpdf2::
__fe_cmpdf2::
___cmpdf2::
	move.l	(dval1h,sp),d0
	bmi	minus
	move.l	(dval2h,sp),d1
	bmi	plus_minus		;正 - 負(+0.0 - -0.0の可能性あり)

	sub.l	d1,d0			;正 - 正
	bhi	return_plus
	bcs	return_minus
	move.l	(dval1l,sp),d0
	sub.l	(dval2l,sp),d0
	bhi	return_plus
	bcs	return_minus
**	moveq	#0,d0
	rts

minus:
	move.l	(dval2h,sp),d1
	bpl	minus_plus		;負 - 正(-0.0 - +0.0の可能性あり)

	sub.l	d1,d0			;負 - 負
	bhi	return_minus
	bcs	return_plus
	move.l	(dval1l,sp),d0
	sub.l	(dval2l,sp),d0
	bhi	return_minus
	bcs	return_plus
**	moveq	#0,d0
	rts

plus_minus:
	add.l	d1,d1			;正 > 負
	or.l	d1,d0
	bne	return_plus
	move.l	(dval1l,sp),d0
	or.l	(dval2l,sp),d0
	beq	@f			;+0.0 == -0.0
return_plus:
	moveq	#1,d0
@@:	rts

minus_plus:
	add.l	d0,d0			;負 < 正
	or.l	d1,d0
	bne	return_minus
	move.l	(dval1l,sp),d0
	or.l	(dval2l,sp),d0
	beq	@f			;-0.0 == +0.0
return_minus:
	moveq	#-1,d0
@@:	rts

	.end
