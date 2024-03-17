	.title	libgcc.a(_divdi3.o)

* long long int __divdi3 (long long int, long long int);
*	long long int同士を除算し、商をlong long intで返す.

* unsigned long long int __udivdi3 (ull int, ull int);
*	unsigned long long int同士を除算し、商をunsigned long long int
*	で返す.


* 1997/10/24 立花.
*	_udivdi3.s を統合.
*	libgnu-1.50p2 divdi3.s のコードに入れ換えた.

* 1998/11/13 立花.
*	USE_FLOAT 定義時は __udivsi3() ではなく FLOAT を呼び出すようにし
*	た.


	.include	fefunc.mac

	.cpu	68000

	.text

___divdi3::
	movem.l	(4,sp),d0/d1/d2/a0
	exg.l	d3,a0
	tst.l	d1
	bpl	divp
*divm:
	neg.l	d0
	negx.l	d1
	tst.l	d3
	bpl	divmp
*divmm:
	neg.l	d2
	negx.l	d3
	bra	udiv
divmp:
	bsr	udiv
	neg.l	d0
	negx.l	d1
	rts
divp:
	tst.l	d3
	bpl	udiv
*divpm:
	neg.l	d2
	negx.l	d3
	bsr	udiv
	neg.l	d0
	negx.l	d1
	rts


___udivdi3::
	movem.l	(4,sp),d0/d1/d2/a0
	exg.l	a0,d3
udiv:
	move.l	d4,a1

	move.l	d0,d4
	or.l	d1,d4
	beq	divzero

	move.l	d2,d4
	or.l	d3,d4
	beq	divbyzero

	cmp.l	d3,d1
	bhi	udiv64
	bcs	divzero
	cmp.l	d2,d0
	bcs	divzero
	beq	retone
udiv64:
	tst.l	d3
	bmi	retone
	bne	@f
	tst.l	d1
	bne	@f

.ifdef	USE_FLOAT
	move.l	d2,d1
	FPACK	__UDIV
	move.l	a0,d3
	move.l	a1,d4
.else
	move.l	a1,-(sp)		;save d4
	move.l	a0,-(sp)		;save d3
	move.l	d2,-(sp)
	move.l	d0,-(sp)
	.xref	 ___udivsi3
	jsr	(___udivsi3)
	addq.l	#8,sp
	move.l	(sp)+,d3		;restore d3
	move.l	(sp)+,d4		;restore d4
.endif	/* !USE_FLOAT */
	moveq	#0,d1
	rts
@@:
	move.l	d5,a2
	move.l	d6,-(sp)
	moveq	#0,d6
	moveq	#0,d5
	moveq	#-1,d4

sftloop:
	addq	#1,d4
	add.l	d2,d2
	addx.l	d3,d3
	bmi	fullbitdiv
	cmp.l	d1,d3
	bhi	startloop
	bcs	sftloop
	cmp.l	d0,d2
	beq	equdiv
	bcs	sftloop

divloop:
	add.l	d5,d5
	addx.l	d6,d6
startloop:
	lsr.l	#1,d3
	roxr.l	#1,d2
inloop:
	sub.l	d2,d0
	subx.l	d3,d1
	bmi	clrbit
setbit:
	addq	#1,d5
	dbra	d4,divloop
	bra	udivexit
clrbit:
	add.l	d2,d0
	addx.l	d3,d1
	dbra	d4,divloop

udivexit:
	move.l	d6,d1
	move.l	d5,d0

	move.l	a0,d3
	move.l	a1,d4
	move.l	a2,d5
	move.l	(sp)+,d6
	rts

fullbitdiv:
	addq	#1,d4
	bra	inloop

equdiv:
	moveq	#0,d1
	moveq	#0,d0
	addq	#1,d4
	cmpi	#31,d4
	bhi	upperbitset
	bset	d4,d0

	move.l	a0,d3
	move.l	a1,d4
	move.l	a2,d5
	move.l	(sp)+,d6
	rts

upperbitset:
	subi	#32,d4
	bset	d4,d1

	move.l	a0,d3
	move.l	a1,d4
	move.l	a2,d5
	move.l	(sp)+,d6
	rts

divzero:
	moveq	#0,d0
	moveq	#0,d1
	move.l	a0,d3
	move.l	a1,d4
	rts

retone:
	moveq	#1,d0
	moveq	#0,d1
	move.l	a0,d3
	move.l	a1,d4
	rts

divbyzero:
	moveq	#0,d0
	divu	d0,d0
	move.l	a0,d3
	move.l	a1,d4
	rts

	.end
