	.title	libgcc.a(_truncdfsf2.o)

* float _truncdfsf2 (double);
*	double を float に変換して返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
dval:	.ds.d	1

	.text

.ifdef	USE_FLOAT
___truncdfsf2::
	movea.l	(sp)+,a0
	FPACK	__CDTOF
	move.l	(sp),d0
	jmp	(a0)

.else
___truncdfsf2::
	movem.l	(4,sp),d0-d1
___truncdfsf2_::
	swap	d0
	move	d0,d2
	and	#$7ff0,d2
	sub	#$3800,d2
	bls	returnszero
	cmp	#$ff0,d2
	bcc	returninfornan
	move	d0,d1
	and	#$8000,d1
	and	#$f,d0
	or	d2,d0
	rol.l	#3,d0
	or	d1,d0
	swap	d0
	clr	d1
	rol.l	#3,d1
	or	d1,d0
	rts

returnszero:
	swap	d0
	and.l	#$80000000,d0
	rts

returninfornan:
	cmp	#$47f0,d2
	bne	returninf
	move.l	d0,d2
	and.l	#$ffff000f,d2
	or.l	d1,d2
	bne	returnnan
returninf:
**	and	#$8000,d0
	clr.b	d0		;↓より、bit 14-7のクリアは不要
	or	#$7f80,d0	;%s111_1111_1000_000
	swap	d0
	clr	d0
	rts

returnnan:
	swap	d0
	or.l	#$7fffffff,d0
	rts
.endif	/* !USE_FLOAT */

	.end
