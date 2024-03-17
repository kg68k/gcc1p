	.title	libgcc.a(_fixdfdi.o)

* long long int __fixdfdi (double);
*	doubleをlong long intに変換して返す.

* 1997/10/24 立花.
*	libgnu-1.50p2 fixdfdi.sのコードに入れ換えた.
*	省サイズ、高速化. 一部のルーチンの移動.

	.cpu	68000

	.text

returnover:
	move.l	a2,d0
	bpl	returnmax
*returnmin:
	moveq	#1,d1
	moveq	#0,d0
**	move.l	#$80000000,d1
	ror.l	d1,d1
	rts
returnmax:
	moveq	#-1,d1
	moveq	#-1,d0
**	move.l	#$7fffffff,d1
	bchg	d1,d1
	rts

returnzero:
	moveq	#0,d0
	moveq	#0,d1
return:
	rts

___fixdfdi::
	movem.l	(4,sp),d0/d1
	move.l	d0,d2
	or.l	d1,d2
	beq	return		;d0=d1=0

	swap	d0
	move	d0,d2
	and	#$7ff0,d2
	sub	#$3ff0,d2
	bmi	returnzero

	move	d0,a2
	and	#$000f,d0
	or	#$0010,d0
	swap	d0

	lsr	#4,d2
	sub	#52,d2
	bmi	rightsft
	beq	checksignflag
	cmp	#10,d2
	bhi	returnover

	move.l	d3,a0
	move.l	d1,d3
	move	d0,d3
	swap	d3
	lsl.l	d2,d0
	lsl.l	d2,d3
	lsl.l	d2,d1
	swap	d3
	move	d3,d0
	bra	checksignflag_r

rightsft:
	neg	d2
	cmp	#16,d2
	beq	rightsft16
	bhi	rightsft17

	move.l	d3,a0
	move.l	d1,d3
	move	d0,d3
	swap	d3
	lsr.l	d2,d0
	lsr.l	d2,d3
	lsr.l	d2,d1
	swap	d1
	move	d3,d1
	swap	d1

checksignflag_r:
	move.l	a0,d3
checksignflag:
	move	a2,d2
	bpl	returnd1d0
	neg.l	d1
	negx.l	d0
returnd1d0:
	exg.l	d0,d1
	rts

rightsft17:
	cmp	#32,d2
	beq	rightsft32
	bhi	rightsft33

	move	d0,d1
	swap	d1
	sub	#16,d2
	lsr.l	d2,d0
	lsr.l	d2,d1
	swap	d1
rightsft16:
	move	d0,d1
	swap	d1
	clr	d0
	swap	d0
	bra	checksignflag

rightsft32:
	move.l	d0,d1
	moveq	#0,d0
	bra	checksignflag

rightsft33:
	move.l	d0,d1
	sub	#32,d2
	moveq	#0,d0
	lsr.l	d2,d1
	bra	checksignflag

	.end
