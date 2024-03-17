	.title	libgcc.a(_fixunsdfsi.o)

* unsigned int __fixunsdfsi (double);
*	doubleをunsigned intに変換して返す.

* 1997/10/25 立花.
*	libgnu-1.50p2 fxunsdfsi.sのコードに入れ換えた.
*	一部のルーチンの移動. 高速化. rtsへのbraをrtsに置換.

	.cpu	68000

	.text

returnzero:
	moveq	#0,d0
return:
	rts

___fixunsdfsi::
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
	sub	#20,d2
	bmi	rightsft
	beq	returnd0
	cmp	#11,d2
	bhi	returnmax

	move	d0,d1
	swap	d1
	lsl.l	d2,d0
	lsl.l	d2,d1
	swap	d1
	move	d1,d0
returnd0:
	rts

rightsft:
	neg	d2
	lsr.l	d2,d0
	rts

returnmax:
	moveq	#-1,d0
	rts

	.end
