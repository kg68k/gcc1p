	.title	libgcc.a(_udivmoddi4.o)

* unsigned long long int __udivmoddi4 (ull int, ull int, ull int*);
*	unsigned long long int 同士を除算し、商と余りを
*	unsigned long long int で返す。
*	解を格納するメモリへのポインタが0の場合は商のみ返す。

	.include	fefunc.mac

	.cpu	68000

	.text

__clz_tab:
	.dc.b	0,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
	.dc.b	6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
	.dc.b	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	.dc.b	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	.dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	.dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	.dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	.dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8

___udivmoddi4::
	lea	(-44,sp),sp
	movem.l	d3-d7/a3-a6,-(sp)
	move.l	($54,sp),d2
	move.l	($58,sp),d3
	move.l	($5c,sp),d0
	move.l	($60,sp),d1
	move.l	d0,($24,sp)
	move.l	d1,($28,sp)
	movea.l	d2,a5
	movea.l	d3,a3
	bne	L0003cc
	cmpa.l	d0,a3
	bcc	L00016a
	move.l	d0,d2
	cmp.l	#$ffff,d0
	bhi	L000046
	cmp.l	#$ff,d0
	shi	d0
	moveq	#8,d1
	and.l	d0,d1
	bra	L000054

L000046:
	moveq	#$18,d1
	cmpi.l	#$ffffff,($24,sp)
	bhi	L000054
	moveq	#$10,d1
L000054:
	move.l	d2,d0
	lsr.l	d1,d0
	lea	(__clz_tab,pc),a0
	adda.l	d0,a0
	moveq	#0,d0
	move.b	(a0),d0
	add.l	d1,d0
	moveq	#$20,d5
	sub.l	d0,d5
	movea.l	d5,a6
	beq	L000090
	move.l	($24,sp),d6
	asl.l	d5,d6
	move.l	d6,($24,sp)
	move.l	a3,d0
	asl.l	d5,d0
	moveq	#$20,d1
	sub.l	a6,d1
	move.l	a5,d6
	lsr.l	d1,d6
	move.l	d6,d1
	or.l	d1,d0
	movea.l	d0,a3
	move.l	a5,d6
	asl.l	d5,d6
	movea.l	d6,a5
L000090:
	move.l	($24,sp),d6
	clr	d6
	swap	d6
	move.l	d6,($28,sp)
	moveq	#0,d6
	move	($26,sp),d6
	movea.l	d6,a4
.ifdef	USE_FLOAT
	move.l	($28,sp),d1
	move.l	a3,d0
	FPACK	__UMOD
	move.l	d0,d4
	move.l	a3,d0
	FPACK	__UDIV
	movea.l	d0,a3
	move.l	a4,d1
	FPACK	__LMUL
	move.l	d0,d2
.else
	move.l	($28,sp),-(sp)
	move.l	a3,-(sp)
	.xref	 ___umodsi3
	jsr	(___umodsi3)
	addq.l	#8,sp
	move.l	d0,d4
	move.l	($28,sp),-(sp)
	move.l	a3,-(sp)
	.xref	 ___udivsi3
	jsr	(___udivsi3)
	addq.l	#8,sp
	movea.l	d0,a3
	move.l	a4,-(sp)
	move.l	a3,-(sp)
	.xref	 ___mulsi3
	jsr	(___mulsi3)
	addq.l	#8,sp
	move.l	d0,d2
.endif	/* !USE_FLOAT */
	move.l	d4,d1
	swap	d1
	clr	d1
	move.l	a5,d0
	clr	d0
	swap	d0
	move.l	d1,d4
	or.l	d0,d4
	cmp.l	d4,d2
	bls	L0000fc
	subq.l	#1,a3
	add.l	($24,sp),d4
	cmp.l	($24,sp),d4
	bcs	L0000fc
	cmp.l	d4,d2
	bls	L0000fc
	subq.l	#1,a3
	add.l	($24,sp),d4
L0000fc:
	sub.l	d2,d4
.ifdef	USE_FLOAT
	move.l	($28,sp),d1
	move.l	d4,d0
	FPACK	__UMOD
	move.l	d0,d3
	move.l	d4,d0
	FPACK	__UDIV
	move.l	d0,d4
	move.l	a4,d1
	FPACK	__LMUL
	move.l	d0,d2
