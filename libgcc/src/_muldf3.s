	.title	libgcc.a(_muldf3.o)

* double __muldf3 (double, double);
*	double同士を乗算して、積をdoubleで返す。

	.include	fefunc.mac

	.cpu	68000

	.text

___muldf3::
	movea.l	(sp)+,a0
	FPACK	__CDMUL
	move.l	(sp),d0
	move.l	(4,sp),d1
	jmp	(a0)

	.end
