	.title	libgcc.a(_modsi3.o)

* int __modsi3 (int, int);
*	signed int 同士を除算し、余りを signed int で返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
si1:	.ds.l	1
si2:	.ds.l	1

	.text

.ifdef	USE_FLOAT
___modsi3::
	movea.l	(sp)+,a0
	FPACK	__CLMOD
	move.l	(sp),d0
	jmp	(a0)
.endif	/* USE_FLOAT */

	.end
