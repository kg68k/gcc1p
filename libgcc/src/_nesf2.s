	.title	libgcc.a(_eqdf2.o)

* int __eqdf2 (float, float);
*	float同士を比較し、等しくないか否かの真偽値をintで返す.

* 1997/10/24 立花.
*	高速化.

* 1997/11/12 立花.
*	ショートアドレッシングの修正.


	.xref	___cmpsf2

	.cpu	68000

	.offset	4
fval1:	.ds.l	1
fval2:	.ds.l	1

	.text

___nesf2::
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