.else
	move.l	($28,sp),-(sp)
	move.l	d4,-(sp)
	jsr	(___umodsi3)
	addq.l	#8,sp
	move.l	d0,d3
	move.l	($28,sp),-(sp)
	move.l	d4,-(sp)
	jsr	(___udivsi3)
	addq.l	#8,sp
	move.l	d0,d4
	move.l	a4,-(sp)
	move.l	d4,-(sp)
	jsr	(___mulsi3)
	addq.l	#8,sp
	move.l	d0,d2
.endif	/* !USE_FLOAT */
	move.l	d3,d1
	swap	d1
	clr	d1
	moveq	#0,d0
	move	a5,d0
	move.l	d1,d3
	or.l	d0,d3
	cmp.l	d3,d2
	bls	L000154
	subq.l	#1,d4
	add.l	($24,sp),d3
	cmp.l	($24,sp),d3
	bcs	L000154
	cmp.l	d3,d2
	bls	L000154
	subq.l	#1,d4
	add.l	($24,sp),d3
L000154:
	move.l	a3,d0
	swap	d0
	clr	d0
	or.l	d4,d0
	movea.l	d0,a1
	movea.l	d3,a5
	suba.l	d2,a5
	clr.l	($38,sp)
	bra	L0003b2

L00016a:
	tst.l	($24,sp)
	bne	L000184
.if 0
	clr.l	-(sp)
	pea	(1)
	jsr	(___udivsi3)
	addq.l	#8,sp
.else
	divu	#0,d0
.endif
	move.l	d0,($24,sp)
L000184:
	move.l	($24,sp),d2
	cmp.l	#$ffff,d2
	bhi	L00019e
	cmp.l	#$ff,d2
	shi	d0
	moveq	#8,d1
	and.l	d0,d1
	bra	L0001ac

L00019e:
	moveq	#$18,d1
	cmpi.l	#$ffffff,($24,sp)
	bhi	L0001ac
	moveq	#$10,d1
L0001ac:
	move.l	d2,d0
	lsr.l	d1,d0
	lea	(__clz_tab,pc),a0
	adda.l	d0,a0
	moveq	#0,d0
	move.b	(a0),d0
	add.l	d1,d0
	moveq	#$20,d6
	sub.l	d0,d6
	movea.l	d6,a6
	bne	L0001d4
	suba.l	($24,sp),a3
	moveq	#1,d6
	move.l	d6,($38,sp)
	bra	L0002e0

L0001d4:
	moveq	#$20,d6
	sub.l	a6,d6
	move.l	d6,($34,sp)
	move.l	($24,sp),d6
	move.l	a6,d7
	asl.l	d7,d6
	move.l	d6,($24,sp)
	move.l	a3,d3
	move.l	($34,sp),d7
	lsr.l	d7,d3
	move.l	a3,d1
	move.l	a6,d7
	asl.l	d7,d1
	move.l	a5,d0
	move.l	($34,sp),d7
	lsr.l	d7,d0
	or.l	d0,d1
	movea.l	d1,a3
	move.l	a5,d7
	move.l	a6,d5
	asl.l	d5,d7
	movea.l	d7,a5
	clr	d6
	swap	d6
	move.l	d6,($28,sp)
	moveq	#0,d5
	move	($26,sp),d5
	movea.l	d5,a4
.ifdef	USE_FLOAT
	move.l	d6,d1
	move.l	d3,d0
	FPACK	__UMOD
	move.l	d0,d4
	move.l	d3,d0
	FPACK	__UDIV
	move.l	d0,($2c,sp)
	move.l	a4,d1
	FPACK	__LMUL
	move.l	d0,d2
.else
	move.l	d6,-(sp)
	move.l	d3,-(sp)
	jsr	(___umodsi3)
	addq.l	#8,sp
	move.l	d0,d4
	move.l	d6,-(sp)
	move.l	d3,-(sp)
	jsr	(___udivsi3)
	addq.l	#8,sp
	move.l	d0,($2c,sp)
	move.l	a4,-(sp)
	move.l	($30,sp),-(sp)
	jsr	(___mulsi3)
	addq.l	#8,sp
	move.l	d0,d2
.endif	/* !USE_FLOAT */
	move.l	d4,d1
	swap	d1
	clr	d1
	move.l	a3,d0
	clr	d0
	swap	d0
	move.l	d1,d4
	or.l	d0,d4
	cmp.l	d4,d2
	bls	L000276
	subq.l	#1,($2c,sp)
	add.l	($24,sp),d4
	cmp.l	($24,sp),d4
	bcs	L000276
	cmp.l	d4,d2
	bls	L000276
	subq.l	#1,($2c,sp)
	add.l	($24,sp),d4
