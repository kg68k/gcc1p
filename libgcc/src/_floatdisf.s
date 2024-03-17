	.title	libgcc.a(_floatdisf.o)

* float __floatdidf (long long int);
*	long long int を float に変換して返す.

* 1997/10/25 立花.
*	__floatdidf() と __truncdfsf2() を使用して変換するようにした.

* 1998/10/28 立花.
*	USE_FLOAT 定義時は、double から float への縮小で FLOAT を呼び出
*	すようにした.

* 1999/05/29 立花.
*	引数を float として受け取っていた不具合を修正(thanks to mor).
*	関数呼び出しをレジスタ渡しのインターフェイスに変更した.


	.include	fefunc.mac

	.cpu	68000

	.offset	4
di_l:	.ds.l	1
di_h:	.ds.l	1

	.text

___floatdisf::
	move.l	(di_l,sp),d1
	move.l	(di_h,sp),d0
**	tst.l	d0				;呼び出し直前に <tst.l d0> が必要
	.xref	 ___floatdidf_
	jsr	(___floatdidf_)

.ifdef	USE_FLOAT
	FPACK	__DTOF
	rts
.else
	.xref	 ___truncdfsf2_
	jmp	(___truncdfsf2_)
**	rts
.endif	/* !USE_FLOAT */

	.end
