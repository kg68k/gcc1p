	.title	libgcc.a(_moddi3.o)

* long long int __moddi3 (long long int, long long int);
*	long long int同士を除算し、余りをlong long intで返す。

	.cpu	68000

	.text

___moddi3::
	movem.l	(4,sp),d0/d1/d2/a0
	exg.l	d3,a0
	tst.l	d1
	bpl	modp
*modm:
	neg.l	d0
	negx.l	d1
	tst.l	d3
	bpl	modmp
*modmm:
	neg.l	d2
	negx.l	d3
	bsr	umod
	neg.l	d0
	negx.l	d1
	rts
modmp:
	bsr	umod
	neg.l	d0
	negx.l	d1
	rts

modp:
	tst.l	d3
	bpl	umod
*modpm:
	neg.l	d2
	negx.l	d3
	bra	umod


___umoddi3::
	movem.l	(4,sp),d0/d1/d2/a0
	exg.l	a0,d3
umod:
	move.l	d4,a1

	move.l	d2,d4
	or.l	d3,d4
	beq	modbyzero

	move.l	d0,d4
	or.l	d1,d4
	beq	retd0		;d0=d1=0

	cmp.l	d3,d1
	bhi	umod64
	bcs	retd0
	cmp.l	d2,d0
	beq	modzero
	bcs	retd0
umod64:
	tst.l	d3
	bmi	submod

	moveq	#-1,d4
sftloop:
	addq	#1,d4
	add.l	d2,d2
	addx.l	d3,d3
	bmi	fullbitmod
	cmp.l	d1,d3
	bhi	modloop
	bcs	sftloop
	cmp.l	d0,d2
	beq	modzero
	bcs	sftloop

modloop:
	lsr.l	#1,d3
	roxr.l	#1,d2
inloop:
	sub.l	d2,d0
	subx.l	d3,d1
	bpl	nextloop

	add.l	d2,d0
	addx.l	d3,d1
nextloop:
	dbra	d4,modloop
retd0:
	move.l	a0,d3
	move.l	a1,d4
	rts

fullbitmod:
	addq	#1,d4
	bra	inloop

submod:
	sub.l	d2,d0
	subx.l	d3,d1
	move.l	a0,d3
	move.l	a1,d4
	rts

modzero:
	moveq	#0,d0
	moveq	#0,d1
	move.l	a0,d3
	move.l	a1,d4
	rts

modbyzero:
	moveq	#0,d0
	divu	d0,d0
	bra	retd0

	.end
