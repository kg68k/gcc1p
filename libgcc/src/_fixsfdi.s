	.title	libgcc.a(_fixsfdi.o)

* long long int __fixdfdi (float);
*	float を long long int に変換して返す.

* 1997/10/25 立花.
*	__extendsfdf2() と __fixdfdi() を使用して変換するようにした.

* 1998/10/28 立花.
*	USE_FLOAT 定義時は、float から double への拡張で FLOAT を呼び出
*	すようにした.

	.include	fefunc.mac

	.cpu	68000

	.offset	4
fval:	.ds.l	1

	.text

___fixsfdi::

.ifdef	USE_FLOAT
	move.l	(fval,sp),d0
	FPACK	__FTOD
	move.l	d1,-(sp)
	move.l	d0,-(sp)
.else
	move.l	(fval,sp),-(sp)
	.xref	 ___extendsfdf2
	jsr	(___extendsfdf2)
	move.l	d1,(sp)
	move.l	d0,-(sp)
.endif	/* !USE_FLOAT */

	.xref	 ___fixdfdi
	jsr	(___fixdfdi)
	addq.l	#8,sp
	rts

	.end
