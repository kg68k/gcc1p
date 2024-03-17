	.title	libgcc.a(_truncxfsf2.o)

* float __truncxfsf2 (long double);
*	long doubleをfloatに変換して返す.

* 1997/10/25 立花.
*	新規作成.

* 1998/10/28 立花.
*	USE_FLOAT 定義時は、double から float への縮小で FLOAT を呼び出
*	すようにした.

	.include	fefunc.mac

	.cpu	68000

	.offset	4
ldval:	.ds.x	1

	.text

___truncxfsf2::
	movem.l	(ldval,sp),d0/d1/d2
	movem.l	d0/d1/d2,-(sp)
	.xref	 ___truncxfdf2
	jsr	(___truncxfdf2)

.ifdef	USE_FLOAT
	lea	(12,sp),sp
	FPACK	__DTOF
.else
	addq.l	#8,sp
	move.l	d1,(sp)
	move.l	d0,-(sp)
	.xref	 ___truncdfsf2
	jsr	(___truncdfsf2)
	addq.l	#8,sp
.endif	/* !USE_FLOAT */

	rts

	.end
