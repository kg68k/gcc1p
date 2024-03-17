	.title	libgcc.a(_floatdidf.o)

* double __floatdidf (long long int);
*	long long intをdoubleに変換して返す。

	.cpu	68000

	.text

___floatdidf::
	move.l	(4,sp),d1
	move.l	(8,sp),d0
___floatdidf_::			;_floatdisf.s からの直接呼び出し用
	move.l	d0,a0		;呼び出し直前に <tst.l d0> を実行しておくこと
	bpl	normalize
	neg.l	d1
	negx.l	d0
normalize:
	tst.l	d0
	bne	cmphi32

	swap	d1
	tst	d1
	bne	cmplow32hi16
*cmplow32low16:
	swap	d1
	cmp	#$00ff,d1
	bhi	ll16cmpbit12

	cmp	#$000f,d1
	bhi	llcmpbit6
	cmp	#$0003,d1
	bhi	lltstbit3
	cmp	#$0001,d1
	bhi	maxbit1
*maxbit0:
	bcs	returnd0d1
	moveq	#0,d1
	move.l	#$3ff00000,d0
	bra	setsignflag
maxbit1:
	exg.l	d1,d0
	lsl	#3,d0
	and	#$000f,d0
	or	#$4000,d0
	bra	setsignflag1

lltstbit3:
	btst	#3,d1
	bne	maxbit3
*maxbit2:
	exg.l	d1,d0
	lsl	#2,d0
	or	#$4010,d0
	bra	setsignflag1
maxbit3:
	exg.l	d1,d0
	add	d0,d0
	and	#$000f,d0
	or	#$4020,d0
	bra	setsignflag1

llcmpbit6:
	cmp	#$003f,d1
	bhi	lltstbit7
	btst	#5,d1
	bne	maxbit5
*maxbit4:
	exg.l	d1,d0
	or	#$4030,d0
	bra	setsignflag1
maxbit5:
	exg.l	d1,d0
	and	#$001f,d0
	or	#$8080,d0
	swap	d0
	lsr.l	#1,d0
	bra	setsignflag

lltstbit7:
	tst.b	d1
	bmi	maxbit7
*maxbit6:
	exg.l	d1,d0
	ror.l	#2,d0
	or	#$4050,d0
	bra	setsignflag1
maxbit7:
	exg.l	d1,d0
	ror.l	#3,d0
	and	#$000f,d0
	or	#$4060,d0
	bra	setsignflag1

ll16cmpbit12:
	cmp	#$0fff,d1
	bhi	llcmpbit14
	cmp	#$03ff,d1
	bhi	lltstbit11
	btst	#9,d1
	bne	maxbit9
*maxbit8:
	exg.l	d1,d0
	ror.l	#4,d0
	or	#$4070,d0
	bra	setsignflag1
maxbit9:
	exg.l	d1,d0
	ror.l	#5,d0
	and	#$000f,d0
	or	#$4080,d0
	bra	setsignflag1

lltstbit11:
	btst	#11,d1
	bne	maxbit11
*maxbit10:
	exg.l	d1,d0
	ror.l	#6,d0
	or	#$4090,d0
	bra	setsignflag1
maxbit11:
	exg.l	d1,d0
	ror.l	#7,d0
	and	#$000f,d0
	or	#$40a0,d0
	bra	setsignflag1

llcmpbit14:
	cmp	#$3fff,d1
	bhi	lltstbit15
	btst	#13,d1
	bne	maxbit13
*maxbit12:
	exg.l	d1,d0
	ror.l	#8,d0
	or	#$40b0,d0
	bra	setsignflag1
maxbit13:
	exg.l	d1,d0
	lsl.l	#7,d0
	swap	d0
	and	#$000f,d0
	or	#$40c0,d0
	bra	setsignflag1

lltstbit15:
	tst	d1
	bmi	maxbit15
*maxbit14:
	exg.l	d1,d0
	lsl.l	#6,d0
	swap	d0
	or	#$40d0,d0
	bra	setsignflag1
maxbit15:
	exg.l	d1,d0
	lsl.l	#5,d0
	swap	d0
	and	#$000f,d0
	or	#$40e0,d0
	bra	setsignflag1

cmplow32hi16
	cmp	#$00ff,d1
	bhi	lh16cmpbit12
	cmp	#$000f,d1
	bhi	lhcmpbit6
	cmp	#$0003,d1
	bhi	lhtstbit3
	btst	#1,d1
	bne	maxbit17
*maxbit16:
	exg.l	d1,d0
	move	#$040f,d0
	swap	d0
	lsl.l	#4,d0
	bra	setsignflag
maxbit17:
	exg.l	d1,d0
	rol.l	#3,d0
	and	#$000f,d0
	or	#$4100,d0
	bra	setsignflag1

