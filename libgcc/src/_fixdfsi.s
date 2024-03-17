	.title	libgcc.a(_fixdfsi.o)

* int __fixdfsi (double);
*	doubleをintに変換して返す.

* 1997/10/27 立花.
*	高速化.

* 1998/10/28 立花.
*	USE_FLOAT 定義時は FLOAT を呼び出すようにした.

	.include	fefunc.mac

	.cpu	68000

	.offset	4
dval:	.ds.d	1

	.text

.ifdef	USE_FLOAT
___fixdfsi::
	movea.l	(sp)+,a0
	FPACK	__CDTOL
	move.l	(sp),d0
	jmp	(a0)

.else
___fixdfsi::
	movem.l	(dval,sp),d0-d1
	move.l	d0,d2
	or.l	d1,d2
	beq	returnd0	;d0=d1=0
	swap	d0
	move	d0,d2
	and	#$7ff0,d2
	sub	#$3ff0,d2
	bmi	returnzero
	movea	d0,a2
	and	#$f,d0
	or	#$10,d0
	lsr	#4,d2
	swap	d0
	sub	#20,d2
	bmi	rightsft
	beq	checksignflag
	cmp	#10,d2
	bhi	returnover
	move	d0,d1
	swap	d1
	lsl.l	d2,d0
	lsl.l	d2,d1
	swap	d1
	move	d1,d0
	bra	checksignflag

rightsft:
	neg	d2
	lsr.l	d2,d0
checksignflag:
	move	a2,d2
	bpl	returnd0
	neg.l	d0
returnd0:
	rts

returnzero:
	moveq	#0,d0
	rts

returnover:
	move	a2,d0
	bpl	returnmax
	move.l	#$80000000,d0
	rts
returnmax:
**	move.l	#$7fffffff,d0
	moveq	#-1,d0
	bchg	d0,d0
	rts
.endif	/* !USE_FLOAT */

	.end
