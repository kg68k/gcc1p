	.title	libgcc.a(_truncxfdf2.o)

* double _truncxfdf2 (long double);
*	long doubleをdoubleに変換して返す.

* 1997/10/25 立花.
*	has version 3.09 fexpr.s(xotd)のコードを使用し、若干修正して作成.

	.cpu	68000

	.text

___truncxfdf2::
	movem.l	(4,sp),d0-d2
	swap	d0
	move	d0,-(sp)
	andi	#$7fff,d0
	beq	xtod_z
	cmpi	#$3fff+$7ff-$3ff,d0
	bcc	xtod_ni
	subi	#$3fff-$3ff,d0
	bhi	xtod5
	beq	xtod6

	neg	d0
	cmpi	#52,d0
	bhi	xtod_z
	subq	#1,d0
xtod1:
	lsr.l	#1,d1
	roxr.l	#1,d2
	dbra	d0,xtod1
	moveq	#0,d0
	bra	xtod6
xtod5:
	add.l	d2,d2
	addx.l	d1,d1
xtod6:
	btst.l	#31-(52-32),d2
	beq	xtod_7
	add.l	#1<<(31-(52-32)),d2
	bcc	xtod_7
	addq.l	#1,d1
	bcc	xtod_7
	addq	#1,d0
	cmpi	#$7ff,d0
	beq	xtod_i
xtod_7:
	andi.l	#$fffff000,d2
	or	d0,d2
	swap	d2
	swap	d1
	move.l	d2,d0
	move	d1,d0
	move	d2,d1

	move.l	d1,d2
	move	d0,d2
	rol.l	#5,d0
	rol.l	#5,d1
	rol.l	#5,d2
	andi	#$001f,d0
	andi	#$ffe0,d1
	or	d0,d1
	move	d2,d0

	lsl	(sp)+
	roxr.l	#1,d0
	roxr.l	#1,d1
	rts

xtod_z:
	moveq	#0,d0
	moveq	#0,d1
	lsl	(sp)+
	roxr.l	#1,d0
	rts

xtod_ni:
	cmpi	#$7fff,d0
	bne	xtod_i
	add.l	d1,d1
	or.l	d2,d1
	beq	xtod_i
xtod_n:
	moveq	#-1,d0
	moveq	#-1,d1
	bra	xtod_i9
xtod_i:
	move.l	#$ff000000,d0
	moveq	#0,d1
xtod_i9:
	lsl	(sp)+
	roxr.l	#1,d0
	rts

	.end
