	.title	libgcc.a(_eqxf2.o)

* int __eqxf2 (long double, long double);
*	long double同士を比較し、等しいか否かの真偽値をintで返す。
*	0なら真、1なら偽。

	.xref	___cmpxf2

	.cpu	68000

	.text

___eqxf2::
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
