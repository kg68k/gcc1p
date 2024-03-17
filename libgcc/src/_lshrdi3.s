	.title	libgcc.a(_lshrdi3.o)

* long long int __lshrdi3 (long long int, int);
*	long long intを論理右シフトしてlong long intで返す。

	.cpu	68000

	.text

___lshrdi3::
	movem.l	d3-d6,-(sp)
	move.l	($14,sp),d4	;low
	move.l	($18,sp),d5	;high
	move.l	($1c,sp),d6	;shift
	bne	L000018

	move.l	d4,d0		;shift = 0
	move.l	d5,d1
	bra	L00003e
L000018:
	moveq	#32,d0
	sub.l	d6,d0
	tst.l	d0
	bgt	L00002a		;32 < shift

	moveq	#0,d3		;shift <= 32
	neg.l	d0
	move.l	d5,d2
	lsr.l	d0,d2
	bra	L00003a

L00002a:
	move.l	d5,d1
	asl.l	d0,d1
	move.l	d5,d3
	lsr.l	d6,d3
	move.l	d4,d0
	lsr.l	d6,d0
	move.l	d0,d2
	or.l	d1,d2
L00003a:
	move.l	d2,d0
	move.l	d3,d1
L00003e:
	movem.l	(sp)+,d3-d6
	rts

	.end
