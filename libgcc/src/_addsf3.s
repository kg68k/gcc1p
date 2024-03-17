	.title	libgcc.a(_addsf3.o)

* float __addsf3 (float, float);
*	float 同士を加算して float で返す.

* float __subsf3 (float, float);
*	float 同士を減算して float で返す.

* 1997/10/23 立花.
*	(_subsf3.s を削除)
*	__subsf3 のエントリを __addsf3 の直前に移動、高速化.
*	returnzero を真ん中辺に移動. 直後への bra を削除. 第 7 ビットの
*	テストを btst #7 から tst.b に変更.

* 1998/10/28 立花.
*	USE_FLOAT 定義時は FLOAT を呼び出すようにした. また、__subsf3()
*	は _subsf3.s で定義される.
*	libgnu versin 1.46 fpack.lzh::_addsf3.s と同じ.

	.include	fefunc.mac

	.cpu	68000

	.offset	4
fval1:	.ds.l	1
fval2:	.ds.l	1

	.text

.ifdef	USE_FLOAT
___addsf3::
	movea.l	(sp)+,a0
	FPACK	__CFADD
	move.l	(sp),d0
	jmp	(a0)

.else
___subsf3::
	bchg	#7,(fval2,sp)
___addsf3::
	movem.l	(fval1,sp),d0-d1
	movea.l	d3,a0
	movea.l	d4,a1
	move	#$7f80,d2
	move.l	d0,d3
	swap	d3
	and	d2,d3
	beq	returnd1exp
	move.l	d1,d4
	swap	d4
	and	d2,d4
	beq	returnd0
	move	d4,d2
	sub	d3,d4
	beq	getmantissa
	bpl	d4isplus
	cmp	#$f180,d4
	bcs	returnd0
	neg	d4
	asr	#7,d4
	bra	getmantissa

d4isplus:
	cmp	#$e80,d4
	bhi	returnd1
	move	d2,d3
	exg	d0,d1
	asr	#7,d4
getmantissa:
	move.l	#$7fffff,d2
	tst.l	d1
	bmi	d1isminus
	and.l	d2,d1
	bset	#23,d1
	add.l	d1,d1
	lsr.l	d4,d1
	bra	getd0mantissa
d1isminus:
	and.l	d2,d1
	bset	#23,d1
	add.l	d1,d1
	lsr.l	d4,d1
	neg.l	d1
getd0mantissa:
	tst.l	d0
	bmi	d0isminus
	and.l	d2,d0
	bset	#23,d0
	add.l	d0,d0
	bra	addmantissa
d0isminus:
	and.l	d2,d0
	bset	#23,d0
	add.l	d0,d0
	neg.l	d0
addmantissa:
	add.l	d1,d0
	beq	returnzero
	move.l	d0,d4
	bpl	normalize
	neg.l	d0
normalize:
	swap	d0
	tst	d0
	bne	cmphi16
	swap	d0
	cmp	#$ff,d0
	bhi	l16cmpbit12
	cmp	#$f,d0
	bhi	lcmpbit6
	cmp	#3,d0
	bhi	ltstbit3
	cmp	#1,d0
	bhi	maxbit1
	bcs	returnd0
	moveq	#0,d0
	bset	#23,d0
	sub	#$c00,d3
	bls	returnzero
	bra	setexponent

maxbit1:
	swap	d0
	lsl.l	#6,d0
	sub	#$b80,d3
	bls	returnzero
	bra	setexponent

ltstbit3:
	btst	#3,d0
	bne	maxbit3
	swap	d0
	lsl.l	#5,d0
	sub	#$b00,d3
	bls	returnzero
	bra	setexponent
maxbit3:
	swap	d0
	lsl.l	#4,d0
	sub	#$a80,d3
	bls	returnzero
	bra	setexponent

lcmpbit6:
	cmp	#$3f,d0
	bhi	ltstbit7
	btst	#5,d0
	bne	maxbit5
	swap	d0
	lsl.l	#3,d0
	sub	#$a00,d3
	bls	returnzero
	bra	setexponent
maxbit5:
	swap	d0
	lsl.l	#2,d0
	sub	#$980,d3
	bls	returnzero
	bra	setexponent

