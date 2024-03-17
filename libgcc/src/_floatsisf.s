	.title	libgcc.a(_floatsisf.o)

* float __floatsisf (int);
*	intをfloatに変換して返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
si:	.ds.l	1

	.text

___floatsisf::
	move.l	(4,sp),d0
	beq	return_d0

.ifdef	USE_FLOAT
	FPACK	__LTOF
return_d0:
	rts

.else
	movea.l	d0,a0		;符号
	bpl	@f
	neg.l	d0
@@:
	moveq	#31,d1
msb_loop:
	btst	d1,d0		;始めて'1'になるビット位置を探す
	dbne	d1,msb_loop
	moveq	#-23,d2
	add	d1,d2
	bmi	shift_left
	beq	shift_skip

	lsr.l	d2,d0
	bra	shift_skip
shift_left:
	neg	d2
	lsl.l	d2,d0
shift_skip:
	lsl	#7,d1
	addi	#($7f-1)<<7,d1	;仮数の最上位桁をはみ出て'1'があるので-1
	swap	d1
	add.l	d1,d0

	move.l	a0,d2
	bpl	return_d0
	bchg	#31,d0
return_d0:
	rts
.endif	/* !USE_FLOAT */

	.end
