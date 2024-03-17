	.title	libgcc.a(_fixunsxfdi.o)

* long long int __fixunsxfdi (long double);
*	long doubleをlong long intに変換して返す。
*	返値の型はsignedだが、実際にはunsignedを返す機能の関数であり
*	引数が負数の場合は0を返す。

	.xref	___ltxf2,___negxf2
	.xref	___divxf3,___addxf3,___subxf3
	.xref	___fixunsxfsi
	.xref	___floatdixf
	.xref	___cmpdi2

	.cpu	68000

	.text

**xf_zero:
**	.dc.x	0.0

**xf_coeff:	;double(1<<32)
**	.dc.x	!401f0000_80000000_00000000

**xf_1shl64:	;double(1<<64)
**	.dc.x	!403f0000_80000000_00000000

___fixunsxfdi::
	lea	(-12,sp),sp
	movem.l	d3-d6/a3-a6,-(sp)
	moveq	#0,d0
	move.l	d0,-(sp)	;(xf_zero+8,pc)
	move.l	d0,-(sp)	;(xf_zero+4,pc)
	move.l	d0,-(sp)	;(xf_zero+0,pc)
	move.l	($44,sp),-(sp)
	move.l	($44,sp),-(sp)
	move.l	($44,sp),-(sp)
	move.l	#___ltxf2,d3
	movea.l	d3,a0
	jsr	(a0)
	lea	($18,sp),sp
	tst.l	d0
	bge	L00005e

	moveq	#0,d0		;負数なら0を返す
	moveq	#0,d1
	bra	L0001ce
L00005e:
	moveq	#0,d0
	move.l	d0,-(sp)		;(xf_coeff+8,pc)
	move.l	d0,-(sp)
	tas	(sp)			;(xf_coeff+4,pc)
	move.l	#$401f0000,-(sp)	;(xf_coeff+0,pc)
	move.l	($44,sp),-(sp)
	move.l	($44,sp),-(sp)
	move.l	($44,sp),-(sp)
	jsr	(___divxf3)	;b = (a / HIGH_WORD_COEFF);
	lea	($18,sp),sp
	lea	(___fixunsxfsi),a6
	movem.l	d0/d1/d2,-(sp)
	jsr	(a6)		;v = (USItype) b;
	lea	($c,sp),sp

	move.l	d1,($20,sp)
	move.l	d0,($24,sp)
	move.l	d0,-(sp)
	move.l	d1,-(sp)
	jsr	(___floatdixf)
	addq.l	#8,sp
	movea.l	d0,a3
	movea.l	d1,a4
	movea.l	d2,a5
	moveq	#0,d4
	moveq	#0,d5
	move.l	d5,-(sp)
	move.l	d4,-(sp)
	move.l	($2c,sp),-(sp)
	move.l	($2c,sp),-(sp)
	jsr	(___cmpdi2)
	lea	($10,sp),sp
	moveq	#1,d4
	cmp.l	d0,d4
	ble	L000108		;負数ならシフト出来ないのでチェックしている

	moveq	#0,d0
	move.l	d0,-(sp)		;(xf_1shl64+8,pc)
	move.l	d0,-(sp)
	tas	(sp)			;(xf_1shl64+4,pc)
	move.l	#$403f0000,-(sp)	;(xf_1shl64+0,pc)
	movem.l	a3/a4/a5,-(sp)
	jsr	(___addxf3)
	lea	($18,sp),sp
	movea.l	d0,a3
	movea.l	d1,a4
	movea.l	d2,a5
L000108:
	movem.l	a3/a4/a5,-(sp)
	move.l	($44,sp),-(sp)
	move.l	($44,sp),-(sp)
	move.l	($44,sp),-(sp)
	jsr	(___subxf3)	;a -= (XFtype)v;
	lea	($18,sp),sp
	movem.l	d0-d2,($30,sp)

	moveq	#0,d0
	move.l	d0,-(sp)	;(xf_zero+8,pc)
	move.l	d0,-(sp)	;(xf_zero+4,pc)
	move.l	d0,-(sp)	;(xf_zero+0,pc)
	move.l	($44,sp),-(sp)
	move.l	($44,sp),-(sp)
	move.l	($44,sp),-(sp)
	movea.l	d3,a0
	jsr	(a0)
	lea	($18,sp),sp
	tst.l	d0
	bge	L000192

	move.l	($38,sp),-(sp)	;if (a < 0)
	move.l	($38,sp),-(sp)	;  v -= (USItype) (- a);
	move.l	($38,sp),-(sp)
	jsr	(___negxf2)
	movem.l	d0/d1/d2,(sp)
	jsr	(a6)
	lea	($c,sp),sp
	moveq	#0,d1
	move.l	($20,sp),d2
	sub.l	d0,d2
	cmp.l	($20,sp),d2
	shi	d4
	ext	d4
	ext.l	d4
	move.l	($24,sp),d3
	sub.l	d1,d3
	add.l	d4,d3
	bra	L0001be

L000192:
	move.l	($38,sp),-(sp)	;else
	move.l	($38,sp),-(sp)	;  v += (USItype) a;
	move.l	($38,sp),-(sp)
	jsr	(a6)
	lea	($c,sp),sp
	moveq	#0,d1
	move.l	($20,sp),d2
	add.l	d0,d2
	cmp.l	($20,sp),d2
	scs	d4
	ext	d4
	ext.l	d4
	move.l	($24,sp),d3
	add.l	d1,d3
	sub.l	d4,d3
L0001be:
	move.l	d2,d0		;return v;
	move.l	d3,d1
L0001ce:
	movem.l	(sp)+,d3-d6/a3-a6
	lea	(12,sp),sp
	rts

	.end
