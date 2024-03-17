	.title	libgcc.a(_ashrdi3.o)

* long long int __ashrdi3 (long long int, int);
*	long long intを算術右シフトしてlong long intで返す.

	.cpu	68000

	.text

___ashrdi3::
	movem.l	d3-d7,-(sp)
	move.l	($18,sp),d4	;low
	move.l	($1c,sp),d5	;high
	move.l	($20,sp),d6	;shift
	bne	L000018

	move.l	d4,d0		;shift = 0
	move.l	d5,d1
	bra	L000042
L000018:
	moveq	#32,d0
	sub.l	d6,d0
	tst.l	d0
	bgt	L00002e		;32 < shift

	move.l	d5,d3		;shift <= 32
	moveq	#31,d7
	asr.l	d7,d3
	neg.l	d0
	move.l	d5,d2
	asr.l	d0,d2
	bra	L00003e

L00002e:
	move.l	d5,d1
	asl.l	d0,d1
	move.l	d5,d3
	asr.l	d6,d3
	move.l	d4,d0
	lsr.l	d6,d0
	move.l	d0,d2
	or.l	d1,d2
L00003e:
	move.l	d2,d0
	move.l	d3,d1
L000042:
	movem.l	(sp)+,d3-d7
	rts

	.end
