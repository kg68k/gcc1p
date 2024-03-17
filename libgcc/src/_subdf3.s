	.title	libgcc.a(_subdf3.o)

* double __subdf3 (double, double);
*	double同士を減算してdoubleで返す.

* 1997/10/24 立花.
*	無駄なrtsを削除.


	.include	fefunc.mac

	.cpu	68000

	.text

___subdf3::
	movea.l	(sp)+,a0
	FPACK	__CDSUB
	move.l	(sp),d0
	move.l	(4,sp),d1
	jmp	(a0)

	.end
