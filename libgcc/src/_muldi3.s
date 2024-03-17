	.title	libgcc.a(_muldi3.o)

* long long int __muldi3 (long long int, long long int);
*	long long int同士を乗算し、商をlong long intで返す.

* 1997/10/24 立花.
*	libgnu-1.50p2 muldi3.sのコードに入れ換えた.
*	若干の高速化.

	.cpu	68000

multl:	.macro	dr1,dr2,dw1,dw2,dw3,aw1
	move.l	dr2,dw1
	mulu	dr1,dr2
	move.l	dw1,dw2
	swap	dw1
	mulu	dr1,dw1
	swap	dw1
	moveq	#0,dw3
	move	dw1,dw3
	clr	dw1
	add.l	dw1,dr2
	moveq	#0,dw1
	addx.l	dw1,dw3
	swap	dr1
	mulu	dw2,dr1
	swap	dr1
	moveq	#0,dw1
	move	dr1,dw1
	clr	dr1
	add.l	dr1,dr2
	addx.l	dw1,dw3
	swap	dw2
	move.l	aw1,dr1
	swap	dr1
	mulu	dw2,dr1
	add.l	dw3,dr1
	.endm

multw:	.macro	dr1,dr2,dw1,dw2
	move.l	dr1,dw1
	mulu	dr2,dr1
	move.l	dw1,dw2
	swap	dw2
	mulu	dr2,dw2
	swap	dr1
	add	dw2,dr1
	swap	dr2
	mulu	dw1,dr2
	add	dr2,dr1
	swap	dr1
	.endm

	.text

___muldi3::
	movem.l	(4,sp),d0/d1/a0/a1
	move.l	a1,d2
	or.l	d1,d2
	beq	___umuldi3_chk
	bpl	mult_double
	move.l	a1,d2
	eor.l	d1,d2
	bmi	___muldi3_conv

	neg.l	d0
	negx.l	d1
	exg.l	d0,a0
	exg.l	d1,a1
	neg.l	d0
	negx.l	d1
	bra	___umuldi3_0

___muldi3_conv:
	tst.l	d1
	bmi	___muldi3_neg
*___muldi3_exg:
	exg.l	a0,d0
	exg.l	a1,d1
___muldi3_neg:
	neg.l	d0
	negx.l	d1
	bsr	___umuldi3_0
	neg.l	d0
	negx.l	d1
	rts

___umuldi3::
	movem.l	(4,sp),d0/d1/a0/a1

___umuldi3_0:
	move.l	a1,d2
	or.l	d1,d2
	bne	mult_double

___umuldi3_chk:
	move.l	a0,d2
	or.l	d0,d2
	swap	d2
	tst	d2
	bne	mult_long
*mult_word:
	move.l	a0,d1
	mulu	d1,d0
	moveq	#0,d1
	rts

mult_long:
	move.l	d3,a1
	move.l	d4,a2

	move.l	a0,d1
	multl	d1,d0,d2,d3,d4,a0

	move.l	a2,d4
	move.l	a1,d3
	rts

mult_double:
	movem.l	d3/d4/d5,-(sp)

	move.l	d1,a2
	move.l	d0,d3
	move.l	a0,d1
	multl	d1,d0,d4,d5,d2,a0

	move.l	a1,d4
	beq	@f
	multw	d3,d4,d5,d2
	add.l	d3,d1
@@:
	move.l	a2,d2
	beq	@f
	move.l	a0,d3
	multw	d2,d3,d4,d5
	add.l	d2,d1
@@:
	movem.l	(sp)+,d3/d4/d5
	rts

	.end
