	.title	libgcc.a(_fixunsdfdi.o)

* long long int __fixunsdfdi (double);
*	doubleをlong long intに変換して返す。
*	返値の型はsignedだが、実際にはunsignedを返す機能の関数であり
*	引数が負数の場合は0を返す。

	.cpu	68000

	.text

returnzero:
	moveq	#0,d0
	moveq	#0,d1
return:
	rts

___fixunsdfdi::
	movem.l	(4,sp),d0/d1
	move.l	d0,d2
	bmi	returnzero
	or.l	d1,d2
	beq	return		;d0=d1=0

	swap	d0
	move	d0,d2

	and	#$7ff0,d2
	sub	#$3ff0,d2
	bmi	returnzero

	and	#$000f,d0
	or	#$0010,d0
	swap	d0

	lsr	#4,d2
	sub	#52,d2
	bmi	rightsft
	beq	returnd1d0
	cmp	#11,d2
	bhi	returnmax

	move.l	d3,a0
	move.l	d1,d3
	move	d0,d3
	swap	d3

	lsl.l	d2,d0
	lsl.l	d2,d3
	lsl.l	d2,d1

	swap	d3
	move	d3,d0
	move.l	a0,d3
	bra	returnd1d0

rightsft:
	neg	d2
	cmp	#16,d2
	bhi	rightsft17
	beq	rightsft16

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
	move.l	a0,d3
	bra	returnd1d0

rightsft17:
	cmp	#32,d2
	bhi	rightsft33
	beq	rightsft32

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
	bra	returnd1d0

rightsft33:
	sub	#32,d2
	lsr.l	d2,d0
rightsft32:
	move.l	d0,d1
	moveq	#0,d0

returnd1d0:
	exg.l	d0,d1
	rts

returnmax:
	moveq	#-1,d0
	moveq	#-1,d1
	rts

	.end
