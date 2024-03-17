	.title	libgcc.a(_fixxfdi.o)

* long long int __fixxfdi (long double);
*	long doubleをlong long intに変換して返す。

	.xref	___ltxf2,___negxf2
	.xref	___fixunsxfdi
	.xref	___negdi2

	.cpu	68000

	.text

**xf_zero:
**	.dc.x	0.0

___fixxfdi::
	movem.l	d3-d5,-(sp)
	movem.l	($10,sp),d3/d4/d5
	moveq	#0,d0
	move.l	d0,-(sp)	;(xf_zero+8,pc)
	move.l	d0,-(sp)	;(xf_zero+4,pc)
	move.l	d0,-(sp)	;(xf_zero+0,pc)
	movem.l	d3/d4/d5,-(sp)
	jsr	(___ltxf2)
	lea	($18,sp),sp
	tst.l	d0
	bge	L000066		;a < 0

	movem.l	d3/d4/d5,-(sp)	;return - __fixunsxfdi (-a);
	jsr	(___negxf2)
	lea	($c,sp),sp
	movem.l	d0/d1/d2,-(sp)
	jsr	(___fixunsxfdi)
	move.l	d1,-(sp)
	move.l	d0,-(sp)
	jsr	(___negdi2)
	addq.l	#8,sp
	bra	L000072

L000066:
	movem.l	d3/d4/d5,-(sp)	;return __fixunsxfdi (a);
	jsr	(___fixunsxfdi)
L000072:
	lea	($c,sp),sp
	movem.l	(sp)+,d3-d5
	rts

	.end
