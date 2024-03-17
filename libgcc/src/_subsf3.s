	.title	libgcc.a(_addsf3.o)

* float __subsf3 (float, float);
*	float 同士を減算して float で返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
fval1:	.ds.l	1
fval2:	.ds.l	1

	.text

.ifdef	USE_FLOAT
___subsf3::
	movea.l	(sp)+,a0
	FPACK	__CFSUB
	move.l	(sp),d0
	jmp	(a0)
.endif	/* USE_FLOAT */

	.end