ltstbit7:
	tst.b	d0
	bmi	maxbit7

	swap	d0
	add.l	d0,d0
	sub	#$900,d3
	bls	returnzero
	bra	setexponent
maxbit7:
	swap	d0
	sub	#$880,d3
	bls	returnzero
	bra	setexponent

l16cmpbit12:
	cmp	#$fff,d0
	bhi	lcmpbit14
	cmp	#$3ff,d0
	bhi	ltstbit11
	btst	#9,d0
	bne	maxbit9
	swap	d0
	lsr.l	#1,d0
	sub	#$800,d3
	bls	returnzero
	bra	setexponent
maxbit9:
	swap	d0
	lsr.l	#2,d0
	sub	#$780,d3
	bls	returnzero
	bra	setexponent

ltstbit11:
	btst	#$b,d0
	bne	maxbit11
	swap	d0
	lsr.l	#3,d0
	sub	#$700,d3
	bls	returnzero
	bra	setexponent
maxbit11:
	swap	d0
	lsr.l	#4,d0
	sub	#$680,d3
	bls	returnzero
	bra	setexponent

lcmpbit14:
	cmp	#$3fff,d0
	bhi	ltstbit15
	btst	#13,d0
	bne	maxbit13
	swap	d0
	lsr.l	#5,d0
	sub	#$600,d3
	bls	returnzero
	bra	setexponent
maxbit13:
	swap	d0
	lsr.l	#6,d0
	sub	#$580,d3
**	bls	returnzero
**	bra	setexponent
	bhi	setexponent
returnzero:
	moveq	#0,d0
	move.l	a1,d4
	move.l	a0,d3
	rts

ltstbit15:
	tst	d0
	bmi	maxbit15
	swap	d0
	lsr.l	#7,d0
	sub	#$500,d3
	bls	returnzero
	bra	setexponent
maxbit15:
	lsl.l	#8,d0
	sub	#$480,d3
	bls	returnzero
	bra	setexponent

cmphi16:
	cmp	#$ff,d0
	bhi	h16cmpbit12
	cmp	#$f,d0
	bhi	hcmpbit6
	cmp	#3,d0
	bhi	htstbit3
	btst	#1,d0
	bne	maxbit17
	swap	d0
	lsl.l	#7,d0
	sub	#$400,d3
	bls	returnzero
	bra	setexponent
maxbit17:
	swap	d0
	lsl.l	#6,d0
	sub	#$380,d3
	bls	returnzero
	bra	setexponent

htstbit3:
	btst	#3,d0
	bne	maxbit19
	swap	d0
	lsl.l	#5,d0
	sub	#$300,d3
	bls	returnzero
	bra	setexponent
maxbit19:
	swap	d0
	lsl.l	#4,d0
	sub	#$280,d3
	bls	returnzero
	bra	setexponent

hcmpbit6:
	cmp	#$3f,d0
	bhi	htstbit7
	btst	#5,d0
	bne	maxbit21
	swap	d0
	lsl.l	#3,d0
	sub	#$200,d3
	bls	returnzero
	bra	setexponent
maxbit21:
	swap	d0
	lsl.l	#2,d0
	sub	#$180,d3
	bls	returnzero
	bra	setexponent

htstbit7:
	tst.b	d0
	bmi	maxbit23

	swap	d0
	add.l	d0,d0
	sub	#$100,d3
	bls	returnzero
	bra	setexponent
maxbit23:
	swap	d0
	sub	#$80,d3
	bls	returnzero
	bra	setexponent

h16cmpbit12:
	btst	#9,d0
	bne	maxbit25
	swap	d0
	lsr.l	#1,d0
	bra	setexponent
maxbit25:
	swap	d0
	lsr.l	#2,d0
	add	#$80,d3
	bmi	returninf
	bra	setexponent

setexponent:
	and.l	d2,d0
	swap	d0
	or	d3,d0
	swap	d0
	tst.l	d4
	bpl	returnd0
	bset	#31,d0
	move.l	a1,d4
	move.l	a0,d3
	rts

returnd1exp:
	move.l	d1,d0
	swap	d1
	and	#$7f80,d1
	beq	returnzero
	move.l	a1,d4
	move.l	a0,d3
	rts
returnd1:
	move.l	d1,d0
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
.endif	/* !USE_FLOAT */

	.end
