	.title	libgcc.a(_udivsi3.o)

* int __udivsi3 (int, int);
*	unsigned int 同士を除算し、商を unsigned int で返す.

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
___udivsi3::
	movea.l	(sp)+,a0
	FPACK	__CUDIV
	move.l	(sp),d0
	jmp	(a0)
.endif	/* USE_FLOAT */

	.end
