	.title	libgcc.a(_eqxf2.o)

* int __eqxf2 (long double, long double);
*	long double同士を比較し、等しくないか否かの真偽値をintで返す。

	.xref	___cmpxf2

	.cpu	68000

	.text

___nexf2::
	movem.l	(4,sp),d0-d2/a0-a2
	movem.l	d0-d2/a0-a2,-(sp)
	jsr	(___cmpxf2)
	tst.l	d0
	lea	(24,sp),sp
	sne	d0
	moveq	#1,d1
	and.l	d1,d0
	rts

	.end
