	.title	libgcc.a(_mulsf3.o)

* float __mulsf3 (float, float);
*	float同士を乗算してfloatで返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
fval1:	.ds.s	1
fval2:	.ds.s	1

	.text

.ifdef	USE_FLOAT
___mulsf3::
	movea.l	(sp)+,a0
	FPACK	__CFMUL
	move.l	(sp),d0
	jmp	(a0)

.else
___mulsf3::
	movem.l	(fval1,sp),d0-d1
	movea.l	d3,a0
	movea.l	d4,a1
	movea.l	d5,a2
	move	#$7f80,d2
	move.l	d0,d3
	swap	d3
	and	d2,d3
	beq	returnzero
	move.l	d1,d4
	swap	d4
	and	d2,d4
	beq	returnzero
	sub	#$3f80,d3
	add	d4,d3
	bvs	returninf1
	move.l	d0,d4
	eor.l	d1,d4
	move.l	#$7fffff,d2
	and.l	d2,d0
	lsl.l	#8,d0
	bset	#31,d0
	and.l	d2,d1
	lsl.l	#8,d1
	bset	#$1f,d1
	move.l	d0,d2
	swap	d2
	mulu	d1,d2
	swap	d1
	move	d1,d5
	mulu	d0,d5
	clr	d5
	swap	d5
	clr	d2
	swap	d2
	add.l	d5,d2
	swap	d0
	mulu	d1,d0
	add.l	d2,d0
	moveq	#0,d1
	tst.l	d0
	bmi	rightsft8bit
	lsr.l	#7,d0
	tst	d3
**	ble	returnzero
**	bra	setexponent
	bgt	setexponent
returnzero:
	moveq	#0,d0
	move.l	a2,d5
	move.l	a1,d4
	move.l	a0,d3
	rts

rightsft8bit:
	add	#$80,d3
	bvs	returninf2
	ble	returnzero
	lsr.l	#8,d0
setexponent:
	and.l	#$7fffff,d0
	swap	d0
	or	d3,d0
	swap	d0
	tst.l	d4
	bpl	returnd0
	bset	#31,d0
returnd0:
	move.l	a2,d5
	move.l	a1,d4
	move.l	a0,d3
	rts

returninf1:
	eor.l	d0,d1
	move.l	#$ff000000,d0
	add.l	d1,d1
	roxr.l	#1,d0
	move.l	a2,d5
	move.l	a1,d4
	move.l	a0,d3
	rts

returninf2:
	move.l	#$ff000000,d0
	add.l	d4,d4
	roxr.l	#1,d0
	move.l	a2,d5
	move.l	a1,d4
	move.l	a0,d3
	rts
.endif	/* !USE_FLOAT */

	.end
