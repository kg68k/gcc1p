	.title	libgcc.a(_gexf2.o)

* int __gexf2 (long double, long double);
*	long double同士を比較し、より大きい又は等しいか否かの真偽値をintで返す.
*	0なら真、-1なら偽.

* 1997/11/11 立花.
*	新規作成.


	.xref	___cmpxf2

	.cpu	68000

	.text

___gexf2::
	movem.l	(4,sp),d0-d2/a0-a2
	movem.l	d0-d2/a0-a2,-(sp)
	jsr	(___cmpxf2)
	tst.l	d0
	lea	(24,sp),sp
	slt	d0		;not ge
	ext	d0
	ext.l	d0
	rts

	.end
