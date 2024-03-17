	.title	libgcc.a(_udiv_w_sdiv.o)

* unsigned int __udiv_w_sdiv (unsigned int*, unsigned int, unsigned int, unsigned int);
*	除算ルーチン.

* sdiv_qrnnd()がどこにもないのでリンク出来ない.


	.xref	_sdiv_qrnnd

	.cpu	68000

	.text

___udiv_w_sdiv::
	movem.l	d3-d7/a3-a5,-(sp)
	movea.l	($24,sp),a4
	move.l	($28,sp),d5
	movea.l	($2c,sp),a3
	move.l	($30,sp),d7
	blt	L000070

	move.l	d7,d0		;if ((SItype) d >= 0)
	sub.l	d5,d0
	move.l	a3,d1
	moveq	#31,d6
	lsr.l	d6,d1
	sub.l	d1,d0
	cmp.l	d5,d0
	bls	L00003e

	move.l	d7,-(sp)	;if (a1 < d - a1 - (a0 >> (SI_TYPE_SIZE - 1)))
	move.l	a3,-(sp)
	move.l	d5,-(sp)
	move.l	d3,-(sp)
	move.l	d4,-(sp)
	jsr	(_sdiv_qrnnd)	;sdiv_qrnnd (q, r, a1, a0, d);
	lea	($14,sp),sp
	bra	L000148
L00003e:
	move.l	d7,d1		;else
	lsr.l	#1,d1
	move.l	d7,d0
	moveq	#31,d6
	asl.l	d6,d0
	move.l	d5,d2
	move.l	a3,d6
	sub.l	d0,d6
	subx.l	d1,d2
	move.l	d6,d1
	move.l	d7,-(sp)
	move.l	d1,-(sp)
	move.l	d2,-(sp)
	move.l	d3,-(sp)
	move.l	d4,-(sp)
	jsr	(_sdiv_qrnnd)	;sdiv_qrnnd (q, r, c1, c0, d);
	add.l	#$80000000,d4	;q += (USItype) 1 << (SI_TYPE_SIZE - 1);
	lea	($14,sp),sp
	bra	L000148

L000070:
	move.l	d7,d6		;else
	lsr.l	#1,d6
	movea.l	d6,a5		;b1 = d >> 1;
	move.l	d5,d2
	lsr.l	#1,d2		;c1 = a1 >> 1;
	move.l	d5,d1
	moveq	#31,d6
	asl.l	d6,d1
	move.l	a3,d0
	lsr.l	#1,d0
	add.l	d0,d1		;c0 = (a1 << (SI_TYPE_SIZE - 1)) + (a0 >> 1);
	cmpa.l	d5,a5
	bls	L0000c2

	move.l	a5,-(sp)	;if (a1 < b1)
	move.l	d1,-(sp)
	move.l	d2,-(sp)
	move.l	d3,-(sp)
	move.l	d4,-(sp)
	jsr	(_sdiv_qrnnd)	;sdiv_qrnnd (q, r, c1, c0, b1);
	move.l	d3,d1
	add.l	d1,d1
	move.l	a3,d0
	moveq	#1,d6
	and.l	d6,d0
	move.l	d1,d3
	add.l	d0,d3		;r = 2*r + (a0 & 1);
	lea	($14,sp),sp
	btst	#0,d7
	beq	L000148
	cmp.l	d3,d4		;if ((d & 1) != 0)
	bls	L000106		;  if (r >= q)
	move.l	d4,d0
	sub.l	d3,d0
	cmp.l	d0,d7
	bcc	L000112		;else if (q - r <= d)
	bra	L00011e		;else

L0000c2:
	cmpa.l	d2,a5
	bls	L00012e

	move.l	d2,d0		;else if (c1 < b1)
	addq.l	#1,d0
	move.l	a5,-(sp)
	not.l	d1		;c0 = ~c0;
	move.l	d1,-(sp)
	move.l	a5,d6
	sub.l	d0,d6		;c1 = (b1 - 1) - c1;
	move.l	d6,-(sp)
	move.l	d3,-(sp)
	move.l	d4,-(sp)
	jsr	(_sdiv_qrnnd)	;sdiv_qrnnd (q, r, c1, c0, b1);
	not.l	d4		;q = ~q;
	move.l	d3,d0
	addq.l	#1,d0
	move.l	a5,d3
	sub.l	d0,d3		;r = (b1 - 1) - r;
	move.l	d3,d1
	add.l	d1,d1
	move.l	a3,d0
	moveq	#1,d6
	and.l	d6,d0
	move.l	d1,d3
	add.l	d0,d3		;r = 2*r + (a0 & 1);
	lea	($14,sp),sp
	btst	#0,d7
	beq	L000148
	cmp.l	d3,d4		;if ((d & 1) != 0)
	bhi	L00010a
L000106:			;if (r >= q)
	sub.l	d4,d3		;  r = r - q;
	bra	L000148
L00010a:
	move.l	d4,d0
	sub.l	d3,d0
	cmp.l	d0,d7
	bcs	L00011e
L000112:
	move.l	d3,d0		;else if (q - r <= d)
	sub.l	d4,d0
	move.l	d0,d3
	add.l	d7,d3		;  r = r - q + d;
	subq.l	#1,d4		;  q--;
	bra	L000148

L00011e:
	move.l	d3,d1		;else
	sub.l	d4,d1
	move.l	d7,d0
	add.l	d0,d0
	move.l	d1,d3
	add.l	d0,d3		;  r = r - q + 2*d;
	subq.l	#2,d4		;  q -= 2;
	bra	L000148

L00012e:
	move.l	d7,d0		;else
	neg.l	d0
	cmp.l	a3,d0
	bhi	L00013e

	moveq	#-1,d4		;if (a0 >= -d)
	move.l	a3,d3		;  q = -1;
	add.l	d7,d3		;  r = a0 + d;
	bra	L000148
L00013e:
	moveq	#-2,d4		;else
	move.l	d7,d0		;  q = -2;
	add.l	d0,d0
	move.l	a3,d3
	add.l	d0,d3		;  r = a0 + 2*d;
L000148:
	move.l	d3,(a4)		;*rp = r;
	move.l	d4,d0		;return q;
	movem.l	(sp)+,d3-d7/a3-a5
	rts

	.end