lhtstbit3:
	btst	#3,d1
	bne	maxbit19
*maxbit18:
	exg.l	d1,d0
	rol.l	#2,d0
	or	#$4110,d0
	bra	setsignflag1
maxbit19:
	exg.l	d1,d0
	rol.l	#1,d0
	and	#$000f,d0
	or	#$4120,d0
	bra	setsignflag1

lhcmpbit6:
	cmp	#$003f,d1
	bhi	lhtstbit7
	btst	#5,d1
	bne	maxbit21
*maxbit20:
	exg.l	d1,d0
	or	#$4130,d0
	bra	setsignflag1
maxbit21:
	exg.l	d1,d0
	and	#$001f,d0
	or	#$8280,d0
	swap	d0
	lsr.l	#1,d0
	roxr.l	#1,d1
	bra	setsignflag

lhtstbit7:
	tst.b	d1
	bmi	maxbit23
*maxbit22:
	ror.l	#2,d1
	move.b	d1,d0
	or	#$4150,d0
	bra	setsignflag2
maxbit23:
	ror.l	#3,d1
	move.b	d1,d0
	and	#$000f,d0
	or	#$4160,d0
	bra	setsignflag2

lh16cmpbit12:
	cmp	#$0fff,d1
	bhi	lhcmpbit14
	cmp	#$03ff,d1
	bhi	lhtstbit11
	btst	#9,d1
	bne	maxbit25
*maxbit24:
	ror.l	#4,d1
	move.b	d1,d0
	or	#$4170,d0
	bra	setsignflag2
maxbit25:
	ror.l	#5,d1
	move.b	d1,d0
	and	#$000f,d0
	or	#$4180,d0
	bra	setsignflag2

setsignflag2:
	clr.b	d1
	swap	d1
	swap	d0
	move	d1,d0
	clr	d1
*setsignflag:
	move.l	a0,d2
	bmi	setsignflag9
returnd0d1:
	rts

setsignflag3:
	swap	d1
	clr	d1
setsignflag1:
	swap	d0
setsignflag:
	move.l	a0,d2
	bpl	@f
setsignflag9:
	bset	#31,d0
@@:	rts

lhtstbit11:
	btst	#11,d1
	bne	maxbit27
*maxbit26:
	ror.l	#6,d1
	move.b	d1,d0
	or	#$4190,d0
	bra	setsignflag2
maxbit27:
	ror.l	#7,d1
	move.b	d1,d0
	and	#$000f,d0
	or	#$41a0,d0
	bra	setsignflag2

lhcmpbit14:
	cmp	#$3fff,d1
	bhi	lhtstbit15
	btst	#13,d1
	bne	maxbit29
*maxbit28:
	ror.l	#8,d1
	move.b	d1,d0
	or	#$41b0,d0
	bra	setsignflag2
maxbit29:
	swap	d1
	rol.l	#7,d1
	move.l	d1,d0
	and	#$ff80,d1
	and	#$000f,d0
	or	#$41c0,d0
	bra	setsignflag3

lhtstbit15:
	tst	d1
	bmi	maxbit31
*maxbit30:
	swap	d1
	rol.l	#6,d1
	move.l	d1,d0
	and	#$ffc0,d1
	and	#$000f,d0
	or	#$41d0,d0
	bra	setsignflag3
maxbit31:
	swap	d1
	rol.l	#5,d1
	move.l	d1,d0
	and	#$ffe0,d1
	and	#$000f,d0
	or	#$41e0,d0
	bra	setsignflag3

cmphi32:
	swap	d0
	tst	d0
	bne	cmphi32hi16

*cmphi32low16:
	swap	d0
	cmp	#$00ff,d0
	bhi	hl16cmpbit12
	cmp	#$000f,d0
	bhi	hlcmpbit6
	cmp	#$0003,d0
	bhi	hltstbit3

	btst	#1,d0
	bne	maxbit33
*maxbit32:
	rol.l	#4,d1
	move.l	d1,d0
	move	#$41f0,d0
	or.b	d1,d0
	and	#$fff0,d1
	bra	setsignflag3
maxbit33:
	move.l	d1,d2
	move	d0,d2
	rol.l	#3,d2
	lsl.l	#3,d1
	move.l	d1,d0
	move	d2,d0
	and	#$000f,d0
	or	#$4200,d0
	bra	setsignflag3

hltstbit3:
	btst	#3,d0
	bne	maxbit35
*maxbit34:
	add.l	d1,d1
	addx.l	d0,d0
	add.l	d1,d1
	addx.l	d0,d0
	or	#$4210,d0
	swap	d0
	swap	d1
	move	d1,d0
	clr	d1
	bra	setsignflag
