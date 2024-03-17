	.title	libgcc.a(_gtsf2.o)

* int __gesf2 (float, float);
*	float同士を比較し、より大きいか否かの真偽値をintで返す.

* 1997/10/23 立花.
*	高速化.

* 1997/11/12 立花.
*	ショートアドレッシングの修正.


	.xref	___cmpsf2

	.cpu	68000

	.offset	4
fval1:	.ds.l	1
fval2:	.ds.l	1

	.text

___gtsf2::
	move.l	(fval2+0,sp),-(sp)
	move.l	(fval1+4,sp),-(sp)
	jsr	(___cmpsf2)
	tst.l	d0
	addq.l	#8,sp
	sgt	d0
	moveq	#1,d1
	and.l	d1,d0
	rts

	.end
