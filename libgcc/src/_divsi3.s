	.title	libgcc.a(_divsi3.o)

* int __divsi3 (int, int);
*	signed int同士を除算し、商をsigned intで返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
si1:	.ds.l	1
si2:	.ds.l	1

	.text

.ifdef	USE_FLOAT
___divsi3::
	movea.l	(sp)+,a0
	FPACK	__CLDIV
	move.l	(sp),d0
	jmp	(a0)
.endif	/* USE_FLOAT */

	.end
