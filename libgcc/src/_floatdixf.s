	.title	libgcc.a(_floatdixf.o)

* long double __floatdixf (long long int);
*	long long intをlong doubleに変換して返す.

* 1997/10/24 立花.
*	long doubleの値を修正し、命令に埋め込むようにした.
*	省サイズ、高速化.

* 1997/11/12 立花.
*	関数呼び出しが正しく行われなくなっていた不具合を修正.


	.xref	___negdi2
	.xref	___floatsixf
	.xref	___addxf3
	.xref	___mulxf3
	.xref	___negxf2

	.cpu	68000

	.text

**xf_1shl32:
**	.dc.x	!401f0000_80000000_00000000

**xf_high_halfword_coeff:
**	.dc.x	!400f0000_80000000_00000000

___floatdixf::
	subq.l	#8,sp
	movem.l	d3-d7/a3-a6,-(sp)
	move.l	($30,sp),d6
	clr.l	($24,sp)	;negate = 0;
	move.l	($34,sp),d7
	bge	L000044

	move.l	d7,-(sp)	;if (u < 0)
	move.l	d6,-(sp)	;  u = -u, negate = 1;
	jsr	(___negdi2)
	addq.l	#8,sp
	move.l	d0,d6
	move.l	d1,d7
	moveq	#1,d5
	move.l	d5,($24,sp)
L000044:
	move.l	d7,d3		;d = (USItype) (u >> WORD_SIZE);
	move.l	d7,d4
	moveq	#31,d5
	asr.l	d5,d4
	move.l	d3,-(sp)
	jsr	(___floatsixf)
	movea.l	d0,a4
	movea.l	d1,a5
	movea.l	d2,a6
	move.l	d3,(sp)+
	bge	L000088

	moveq	#0,d0
	move.l	d0,-(sp)		;(xf_1shl32+8,pc)
	move.l	d0,-(sp)
	tas	(sp)			;(xf_1shl32+4,pc)
	move.l	#$401f0000,-(sp)	;(xf_1shl32+0,pc)
	movem.l	a4/a5/a6,-(sp)
	jsr	(___addxf3)
	lea	($18,sp),sp
	movea.l	d0,a4
	movea.l	d1,a5
	movea.l	d2,a6
L000088:
	move.l	#$400f0000,d3	;(xf_high_halfword_coeff+0,pc)
	moveq	#1,d4
	ror.l	d4,d4		;(xf_high_halfword_coeff+4,pc)
	moveq	#0,d5		;(xf_high_halfword_coeff+8,pc)
	lea	(___mulxf3),a3

	.rept	2
	movem.l	d3/d4/d5,-(sp)	;d *= HIGH_HALFWORD_COEFF;
	movem.l	a4/a5/a6,-(sp)
	jsr	(a3)
	lea	($18,sp),sp
	movea.l	d0,a4
	movea.l	d1,a5
	movea.l	d2,a6
	.endm

	move.l	d6,-(sp)
	jsr	(___floatsixf)
	movea.l	d0,a0
	movea.l	d1,a1
	movea.l	d2,a2
	move.l	d6,(sp)+
	bge	L000106

	moveq	#0,d0
	move.l	d0,-(sp)		;(xf_1shl32+8,pc)
	move.l	d0,-(sp)
	tas	(sp)			;(xf_1shl32+4,pc)
	move.l	#$401f0000,-(sp)	;(xf_1shl32+0,pc)
	movem.l	a0/a1/a2,-(sp)
	jsr	(___addxf3)
	lea	($18,sp),sp
	movea.l	d0,a0
	movea.l	d1,a1
	movea.l	d2,a2
L000106:
	movem.l	a0/a1/a2,-(sp)	;d += (USItype) (u & (HIGH_WORD_COEFF - 1));
	movem.l	a4/a5/a6,-(sp)
	jsr	(___addxf3)
	lea	($18,sp),sp

	tst.l	($24,sp)	;return (negate ? -d : d);
	beq	L000132

	movem.l	d0/d1/d2,-(sp)
	jsr	(___negxf2)
	lea	($c,sp),sp
L000132:
	movem.l	(sp)+,d3-d7/a3-a6
	addq.l	#8,sp
	rts

	.end
