	.title	libgcc.a(_divdf3.o)

* double __divdf3 (double, double);
*	double同士を除算して、商をdoubleで返す.

* 1997/10/23 立花.
*	無駄なrtsを削除.


	.include	fefunc.mac

	.cpu	68000

	.text

___divdf3::
	movea.l	(sp)+,a0
	FPACK	__CDDIV
	move.l	(sp),d0
	move.l	(4,sp),d1
	jmp	(a0)

	.end