maxbit35:
	add.l	d1,d1
	addx.l	d0,d0
	and	#$000f,d0
	or	#$4220,d0
	swap	d0
	swap	d1
	move	d1,d0
	clr	d1
	bra	setsignflag

hlcmpbit6:
	cmp	#$003f,d0
	bhi	hltstbit7

	btst	#5,d0
	bne	maxbit37
*maxbit36:
	or	#$4230,d0
	swap	d0
	swap	d1
	move	d1,d0
	clr	d1
	bra	setsignflag
maxbit37:
	and	#$001f,d0
	or	#$8480,d0
	swap	d0
	swap	d1
	move	d1,d0
	clr	d1
	lsr.l	#1,d0
	roxr.l	#1,d1
	bra	setsignflag

hltstbit7:
	tst.b	d0
	bmi	maxbit39
*maxbit38:
	swap	d0
	swap	d1
	move	d1,d0
	swap	d1
	lsr.l	#2,d0
	ror.l	#2,d1
	swap	d1
	and	#$c000,d1
	swap	d0
	or	#$4250,d0
	bra	setsignflag1
maxbit39:
	swap	d0
	swap	d1
	move	d1,d0
	swap	d1
	lsr.l	#3,d0
	ror.l	#3,d1
	swap	d1
	and	#$e000,d1
	swap	d0
	and	#$000f,d0
	or	#$4260,d0
	bra	setsignflag1

hl16cmpbit12:
	cmp	#$0fff,d0
	bhi	hlcmpbit14
	cmp	#$03ff,d0
	bhi	hltstbit11

	btst	#9,d0
	bne	maxbit41
*maxbit40:
	swap	d0
	swap	d1
	move	d1,d0
	swap	d1
	lsr.l	#4,d0
	ror.l	#4,d1
	swap	d1
	and	#$f000,d1
	swap	d0
	or	#$4270,d0
	bra	setsignflag1
maxbit41:
	swap	d0
	swap	d1
	move	d1,d0
	swap	d1
	lsr.l	#5,d0
	ror.l	#5,d1
	swap	d1
	and	#$f800,d1
	swap	d0
	and	#$000f,d0
	or	#$4280,d0
	bra	setsignflag1

hltstbit11:
	btst	#11,d0
	bne	maxbit43
*maxbit42:
	swap	d0
	swap	d1
	move	d1,d0
	swap	d1
	lsr.l	#6,d0
	ror.l	#6,d1
	swap	d1
	and	#$fc00,d1
	swap	d0
	or	#$4290,d0
	bra	setsignflag1
maxbit43:
	swap	d0
	swap	d1
	move	d1,d0
	swap	d1
	lsr.l	#7,d0
	ror.l	#7,d1
	swap	d1
	and	#$fe00,d1
	swap	d0
	and	#$000f,d0
	or	#$42a0,d0
	bra	setsignflag1

hlcmpbit14:
	cmp	#$3fff,d0
	bhi	hltstbit15

	btst	#13,d0
	bne	maxbit45
*maxbit44:
	lsl.l	#8,d0
	rol.l	#8,d1
	move.b	d1,d0
	clr.b	d1
	swap	d0
	or	#$42b0,d0
	bra	setsignflag1
maxbit45:
	lsl.l	#7,d0
	rol.l	#7,d1
	move	d1,d2
	and	#$ff80,d1
	and	#$007f,d2
	or	d2,d0
	swap	d0
	and	#$000f,d0
	or	#$42c0,d0
	bra	setsignflag1

hltstbit15:
	tst	d0
	bmi	maxbit47
*maxbit46:
	lsl.l	#6,d0
	rol.l	#6,d1
	move	d1,d2
	and	#$ffc0,d1
	and	#$003f,d2
	or	d2,d0
	swap	d0
	or	#$42d0,d0
	bra	setsignflag1
maxbit47:
	lsl.l	#5,d0
	rol.l	#5,d1
	move	d1,d2
	and	#$ffe0,d1
	and	#$001f,d2
	or	d2,d0
	swap	d0
	and	#$000f,d0
	or	#$42e0,d0
	bra	setsignflag1

cmphi32hi16:
	cmp	#$00ff,d0
	bhi	hh16cmpbit12
	cmp	#$000f,d0
	bhi	hhcmpbit6
	cmp	#$0003,d0
	bhi	hhtstbit3

	btst	#1,d0
	bne	maxbit49
*maxbit48:
	move	#$042f,d0
	swap	d0
	lsl.l	#4,d0
	rol.l	#4,d1
	move	d1,d2
	and	#$fff0,d1
	and	#$000f,d2
	or	d2,d0
	bra	setsignflag
