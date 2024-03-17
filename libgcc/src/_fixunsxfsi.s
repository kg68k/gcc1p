	.title	libgcc.a(_fixunsxfsi.o)

* unsigned int __fixunsxfdi (long double);
*	long doubleをunsigned intに変換して返す。

	.xref	___gexf2
	.xref	___fixxfsi
	.xref	___addxf3

	.cpu	68000

	.text

**xf_neglongmin:
**	.dc.x	!401e0000_80000000_00000000

**xf_longmin:
**	.dc.x	!c01e0000_80000000_00000000

___fixunsxfsi::
	movem.l	d3-d5,-(sp)
	movem.l	($10,sp),d3/d4/d5
	moveq	#0,d0
	move.l	d0,-(sp)		;(xf_neglongmin+8,pc)
	move.l	d0,-(sp)
	tas	(sp)			;(xf_neglongmin+4,pc)
	move.l	#$401e0000,-(sp)	;(xf_neglongmin+0,pc)
	movem.l	d3/d4/d5,-(sp)
	jsr	(___gexf2)
	lea	($18,sp),sp
	tst.l	d0
	bge	L00005a		;a >= - (DFtype) LONG_MIN

	movem.l	d3/d4/d5,-(sp)	;return (SItype) a;
	jsr	(___fixxfsi)
	bra	L000092
L00005a:
	moveq	#0,d0
	move.l	d0,-(sp)		;(xf_longmin+8,pc)
	move.l	d0,-(sp)
	tas	(sp)			;(xf_longmin+4,pc)
	move.l	#$c01e0000,-(sp)	;(xf_longmin+0,pc)
	movem.l	d3/d4/d5,-(sp)
	jsr	(___addxf3)	;return (SItype) (a + LONG_MIN) - LONG_MIN;
	lea	($18,sp),sp
	movem.l	d0/d1/d2,-(sp)
	jsr	(___fixxfsi)
**	add.l	#$80000000,d0
	moveq	#31,d1
	bchg	d1,d0
L000092:
	lea	(12,sp),sp
	movem.l	(sp)+,d3-d5
	rts

	.end
