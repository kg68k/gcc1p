	.title	libgcc.a(_adddf3.o)

* double __adddf3 (double, double);
*	double同士を加算してdoubleで返す.

* 1997/10/23 立花.
*	無駄なrtsを削除.


	.include	fefunc.mac

	.cpu	68000

	.text

___adddf3::
	movea.l	(sp)+,a0
	FPACK	__CDADD
	move.l	(sp),d0
	move.l	(4,sp),d1
	jmp	(a0)

	.end