maxbit49:
	and	#$0001,d0
	or	#$0860,d0
	swap	d0
	add.l	d1,d1
	addx.l	d0,d0
	add.l	d1,d1
	addx.l	d0,d0
	add.l	d1,d1
	addx.l	d0,d0
	bra	setsignflag

hhtstbit3:
	btst	#3,d0
	bne	maxbit51
*maxbit50:
	and	#$0003,d0
	or	#$10c4,d0
	swap	d0
	add.l	d1,d1
	addx.l	d0,d0
	add.l	d1,d1
	addx.l	d0,d0
	bra	setsignflag
maxbit51:
	and	#$0007,d0
	or	#$2190,d0
	swap	d0
	add.l	d1,d1
	addx.l	d0,d0
	bra	setsignflag

hhcmpbit6:
	cmp	#$003f,d0
	bhi	hhtstbit7

	btst	#5,d0
	bne	maxbit53
*maxbit52:
	and	#$000f,d0
	or	#$4330,d0
	bra	setsignflag1
maxbit53:
	and	#$001f,d0
	or	#$8680,d0
	swap	d0
	lsr.l	#1,d0
	roxr.l	#1,d1
	bra	setsignflag

hhtstbit7:
	tst.b	d0
	bmi	maxbit55
*maxbit54:
	swap	d0
	lsr.l	#1,d0
	roxr.l	#1,d1
	lsr.l	#1,d0
	roxr.l	#1,d1
	swap	d0
	or	#$4350,d0
	bra	setsignflag1
maxbit55:
	swap	d0
	move	d0,d2
	lsr.l	#3,d0
	and	#$0007,d2
	and	#$fff8,d1
	or	d2,d1
	ror.l	#3,d1
	swap	d0
	and	#$000f,d0
	or	#$4360,d0
	bra	setsignflag1

hh16cmpbit12:
	cmp	#$0fff,d0
	bhi	hhcmpbit14
	cmp	#$03ff,d0
	bhi	hhtstbit11

	btst	#9,d0
	bne	maxbit57
*maxbit56:
	swap	d0
	move	d0,d2
	lsr.l	#4,d0
	and	#$000f,d2
	and	#$fff0,d1
	or	d2,d1
	ror.l	#4,d1
	swap	d0
	or	#$4370,d0
	bra	setsignflag1
maxbit57:
	swap	d0
	move	d0,d2
	lsr.l	#5,d0
	and	#$001f,d2
	and	#$ffe0,d1
	or	d2,d1
	ror.l	#5,d1
	swap	d0
	and	#$000f,d0
	or	#$4380,d0
	bra	setsignflag1

hhtstbit11:
	btst	#11,d0
	bne	maxbit59
*maxbit58:
	swap	d0
	move	d0,d2
	lsr.l	#6,d0
	and	#$003f,d2
	and	#$ffc0,d1
	or	d2,d1
	ror.l	#6,d1
	swap	d0
	or	#$4390,d0
	bra	setsignflag1
maxbit59:
	swap	d0
	move	d0,d2
	lsr.l	#7,d0
	and	#$007f,d2
	and	#$ff80,d1
	or	d2,d1
	ror.l	#7,d1
	swap	d0
	and	#$000f,d0
	or	#$43a0,d0
	bra	setsignflag1

hhcmpbit14:
	cmp	#$3fff,d0
	bhi	hhtstbit15

	btst	#13,d0
	bne	maxbit61
*maxbit60:
	or	#$b000,d0
	swap	d0
	move.b	d0,d1
	move.b	#$43,d0
	ror.l	#8,d0
	ror.l	#8,d1
	bra	setsignflag
maxbit61:
	and	#$1fff,d0
	or	#$8000,d0
	swap	d0
	move.b	d0,d1
	move.b	#$87,d0
	ror.l	#8,d0
	ror.l	#8,d1
	lsr.l	#1,d0
	roxr.l	#1,d1
	bra	setsignflag

hhtstbit15:
	tst	d0
	bmi	maxbit63
*maxbit62:
	swap	d0
	move	d0,d2
	and	#$fc00,d0
	rol.l	#6,d0
	and	#$000f,d0
	or	#$43d0,d0
	swap	d0
	and	#$03ff,d2
	and	#$fc00,d1
	or	d2,d1
	rol.l	#6,d1
	swap	d1
	bra	setsignflag
maxbit63:
	swap	d0
	move	d0,d2
	and	#$f800,d0
	rol.l	#5,d0
	and	#$000f,d0
	or	#$43e0,d0
	swap	d0
	and	#$07ff,d2
	and	#$f800,d1
	or	d2,d1
	rol.l	#5,d1
	swap	d1
	bra	setsignflag

	.end
