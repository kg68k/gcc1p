	.title	libgcc.a(_floatsidf.o)

* double __floatsidf (int);
*	intをdoubleに変換して返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
si:	.ds.l	1

	.text

.ifdef	USE_FLOAT
___floatsidf::
	move.l	(si,sp),d0
	beq	return_zero
	FPACK	__LTOD
	rts
return_zero:
	moveq	#0,d1
	rts

.else
___floatsidf::
	moveq	#0,d1
	move.l	(si,sp),d0
	beq	returnd0d1

	movea.l	d0,a0
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
	bcs	returnd0d1
	move.l	#$3ff00000,d0
	bra	setsignflag
maxbit1:
	moveq	#0,d1
	lsl	#3,d0
	and	#$f,d0
	or	#$4000,d0
	swap	d0
	bra	setsignflag

ltstbit3:
	btst	#3,d0
	bne	maxbit3
	moveq	#0,d1
	lsl	#2,d0
	or	#$4010,d0
	swap	d0
	bra	setsignflag
maxbit3:
	moveq	#0,d1
	add	d0,d0
	and	#$f,d0
	or	#$4020,d0
	swap	d0
	bra	setsignflag

lcmpbit6:
	cmp	#$3f,d0
	bhi	ltstbit7
	btst	#5,d0
	bne	maxbit5
	moveq	#0,d1
	or	#$4030,d0
	swap	d0
	bra	setsignflag
maxbit5:
	moveq	#0,d1
	and	#$1f,d0
	or	#$8080,d0
	swap	d0
	lsr.l	#1,d0
	bra	setsignflag

ltstbit7:
	tst.b	d0
	bmi	maxbit7

	moveq	#0,d1
	ror.l	#2,d0
	or	#$4050,d0
	swap	d0
	bra	setsignflag
maxbit7:
	moveq	#0,d1
	ror.l	#3,d0
	and	#$f,d0
	or	#$4060,d0
	swap	d0
	bra	setsignflag

l16cmpbit12:
	cmp	#$fff,d0
	bhi	lcmpbit14
	cmp	#$3ff,d0
	bhi	ltstbit11
	btst	#9,d0
	bne	maxbit9
	moveq	#0,d1
	ror.l	#4,d0
	or	#$4070,d0
	swap	d0
	bra	setsignflag
maxbit9:
	moveq	#0,d1
	ror.l	#5,d0
	and	#$f,d0
	or	#$4080,d0
	swap	d0
	bra	setsignflag

ltstbit11:
	btst	#11,d0
	bne	maxbit11
	moveq	#0,d1
	ror.l	#6,d0
	or	#$4090,d0
	swap	d0
	bra	setsignflag
maxbit11:
	moveq	#0,d1
	ror.l	#7,d0
	and	#$f,d0
	or	#$40a0,d0
	swap	d0
	bra	setsignflag

lcmpbit14:
	cmp	#$3fff,d0
	bhi	ltstbit15
	btst	#13,d0
	bne	maxbit13
	moveq	#0,d1
	ror.l	#8,d0
	or	#$40b0,d0
	swap	d0
	bra	setsignflag
maxbit13:
	moveq	#0,d1
	lsl.l	#7,d0
	swap	d0
	and	#$f,d0
	or	#$40c0,d0
	swap	d0
	bra	setsignflag

ltstbit15:
	tst	d0
	bmi	maxbit15
	moveq	#0,d1
	lsl.l	#6,d0
	swap	d0
	or	#$40d0,d0
	swap	d0
	bra	setsignflag
maxbit15:
	moveq	#0,d1
	lsl.l	#5,d0
	swap	d0
	and	#$f,d0
	or	#$40e0,d0
	swap	d0
	bra	setsignflag

cmphi16:
	cmp	#$ff,d0
	bhi	h16cmpbit12
	cmp	#$f,d0
	bhi	hcmpbit6
	cmp	#3,d0
	bhi	htstbit3
	btst	#1,d0
	bne	maxbit17
	moveq	#0,d1
	move	#$40f,d0
	swap	d0
	lsl.l	#4,d0
	bra	setsignflag
maxbit17:
	moveq	#0,d1
	rol.l	#3,d0
	and	#$f,d0
	or	#$4100,d0
	swap	d0
	bra	setsignflag

