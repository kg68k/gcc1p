	.title	libgcc.a(_extenddfxf2.o)

* long double __extenddfxf2 (double);
*	doubleをlong doubleに変換して返す.

* 1997/10/25 立花.
*	has version 3.09 fexpr.s(dotx/normalize)のコードを使用し、
*	若干修正して作成.

	.cpu	68000

	.text

___extenddfxf2::
	move.l	(4,sp),d0
	move.l	(8,sp),d1

	move.l	d3,-(sp)
	move.l	d0,d2
	clr	d0
	and.l	#$000fffff,d2
	swap	d0
	add.l	d0,d0
	lsr	#5,d0
	beq	dtox_zn
	cmpi	#$7ff,d0
	beq	dtox_ni
	bset	#$14,d2
	move.l	d1,d3
	move	d2,d3
	lsr.l	#5,d2
	ror.l	#5,d1
	ror.l	#5,d3
	swap	d1
	andi	#$f800,d1
	swap	d2
	swap	d3
	move	d3,d2
	exg.l	d1,d2
	addi	#$3fff-$3ff,d0
	add	d0,d0
	lsr.l	#1,d0
	swap	d0
	move.l	(sp)+,d3
	rts

dtox_ni:
	move	#$ffff,d0
	lsr.l	#1,d0
	move.l	d2,d3
	or.l	d1,d3
	bne	dtox_nan
dtox_i:
	moveq	#0,d1
	moveq	#0,d2
dtox_z:
	swap	d0
	move.l	(sp)+,d3
	rts

dtox_zn:
	lsr.l	#1,d0
	move.l	d2,d3
	or.l	d1,d3
	beq	dtox_z
	addi	#$3fff-$3ff+12,d0
	exg.l	d1,d2
**	move.l	(sp)+,d3
	bra	normalize

normalize:
**	move.l	d3,-(sp)
	move	d0,d3
	andi	#$7fff,d3
	beq	normalize9
	cmpi	#$7fff,d3
	beq	normalize_ni
	tst.l	d1
	bmi	normalize9
	bne	normalize1
	tst.l	d2
	beq	normalize_z
normalize1:
	subq	#1,d0
	add.l	d2,d2
	addx.l	d1,d1
	bmi	normalize9
	subq	#1,d3
	bne	normalize1
normalize9:
	swap	d0
	move.l	(sp)+,d3
	rts

normalize_z:
	andi	#$8000,d0
	swap	d0
	move.l	(sp)+,d3
	rts
normalize_ni:
	add.l	d1,d1
	or.l	d2,d1
	beq	normalize9
normalize_n:
dtox_nan:
	moveq	#-1,d1
	moveq	#-1,d2
	swap	d0
	move.l	(sp)+,d3
	rts

	.end
