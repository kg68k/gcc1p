	.title	libgcc.a(_addxf3.o)

* long double __addxf3 (long double, long double);
*	long double同士を加算して返す。

* long double __subxf3 (long double, long double);
*	long double同士を減算して返す。

	.cpu	68000

	.offset	4
ldval1:	.ds.x	1
ldval2:	.ds.x	1

	.text

___subxf3::
	bchg	#7,(ldval2,sp)
___addxf3::
	movem.l	d3-d7,-(sp)
	movem.l	(ldval1+5*4,sp),d0-d2/d3-d5
	swap	d0
	swap	d3

	move	d0,d6
	eor	d3,d6
	swap	d6
	move	d0,d6
	move	#$7fff,d7
	and	d7,d0
	beq	xadd_za
	cmp	d7,d0
	beq	xadd_nia
xadd1:
	and	d7,d3
	beq	xadd_zb
	cmp	d7,d3
	beq	xadd_nib
xadd2:
	tst.l	d6
	bmi	xadd_s
*xadd_a:
	cmp	d3,d0
	beq	xadd_ae
	bgt	xadd_a1
	exg.l	d0,d3
	exg.l	d1,d4
	exg.l	d2,d5
xadd_a1:
	add.l	d2,d2
	addx.l	d1,d1
	move	d0,d7
	sub	d3,d7
	subq	#2,d7
	bcs	xadd_a5
	cmpi	#64-1,d7
	bcc	xadd_a6
xadd_a2:
	lsr.l	#1,d4
	roxr.l	#1,d5
	dbra	d7,xadd_a2
xadd_a5:
	move	d5,d3
	lsr	#1,d3
	addx.l	d5,d2
	addx.l	d4,d1
	bcc	xadd_a6
	addq	#1,d0
	cmpi	#$7fff,d0
	beq	xadd_infa
	moveq	#0,d3
	lsr.l	#1,d1
	roxr.l	#1,d2
	move	d2,d3
	and	#$0001,d3
	addx.l	d3,d2
	moveq	#0,d3
	addx.l	d3,d1
xadd_a6:
	move	#$0010,ccr
	roxr.l	#1,d1
	roxr.l	#1,d2
	bra	xadd_ae0

xadd_ae:
	addq	#1,d0
	cmpi	#$7fff,d0
	beq	xadd_infa
	add.l	d5,d2
	addx.l	d4,d1
	roxr.l	#1,d1
	roxr.l	#1,d2
	moveq	#0,d3
	roxl	#1,d3
	add.l	d3,d2
	moveq	#0,d3
	addx.l	d3,d1
xadd_ae0:
	tst	d0
	bpl	xadd_ae5
xadd_ae1:
	addq	#1,d0
	lsr.l	#1,d1
	roxr.l	#1,d2
	tst	d0
	bne	xadd_ae1
	moveq	#0,d3
	roxl	#1,d3
	add.l	d3,d2
	moveq	#0,d3
	addx.l	d3,d1
xadd_ae5:
	tst	d6
	bpl	xadd_ae9
	or	#$8000,d0
xadd_ae9:
	swap	d0
	movem.l	(sp)+,d3-d7
	rts

xadd_infa:
	moveq	#0,d1
	moveq	#0,d2
	bra	xadd_ae5

xadd_s:
	cmp	d3,d0
	beq	xadd_se
	bgt	xadd_s1
	exg.l	d0,d3
	exg.l	d1,d4
	exg.l	d2,d5
	not	d6
xadd_s1:
	add.l	d2,d2
	addx.l	d1,d1
	move	d0,d7
	sub	d3,d7
	subq	#2,d7
	bcs	xadd_s5
	cmpi	#64-1,d7
	bcc	xadd_s6
xadd_s2:
	lsr.l	#1,d4
	roxr.l	#1,d5
	dbra	d7,xadd_s2
xadd_s5:
	move	d5,d3
	lsr	#1,d3
	subx.l	d5,d2
	subx.l	d4,d1
	bcc	xadd_s6
	subq	#1,d0
	bra	xadd_se1
xadd_s6:
	move	#$0010,ccr
	roxr.l	#1,d1
	roxr.l	#1,d2
	bra	xadd_se1

xadd_se:
	sub.l	d5,d2
	subx.l	d4,d1
	bhi	xadd_se1
	neg.l	d2
	negx.l	d1
	beq	xadd_sez
	not	d6
xadd_se1:
	tst	d0
	bmi	xadd_ae1
	beq	xadd_ae5
	tst.l	d1
	bmi	xadd_ae5
xadd_se2:
	subq	#1,d0
	add.l	d2,d2
	addx.l	d1,d1
	bmi	xadd_ae5
	subq	#1,d3
	bne	xadd_se2
	bra	xadd_ae5

xadd_sez:
	moveq	#0,d0
	movem.l	(sp)+,d3-d7
	rts

xadd_za:
	move.l	d1,d7
	or.l	d2,d7
	bne	xadd_za1
	move.l	d3,d0
	move.l	d4,d1
	move.l	d5,d2
	move	#$7fff,d7
	and	d7,d3
	beq	xadd_z
	cmp	d7,d3
	beq	xadd_nib
	swap	d0
	movem.l	(sp)+,d3-d7
	rts
xadd_z:
	or.l	d4,d3
	beq	xadd_z9
	move	d6,d0
	swap	d6
	eor	d6,d0
xadd_z99:
	and	#$8000,d0
	swap	d0
	movem.l	(sp)+,d3-d7
	rts
xadd_z9:
	move	d6,d0
	swap	d6
	not	d6
	and	d6,d0
	bra	xadd_z99
xadd_za1:
	move	#$7fff,d7
xadd_za2:
	tst.l	d1
	bmi	xadd1
	subq	#1,d0
	add.l	d2,d2
	addx.l	d1,d1
	bra	xadd_za2

xadd_nia:
	add.l	d1,d1
	or.l	d2,d1
	bne	xadd_n
	and	d7,d3
	cmp	d7,d3
	bne	xadd_ni9
	add.l	d4,d4
	or.l	d5,d4
	bne	xadd_n
	tst.l	d6
	bmi	xadd_n
xadd_ni9:
	move	d6,d0
	swap	d0
	movem.l	(sp)+,d3-d7
	rts

xadd_zb:
	move.l	d4,d7
	or.l	d5,d7
	beq	xadd_ae0
xadd_zb1:
	tst.l	d4
	bmi	xadd2
	subq	#1,d3
	add.l	d5,d5
	addx.l	d4,d4
	bra	xadd_zb1

xadd_nib:
	add.l	d4,d4
	or.l	d5,d4
	bne	xadd_n
	move.l	(ldval2+5*4,sp),d0
	moveq	#0,d1
	moveq	#0,d2
	movem.l	(sp)+,d3-d7
	rts

xadd_n:
	move.l	#$7fff_0000,d0
	moveq	#-1,d1
	moveq	#-1,d2
	movem.l	(sp)+,d3-d7
	rts

	.end