L000276:
	sub.l	d2,d4
.ifdef	USE_FLOAT
	move.l	($28,sp),d1
	move.l	d4,d0
	FPACK	__UMOD
	move.l	d0,d3
	move.l	d4,d0
	FPACK	__UDIV
	move.l	d0,d4
	move.l	a4,d1
	FPACK	__LMUL
	move.l	d0,d2
.else
	move.l	($28,sp),-(sp)
	move.l	d4,-(sp)
	jsr	(___umodsi3)
	addq.l	#8,sp
	move.l	d0,d3
	move.l	($28,sp),-(sp)
	move.l	d4,-(sp)
	jsr	(___udivsi3)
	addq.l	#8,sp
	move.l	d0,d4
	move.l	a4,-(sp)
	move.l	d4,-(sp)
	jsr	(___mulsi3)
	addq.l	#8,sp
	move.l	d0,d2
.endif	/* !USE_FLOAT */
	move.l	d3,d1
	swap	d1
	clr	d1
	moveq	#0,d0
	move	a3,d0
	move.l	d1,d3
	or.l	d0,d3
	cmp.l	d3,d2
	bls	L0002ce
	subq.l	#1,d4
	add.l	($24,sp),d3
	cmp.l	($24,sp),d3
	bcs	L0002ce
	cmp.l	d3,d2
	bls	L0002ce
	subq.l	#1,d4
	add.l	($24,sp),d3
L0002ce:
	move.l	($2c,sp),d0
	swap	d0
	clr	d0
	or.l	d4,d0
	move.l	d0,($38,sp)
	movea.l	d3,a3
	suba.l	d2,a3
L0002e0:
	move.l	($24,sp),d5
	clr	d5
	swap	d5
	move.l	d5,($28,sp)
	moveq	#0,d5
	move	($26,sp),d5
	movea.l	d5,a4
.ifdef	USE_FLOAT
	move.l	($28,sp),d1
	move.l	a3,d0
	FPACK	__UMOD
	move.l	d0,d4
	move.l	a3,d0
	FPACK	__UDIV
	movea.l	d0,a3
	move.l	a4,d1
	FPACK	__LMUL
	move.l	d0,d2
.else
	move.l	($28,sp),-(sp)
	move.l	a3,-(sp)
	jsr	(___umodsi3)
	addq.l	#8,sp
	move.l	d0,d4
	move.l	($28,sp),-(sp)
	move.l	a3,-(sp)
	jsr	(___udivsi3)
	addq.l	#8,sp
	movea.l	d0,a3
	move.l	a4,-(sp)
	move.l	a3,-(sp)
	jsr	(___mulsi3)
	addq.l	#8,sp
	move.l	d0,d2
.endif	/* !USE_FLOAT */
	move.l	d4,d1
	swap	d1
	clr	d1
	move.l	a5,d0
	clr	d0
	swap	d0
	move.l	d1,d4
	or.l	d0,d4
	cmp.l	d4,d2
	bls	L00034c
	subq.l	#1,a3
	add.l	($24,sp),d4
	cmp.l	($24,sp),d4
	bcs	L00034c
	cmp.l	d4,d2
	bls	L00034c
	subq.l	#1,a3
	add.l	($24,sp),d4
L00034c:
	sub.l	d2,d4
.ifdef	USE_FLOAT
	move.l	($28,sp),d1
	move.l	d4,d0
	FPACK	__UMOD
	move.l	d0,d3
	move.l	d4,d0
	FPACK	__UDIV
	move.l	d0,d4
	move.l	a4,d1
	FPACK	__LMUL
	move.l	d0,d2
.else
	move.l	($28,sp),-(sp)
	move.l	d4,-(sp)
	jsr	(___umodsi3)
	addq.l	#8,sp
	move.l	d0,d3
	move.l	($28,sp),-(sp)
	move.l	d4,-(sp)
	jsr	(___udivsi3)
	addq.l	#8,sp
	move.l	d0,d4
	move.l	a4,-(sp)
	move.l	d4,-(sp)
	jsr	(___mulsi3)
	addq.l	#8,sp
	move.l	d0,d2
