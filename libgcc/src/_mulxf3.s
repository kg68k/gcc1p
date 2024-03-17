	.title	libgcc.a(_mulxf3.o)

* long double __mulxf3 (long double, long double);
*	long double同士を乗算して積を返す.

* 1997/11/11 立花.
*	has version 3.09 fexpr.s(xmul)のコードを使用し、
*	若干修正して作成.


	.cpu	68000

	.offset	4
ldval1:	.ds.x	1
ldval2:	.ds.x	1

	.text

___mulxf3::
	movem.l	d3-d7,-(sp)
	movem.l	(ldval1+4*5,sp),d0-d2/d3-d5
	swap	d0
	swap	d3

	move	d0,d6
	eor	d3,d6
	andi.l	#$8000,d6
	move	#$7fff,d7
	and	d7,d0
	beq	xmul_za
	cmp	d7,d0
	beq	xmul_nia
xmul1:
	and	d7,d3
	beq	xmul_zb
	cmp	d7,d3
	beq	xmul_nib
xmul2:
	movem	d0/d3/d6,-(sp)

	move	d1,d7
	mulu	d5,d7
	clr	d7
	swap	d7
	move	d2,d6
	mulu	d4,d6
	clr	d6
	swap	d6
	add.l	d6,d7
	swap	d2
	move.l	d5,d6
	swap	d6
	mulu	d2,d6
	clr	d6
	swap	d6
	add.l	d6,d7

	move.l	d1,d6
	swap	d6
	mulu	d5,d6
	add.l	d6,d7
	move.l	d7,d6
	clr	d6
	addx	d6,d6
	swap	d6

	swap	d5
	move	d1,d3
	mulu	d5,d3
	add	d3,d7
	clr	d3
	swap	d3
	addx.l	d3,d6

	move	d4,d3
	mulu	d2,d3
	add	d3,d7
	clr	d3
	swap	d3
	addx.l	d3,d6

	move.l	d1,d3
	swap	d3
	mulu	d3,d5
	mulu	d4,d3
	move	d1,d0
	mulu	d4,d0
	add.l	d5,d0
	moveq	#0,d5
	addx	d5,d5
	add.l	d0,d6
	move.l	d3,d0
	swap	d3
	clr	d0
	swap	d0
	addx.l	d0,d5

	swap	d4
	move	d2,d0
	swap	d2
	mulu	d4,d2
	add	d2,d7
	swap	d2
	move	d2,d3
	addx.l	d3,d6
	move.l	d1,d3
	swap	d3
	mulu	d4,d3
	addx.l	d3,d5

	mulu	d4,d0
	add.l	d0,d6
	moveq	#0,d3
	addx.l	d3,d5

	mulu	d4,d1
	swap	d1
	move	d1,d3
	clr	d1
	add.l	d1,d6
	addx.l	d3,d5

	move.l	d5,d1
	move.l	d6,d2
	movem	(sp)+,d0/d3/d6
	ext.l	d0
	ext.l	d3
	add.l	d3,d0
	subi.l	#$3fff-1,d0
	tst.l	d1
	bmi	xmul5
	subq.l	#1,d0
	add	d7,d7
	roxl.l	#1,d2
	roxl.l	#1,d1
xmul5:
	tst	d7
	bpl	xmul6
	moveq	#0,d3
	addq.l	#1,d2
	addx.l	d3,d1
	bcc	xmul6
	addq.l	#1,d0
	move.l	#$8000_0000,d1
xmul6:
	cmpi	#$7fff,d0
	bcs	xmul8
	beq	xmul_i
	cmpi	#-64,d0
	bgt	xmul7
	tst.l	d0
	bmi	xmul_z
	bra	xmul_i
xmul7:
	lsr.l	#1,d1
	roxr.l	#1,d2
	addq	#1,d0
	bne	xmul7
	moveq	#0,d3
	roxl	#1,d3
	add.l	d3,d2
	moveq	#0,d3
	addx.l	d3,d1
xmul8:
	or	d6,d0
	swap	d0
	clr	d0
	movem.l	(sp)+,d3-d7
	rts

xmul_za:
	move.l	d1,d7
	or.l	d2,d7
	bne	xmul_za1
	move	#$7fff,d7
	and	d7,d3
	cmp	d7,d3
	beq	xmul_n
xmul_z:
	move.l	d6,d0
	swap	d0
	moveq	#0,d1
	moveq	#0,d2
	movem.l	(sp)+,d3-d7
	rts
xmul_za1:
	move	#$7fff,d7
xmul_za2:
	tst.l	d1
	bmi	xmul1
	subq	#1,d0
	add.l	d2,d2
	addx.l	d1,d1
	bra	xmul_za2

xmul_nia:
	add.l	d1,d1
	or.l	d2,d1
	bne	xmul_n
	and	d7,d3
	beq	xmul_nia1
	cmp	d7,d3
	bne	xmul_i
	add.l	d4,d4
	or.l	d5,d4
	bne	xmul_n
xmul_i:
	ori	#$7fff,d6
	bra	xmul_z
xmul_nia1:
	move.l	d4,d7
	or.l	d5,d7
	beq	xmul_n
	bra	xmul_i

xmul_zb:
	move.l	d4,d7
	or.l	d5,d7
	beq	xmul_z
xmul_zb1:
	tst.l	d4
	bmi	xmul2
	subq	#1,d3
	add.l	d5,d5
	addx.l	d4,d4
	bra	xmul_zb1

xmul_nib:
	add.l	d4,d4
	or.l	d5,d4
	beq	xmul_i
xmul_n:
	move.l	#$7fff_0000,d0
	moveq	#-1,d1
	moveq	#-1,d2
	movem.l	(sp)+,d3-d7
	rts

	.end
