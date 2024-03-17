	.title	libgcc.a(_divsf3.o)

* float __divsf3 (float, float);
*	float 同士を除算し、商を float で返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
fval1:	.ds.s	1
fval2:	.ds.s	1

	.text

.ifdef	USE_FLOAT
___divsf3::
	movea.l	(sp)+,a0
	FPACK	__CFDIV
	move.l	(sp),d0
	jmp	(a0)

.else
returnnan:
**	move.l	#$7fffffff,d0
	moveq	#$ff,d0
	bchg	d0,d0
	move.l	a1,d4
	move.l	a0,d3
	rts

___divsf3::
	movem.l	(fval1,sp),d0-d1
	movea.l	d3,a0
	movea.l	d4,a1
	move	#$7f80,d2
	move.l	d1,d4
	swap	d4
	and	d2,d4
	beq	returnnan
	move.l	d0,d3
	swap	d3
	and	d2,d3
	beq	returnzero
	sub	d4,d3
	add	#$3f80,d3
	blt	returnzero
	move.l	d0,d4
	eor.l	d1,d4
	move.l	#$7fffff,d2
	and.l	d2,d0
	lsl.l	#7,d0
	bset	#30,d0
	and.l	d2,d1
	lsl.l	#8,d1
	bset	#31,d1
	movea.l	d5,a2
	move.l	d0,d5
	swap	d5
	mulu	d1,d5
	swap	d1
	divu	d1,d5
	and.l	#$ffff,d5
	sub.l	d5,d0
	divu	d1,d0
	move.l	d0,d5
	clr	d5
	divu	d1,d5
	swap	d0
	move	d5,d0
	move.l	a2,d5
	moveq	#0,d1
	tst.l	d0
	bmi	rightsft8bit
	sub	#$80,d3
	bls	returnzero
	bmi	returninf
	lsr.l	#7,d0
	bra	setexponent

rightsft8bit:
	tst	d3
	beq	returnzero
	bmi	returninf
	lsr.l	#8,d0
setexponent:
	and.l	d2,d0
	swap	d0
	or	d3,d0
	swap	d0
	tst.l	d4
	bpl	returnd0
	bset	#31,d0
returnd0:
	move.l	a1,d4
	move.l	a0,d3
	rts

returninf:
	move.l	#$ff000000,d0
	add.l	d4,d4
	roxr.l	#1,d0
	move.l	a1,d4
	move.l	a0,d3
	rts

returnzero:
	moveq	#0,d0
	move.l	a1,d4
	move.l	a0,d3
	rts
.endif	/* !USE_FLOAT */

	.end
