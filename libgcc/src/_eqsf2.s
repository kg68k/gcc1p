	.title	libgcc.a(_eqsf2.o)

* int __eqsf2 (float, float);
*	float同士を比較し、等しいか否かの真偽値をintで返す。
*	0なら真、1なら偽。

	.xref	___cmpsf2

	.cpu	68000

	.offset	4
fval1:	.ds.l	1
fval2:	.ds.l	1

	.text

___eqsf2::
	move.l	(fval2+0,sp),-(sp)
	move.l	(fval1+4,sp),-(sp)
	jsr	(___cmpsf2)
	tst.l	d0
	addq.l	#8,sp
	sne	d0
	moveq	#1,d1
	and.l	d1,d0
	rts

	.end
