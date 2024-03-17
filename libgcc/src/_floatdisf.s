	.title	libgcc.a(_floatdisf.o)

* float __floatdidf (long long int);
*	long long int を float に変換して返す。

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
