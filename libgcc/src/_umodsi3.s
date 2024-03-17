	.title	libgcc.a(_umodsi3.o)

* int __umodsi3 (int, int);
*	unsigned int 同士を除算し、余りを unsigned int で返す.

* 1998/10/29 立花.
*	新規作成. USE_FLOAT 定義時のみ FLOAT を呼び出す. 未定義なら空の
*	ファイルとなる.

	.include	fefunc.mac

	.cpu	68000

	.offset	4
si1:	.ds.l	1
si2:	.ds.l	1

	.text

.ifdef	USE_FLOAT
___umodsi3::
	movea.l	(sp)+,a0
	FPACK	__CUMOD
	move.l	(sp),d0
	jmp	(a0)
.endif	/* USE_FLOAT */

	.end
