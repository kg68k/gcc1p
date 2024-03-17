	.title	libgcc.a(_extendsfxf2.o)

* long double __extendsfxf2 (float);
*	floatをlong doubleに変換して返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
fval:	.ds.l	1

	.text

___extendsfxf2::

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

	.xref	 ___extenddfxf2
	jsr	(___extenddfxf2)
	addq.l	#8,sp
	rts

	.end
