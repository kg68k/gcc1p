	.title	libgcc.a(_gexf2.o)

* int __lexf2 (long double, long double);
*	long double同士を比較し、より小さい又は等しいか否かの真偽値をintで返す.
*	0なら真、1なら偽.

* 1997/11/11 立花.
*	新規作成.


	.xref	___cmpxf2

	.cpu	68000

	.text

___lexf2::
	movem.l	(4,sp),d0-d2/a0-a2
	movem.l	d0-d2/a0-a2,-(sp)
	jsr	(___cmpxf2)
	tst.l	d0
	lea	(24,sp),sp
	sgt	d0		;not le
	moveq	#1,d1
	and.l	d1,d0
	rts

	.end
