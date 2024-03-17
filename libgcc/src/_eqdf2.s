	.title	libgcc.a(_eqdf2.o)

* int __eqdf2 (double, double);
*	double同士を比較し、等しいか否かの真偽値をintで返す。
*	0なら真、1なら偽。

	.xref	___cmpdf2

	.cpu	68000

	.text

___eqdf2::
	movem.l	(4,sp),d0-d1/a0-a1
	movem.l	d0-d1/a0-a1,-(sp)
	jsr	(___cmpdf2)
	tst.l	d0
	lea	(16,sp),sp
	sne	d0
	moveq	#1,d1
	and.l	d1,d0
	rts

	.end