.endif	/* !USE_FLOAT */
	move.l	d3,d1
	swap	d1
	clr	d1
	moveq	#0,d0
	move	a5,d0
	move.l	d1,d3
	or.l	d0,d3
	cmp.l	d3,d2
	bls	L0003a4
	subq.l	#1,d4
	add.l	($24,sp),d3
	cmp.l	($24,sp),d3
	bcs	L0003a4
	cmp.l	d3,d2
	bls	L0003a4
	subq.l	#1,d4
	add.l	($24,sp),d3
L0003a4:
	move.l	a3,d0
	swap	d0
	clr	d0
	or.l	d4,d0
	movea.l	d0,a1
	movea.l	d3,a5
	suba.l	d2,a5
L0003b2:
	tst.l	($64,sp)
	beq	L000626
	move.l	a5,d5
	move.l	a6,d6
	lsr.l	d6,d5
	move.l	d5,($3c,sp)
	clr.l	($40,sp)
	bra	L000618

L0003cc:
	cmpa.l	($28,sp),a3
	bcc	L0003ec
	suba.l	a1,a1
	clr.l	($38,sp)
	tst.l	($64,sp)
	beq	L000626
	move.l	a5,($3c,sp)
	move.l	a3,($40,sp)
	bra	L000618

L0003ec:
	move.l	($28,sp),d2
	cmp.l	#$ffff,d2
	bhi	L000406
	cmp.l	#$ff,d2
	shi	d0
	moveq	#8,d1
	and.l	d0,d1
	bra	L000414

L000406:
	moveq	#$18,d1
	cmpi.l	#$ffffff,($28,sp)
	bhi	L000414
	moveq	#$10,d1
L000414:
	move.l	d2,d0
	lsr.l	d1,d0
	lea	(__clz_tab,pc),a0
	adda.l	d0,a0
	moveq	#0,d0
	move.b	(a0),d0
	add.l	d1,d0
	moveq	#$20,d5
	sub.l	d0,d5
	movea.l	d5,a6
	bne	L00046c
	suba.l	a1,a1		;q0 = 0
	cmpa.l	($28,sp),a3
	bhi	L00043a
	cmpa.l	($24,sp),a5
	bcs	L000452
L00043a:
	addq.l	#1,a1		;q0 = 1
	move.l	a3,d5
	move.l	a5,d6
	move.l	($28,sp),d7
	sub.l	($24,sp),d6
	subx.l	d7,d5
	movea.l	d5,a3
	movea.l	d6,a5
	bra	L000454

L000452:
**	suba.l	a1,a1		;q0 = 0
L000454:
	clr.l	($38,sp)
	tst.l	($64,sp)
	beq	L000626
	move.l	a5,($3c,sp)
	move.l	a3,($40,sp)
	bra	L000618

L00046c:
	moveq	#$20,d5
	sub.l	a6,d5
	move.l	d5,($34,sp)
	move.l	($28,sp),d1
	move.l	a6,d5
	asl.l	d5,d1
	move.l	($24,sp),d0
	move.l	($34,sp),d5
	lsr.l	d5,d0
	or.l	d0,d1
	move.l	d1,($28,sp)
	move.l	($24,sp),d5
	move.l	a6,d6
	asl.l	d6,d5
	move.l	d5,($24,sp)
	move.l	a3,d3
	move.l	($34,sp),d6
	lsr.l	d6,d3
	move.l	a3,d1
	move.l	a6,d6
	asl.l	d6,d1
	move.l	a5,d0
	move.l	($34,sp),d6
	lsr.l	d6,d0
	or.l	d0,d1
	movea.l	d1,a3
	move.l	a5,d6
	move.l	a6,d7
	asl.l	d7,d6
	movea.l	d6,a5
	move.l	($28,sp),d7
	clr	d7
	swap	d7
	movea.l	d7,a4
	moveq	#0,d7
	move	($2a,sp),d7
	move.l	d7,($30,sp)
.ifdef	USE_FLOAT
	move.l	a4,d1
	move.l	d3,d0
	FPACK	__UMOD
	move.l	d0,d4
	move.l	d3,d0
	FPACK	__UDIV
	move.l	d0,($2c,sp)
	move.l	d7,d1
	FPACK	__LMUL
	move.l	d0,d2
.else
	move.l	a4,-(sp)
	move.l	d3,-(sp)
	jsr	(___umodsi3)
	addq.l	#8,sp
	move.l	d0,d4
	move.l	a4,-(sp)
	move.l	d3,-(sp)
	jsr	(___udivsi3)
	addq.l	#8,sp
	move.l	d0,($2c,sp)
	move.l	d7,-(sp)
	move.l	($30,sp),-(sp)
	jsr	(___mulsi3)
	addq.l	#8,sp
	move.l	d0,d2
