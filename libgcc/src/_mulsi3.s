	.title	libgcc.a(_mulsi3.o)

* int __mulsi3 (int, int);
*	int 同士を乗算して、積を int で返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
si1:	.ds.l	1
si2:	.ds.l	1

	.text

.ifdef	FORCE_USE_FLOAT
___mulsi3::
	movea.l	(sp)+,a0
	FPACK	__CLMUL
	move.l	(sp),d0
	jmp	(a0)

.else
___mulsi3::
	move.l	(si1,sp),d0
	move.l	d0,d1
	swap	d1
	or	(8,sp),d1
	bne	mullong

	mulu	(10,sp),d0
	rts
mullong:
	move.l	(8,sp),d1
	move.l	d3,a0
	move.l	d0,d2
	mulu	d1,d0
	swap	d0
	move.l	d2,d3
	swap	d3
	tst	d3
	beq	@f
	mulu	d1,d3
	add	d3,d0
@@:
	swap	d1
	tst	d1
	beq	@f
	mulu	d2,d1
	add	d1,d0
@@:
	swap	d0
	move.l	a0,d3
	rts
.endif	/* !FORCE_USE_FLOAT */

	.end
