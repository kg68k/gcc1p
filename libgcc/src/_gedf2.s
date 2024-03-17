	.title	libgcc.a(_gedf2.o)

* int __gedf2 (double, double);
*	double同士を比較し、より大きい又は等しいか否かの真偽値をintで返す.
*	0なら真、-1なら偽.

* 1997/10/23 立花.
*	高速化.


	.xref	___cmpdf2

	.cpu	68000

	.text

___gedf2::
	movem.l	(4,sp),d0-d1/a0-a1
	movem.l	d0-d1/a0-a1,-(sp)
	jsr	(___cmpdf2)
	tst.l	d0
	lea	(16,sp),sp
	slt	d0		;not ge
	ext	d0
	ext.l	d0
	rts

	.end