.endif	/* !USE_FLOAT */
	move.l	d4,d1
	swap	d1
	clr	d1
	move.l	a3,d0
	clr	d0
	swap	d0
	move.l	d1,d4
	or.l	d0,d4
	cmp.l	d4,d2
	bls	L00052a
	subq.l	#1,($2c,sp)
	add.l	($28,sp),d4
	cmp.l	($28,sp),d4
	bcs	L00052a
	cmp.l	d4,d2
	bls	L00052a
	subq.l	#1,($2c,sp)
	add.l	($28,sp),d4
L00052a:
	sub.l	d2,d4
.ifdef	USE_FLOAT
	move.l	a4,d1
	move.l	d4,d0
	FPACK	__UMOD
	move.l	d0,d3
	move.l	d4,d0
	FPACK	__UDIV
	move.l	d0,d4
	move.l	($30,sp),d1
	FPACK	__LMUL
	move.l	d0,d2
.else
	move.l	a4,-(sp)
	move.l	d4,-(sp)
	jsr	(___umodsi3)
	addq.l	#8,sp
	move.l	d0,d3
	move.l	a4,-(sp)
	move.l	d4,-(sp)
	jsr	(___udivsi3)
	addq.l	#8,sp
	move.l	d0,d4
	move.l	($30,sp),-(sp)
	move.l	d4,-(sp)
	jsr	(___mulsi3)
	addq.l	#8,sp
	move.l	d0,d2
.endif	/* !USE_FLOAT */
	move.l	d3,d1
	swap	d1
	clr	d1
	moveq	#0,d0
	move	a3,d0
	move.l	d1,d3
	or.l	d0,d3
	cmp.l	d3,d2
	bls	L000580
	subq.l	#1,d4
	add.l	($28,sp),d3
	cmp.l	($28,sp),d3
	bcs	L000580
	cmp.l	d3,d2
	bls	L000580
	subq.l	#1,d4
	add.l	($28,sp),d3
L000580:
	move.l	($2c,sp),d0
	swap	d0
	clr	d0
	or.l	d4,d0
	movea.l	d0,a1
	movea.l	d3,a3
	suba.l	d2,a3
	move.l	a1,d0
	move.l	($24,sp),d1
	move.l	d0,d2
	swap	d0
	move.l	d1,d3
	swap	d1
	move	d2,d4
	mulu	d3,d4
	mulu	d1,d2
	mulu	d0,d3
	mulu	d0,d1
	move.l	d4,d0
	eor	d0,d0
	swap	d0
	add.l	d0,d2
	add.l	d3,d2
	bcc	L0005ba
	add.l	#$10000,d1
L0005ba:
	swap	d2
	moveq	#0,d0
	move	d2,d0
	move	d4,d2
	movea.l	d2,a0
	add.l	d1,d0
	movea.l	d0,a4
	cmpa.l	a4,a3
	bcs	L0005d2
	bne	L0005e6
	cmpa.l	a0,a5
	bcc	L0005e6
L0005d2:
	subq.l	#1,a1
	move.l	a4,d7
	move.l	a0,d5
	move.l	($28,sp),d6
	sub.l	($24,sp),d5
	subx.l	d6,d7
	movea.l	d7,a4
	movea.l	d5,a0
L0005e6:
	clr.l	($38,sp)
	tst.l	($64,sp)
	beq	L000626
	move.l	a3,d6
	move.l	a5,d7
	move.l	a4,d5
	sub.l	a0,d7
	subx.l	d5,d6
	movea.l	d6,a3
	movea.l	d7,a5
	move.l	a3,d1
	move.l	($34,sp),d5
	asl.l	d5,d1
	move.l	a5,d0
	move.l	a6,d5
	lsr.l	d5,d0
	or.l	d0,d1
	move.l	d1,($3c,sp)
	lsr.l	d5,d6
	move.l	d6,($40,sp)
L000618:
	movea.l	($64,sp),a2
	move.l	($3c,sp),(a2)
	move.l	($40,sp),(4,a2)
L000626:
	move.l	a1,($44,sp)
	move.l	($38,sp),($48,sp)
	move.l	($44,sp),d0
	move.l	($48,sp),d1
	movem.l	(sp)+,d3-d7/a3-a6
	lea	($2c,sp),sp
	rts

	.end
