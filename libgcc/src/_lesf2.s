	.title	libgcc.a(_lesf2.o)

* int __lesf2 (float, float);
*	float同士を比較し、より小さい又は等しいか否かの真偽値をintで返す。
*	0なら真、1なら偽。

* int __cmpsf2 (float, float);
*	float同士を比較し、大小関係をintで返す。

	.xref	___cmpsf2

	.cpu	68000

	.offset	4
fval1:	.ds.l	1
fval2:	.ds.l	1

	.text

___lesf2::
	move.l	(fval2+0,sp),-(sp)
	move.l	(fval1+4,sp),-(sp)
	jsr	(___cmpsf2)
	tst.l	d0
	addq.l	#8,sp
	sgt	d0		;not le
	moveq	#1,d1
	and.l	d1,d0
	rts

	.end
