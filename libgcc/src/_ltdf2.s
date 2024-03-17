	.title	libgcc.a(_ltdf2.o)

* int __ltdf2 (double, double);
*	double同士を比較し、より小さい又は等しいか否かの真偽値をintで返す。
*	-1なら真、0なら偽。

	.xref	___cmpdf2

	.cpu	68000

	.text

___ltdf2::
	movem.l	(4,sp),d0-d1/a0-a1
	movem.l	d0-d1/a0-a1,-(sp)
	jsr	(___cmpdf2)
	tst.l	d0
	lea	(16,sp),sp
	slt	d0
	ext	d0
	ext.l	d0
	rts

	.end
