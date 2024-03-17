	.title	libgcc.a(_gtxf2.o)

* int __gexf2 (long double, long double);
*	long double同士を比較し、より大きいか否かの真偽値をintで返す。

	.xref	___cmpxf2

	.cpu	68000

	.text

___gtxf2::
	movem.l	(4,sp),d0-d2/a0-a2
	movem.l	d0-d2/a0-a2,-(sp)
	jsr	(___cmpxf2)
	tst.l	d0
	lea	(24,sp),sp
	sgt	d0
	moveq	#1,d1
	and.l	d1,d0
	rts

	.end
