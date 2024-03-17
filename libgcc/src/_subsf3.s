	.title	libgcc.a(_addsf3.o)

* float __subsf3 (float, float);
*	float 同士を減算して float で返す.

* 1998/10/29 立花.
*	新規作成. USE_FLOAT 定義時のみ FLOAT を呼び出す. 未定義なら空の
*	ファイルとなる.
*	libgnu versin 1.46 fpack.lzh::_subsf3.s と同じ.

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
