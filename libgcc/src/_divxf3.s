	.title	libgcc.a(_divxf3.o)

* long double __divxf3 (long double, long double);
*	double同士を除算して商を返す。

	.cpu	68000

	.offset	4
ldval1:	.ds.x	1
ldval2:	.ds.x	1

	.text

___divxf3::
	movem.l	d3-d7,-(sp)
	movem.l	(ldval1+4*5,sp),d0-d2/d3-d5
	swap	d0
	swap	d3

	move	d0,d6
	eor	d3,d6
	andi.l	#$8000,d6
	move	#$7fff,d7
	and	d7,d0
	beq	xdiv_za
	cmp	d7,d0
	beq	xdiv_nia
xdiv1:
	and	d7,d3
	beq	xdiv_zb
	cmp	d7,d3
	beq	xdiv_nib
xdiv2:
	ext.l	d0
	ext.l	d3
	sub.l	d3,d0
	addi.l	#$3fff,d0

	moveq	#0,d3
	cmp.l	d4,d1
	bne	xdiv3
	cmp.l	d5,d2
xdiv3:
	bcc	xdiv4
	moveq	#0,d7
	subq.l	#1,d0
	bra	xdiv5
xdiv4:
	moveq	#1,d7
	sub.l	d5,d2
	subx.l	d4,d1
xdiv5:
	add.l	d7,d7
	addx.l	d3,d3
	bcs	xdiv8
	add.l	d2,d2
	addx.l	d1,d1
	bcs	xdiv7
	cmp.l	d4,d1
	bcs	xdiv5
	bne	xdiv7
	cmp.l	d5,d2
	bcs	xdiv5
xdiv7:
	sub.l	d5,d2
	subx.l	d4,d1
	addq	#1,d7
	bra	xdiv5

xdiv8:
	roxr.l	#1,d3
	roxr.l	#1,d7
	add.l	d2,d2
	addx.l	d1,d1
	bcs	xdiv9
	cmp.l	d4,d1
	bcs	xdiv10
	bne	xdiv9
	cmp.l	d5,d2
	bcs	xdiv10
xdiv9:
	moveq	#0,d1
	addq.l	#1,d7
	addx.l	d1,d3
	bcc	xdiv10
	addq.l	#1,d0
	move.l	#$8000_0000,d3
xdiv10:
	move.l	d3,d1
	move.l	d7,d2
	cmpi	#$7fff,d0
	bcs	xdiv24
	cmpi	#-64,d0
	bgt	xdiv23
	tst.l	d0
	bmi	xdiv_z
	bra	xdiv_i
xdiv23:
	lsr.l	#1,d1
	roxr.l	#1,d2
	addq	#1,d0
	bne	xdiv23
	moveq	#0,d3
	roxl	#1,d3
	add.l	d3,d2
	moveq	#0,d3
	addx.l	d3,d1
xdiv24:
	or	d6,d0
	swap	d0
	clr	d0
	movem.l	(sp)+,d3-d7
	rts

xdiv_za:
	move.l	d1,d7
	or.l	d2,d7
	bne	xdiv_za5
	move	#$7fff,d7
	and	d7,d3
	beq	xdiv_za1
	cmp	d7,d3
	bne	xdiv_z
	add.l	d4,d4
	or.l	d5,d4
	bne	xdiv_n
xdiv_z:
	move.l	d6,d0
	swap	d0
	moveq	#0,d1
	moveq	#0,d2
	movem.l	(sp)+,d3-d7
	rts
xdiv_za1:
	move.l	d4,d7
	or.l	d5,d7
	bne	xdiv_z
	bra	xdiv_n
xdiv_za5:
	move	#$7fff,d7
xdiv_za6:
	tst.l	d1
	bmi	xdiv1
	subq	#1,d0
	add.l	d2,d2
	addx.l	d1,d1
	bra	xdiv_za6

xdiv_nia:
	add.l	d1,d1
	or.l	d2,d1
	bne	xdiv_n
	and	d7,d3
	cmp	d7,d3
	beq	xdiv_n
xdiv_i:
	ori	#$7fff,d6
	bra	xdiv_z

xdiv_zb:
	move.l	d4,d7
	or.l	d5,d7
	beq	xdiv_i
xdiv_zb1:
	tst.l	d4
	bmi	xdiv2
	subq	#1,d3
	add.l	d5,d5
	addx.l	d4,d4
	bra	xdiv_zb1

xdiv_nib:
	add.l	d4,d4
	or.l	d5,d4
	beq	xdiv_z
xdiv_n:
	move.l	#$7fff_0000,d0
	moveq	#-1,d1
	moveq	#-1,d2
	movem.l	(sp)+,d3-d7
	rts

	.end