htstbit3:
	btst	#3,d0
	bne	maxbit19
	moveq	#0,d1
	rol.l	#2,d0
	or	#$4110,d0
	swap	d0
	bra	setsignflag
maxbit19:
	moveq	#0,d1
	rol.l	#1,d0
	and	#$f,d0
	or	#$4120,d0
	swap	d0
	bra	setsignflag

hcmpbit6:
	cmp	#$3f,d0
	bhi	htstbit7
	btst	#5,d0
	bne	maxbit21
	moveq	#0,d1
	or	#$4130,d0
	swap	d0
	bra	setsignflag
maxbit21:
	moveq	#0,d1
	and	#$1f,d0
	or	#$8280,d0
	swap	d0
	lsr.l	#1,d0
	roxr.l	#1,d1
	bra	setsignflag

htstbit7:
	tst.b	d0
	bmi	maxbit23

	move.l	d0,d1
	moveq	#0,d0
	ror.l	#2,d1
	move.b	d1,d0
	or	#$4150,d0
	clr.b	d1
	swap	d1
	swap	d0
	move	d1,d0
	clr	d1
	bra	setsignflag
maxbit23:
	move.l	d0,d1
	moveq	#0,d0
	ror.l	#3,d1
	move.b	d1,d0
	and	#$f,d0
	or	#$4160,d0
	clr.b	d1
	swap	d1
	swap	d0
	move	d1,d0
	clr	d1
	bra	setsignflag

h16cmpbit12:
	cmp	#$fff,d0
	bhi	hcmpbit14
	cmp	#$3ff,d0
	bhi	htstbit11
	btst	#9,d0
	bne	maxbit25
	move.l	d0,d1
	moveq	#0,d0
	ror.l	#4,d1
	move.b	d1,d0
	or	#$4170,d0
	clr.b	d1
	swap	d1
	swap	d0
	move	d1,d0
	clr	d1
	bra	setsignflag
maxbit25:
	move.l	d0,d1
	moveq	#0,d0
	ror.l	#5,d1
	move.b	d1,d0
	and	#$f,d0
	or	#$4180,d0
	clr.b	d1
	swap	d1
	swap	d0
	move	d1,d0
	clr	d1
	bra	setsignflag

htstbit11:
	btst	#11,d0
	bne	maxbit27
	move.l	d0,d1
	moveq	#0,d0
	ror.l	#6,d1
	move.b	d1,d0
	or	#$4190,d0
	clr.b	d1
	swap	d1
	swap	d0
	move	d1,d0
	clr	d1
	bra	setsignflag
maxbit27:
	move.l	d0,d1
	moveq	#0,d0
	ror.l	#7,d1
	move.b	d1,d0
	and	#$f,d0
	or	#$41a0,d0
	clr.b	d1
	swap	d1
	swap	d0
	move	d1,d0
	clr	d1
	bra	setsignflag

hcmpbit14:
	cmp	#$3fff,d0
	bhi	htstbit15
	btst	#13,d0
	bne	maxbit29
	move.l	d0,d1
	moveq	#0,d0
	ror.l	#8,d1
	move.b	d1,d0
	or	#$41b0,d0
	clr.b	d1
	swap	d1
	swap	d0
	move	d1,d0
	clr	d1
	bra	setsignflag
maxbit29:
	swap	d0
	rol.l	#7,d0
	move.l	d0,d1
	and	#$ff80,d1
	and	#$f,d0
	or	#$41c0,d0
	swap	d0
	swap	d1
	clr	d1
	bra	setsignflag

htstbit15:
	tst	d0
	bmi	maxbit31
	swap	d0
	rol.l	#6,d0
	move.l	d0,d1
	and	#$ffc0,d1
	and	#$f,d0
	or	#$41d0,d0
	swap	d0
	swap	d1
	clr	d1
	bra	setsignflag
maxbit31:
	swap	d0
	rol.l	#5,d0
	move.l	d0,d1
	and	#$ffe0,d1
	and	#$f,d0
	or	#$41e0,d0
	swap	d0
	swap	d1
	clr	d1
setsignflag:
	move.l	a0,d2
	bpl	returnd0d1
	bset	#31,d0
returnd0d1:
	rts
.endif	/* !USE_FLOAT */

	.end
