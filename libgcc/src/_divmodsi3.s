	.title	libgcc.a(_divmodsi3.o)

* int __divsi3 (int, int);
*	signed int 同士を除算し、商を signed int で返す.

* int __udivsi3 (int, int);
*	unsigned int 同士を除算し、商を unsigned int で返す.

* int __modsi3 (int, int);
*	signed int 同士を除算し、余りを signed int で返す.

* int __umodsi3 (int, int);
*	unsigned int 同士を除算し、余りを unsigned int で返す.

* 1997/10/24 立花.
*	_divsi3.s と _modsi3.s を統合し、libgnu-1.50p2 divsi3.s/modsi3.s
*	のコードに入れ換えた. 表に(d8,pc,ix)で届くように細切れにして
*	しまった.

* 1998/10/29 立花.
*	USE_FLOAT 定義時は各関数を別ファイルに分割するようにした. その場
*	合は空ファイルとなる.

	.cpu	68000

	.text

.ifndef	USE_FLOAT

*** 符号付き除算 ***

___divsi3::
	move.l	(4,sp),d1
	move.l	d1,d0
	swap	d0
	or	(8,sp),d0
	bne	divsi

	divu	(10,sp),d1
	moveq	#0,d0
	move	d1,d0
	rts
divsi:
	move.l	d1,d0
	bpl	divpn
divmn:
	neg.l	d0
	move.l	(8,sp),d1
	beq	divsi3_divbyzero
	bpl	divmp
divmm:
	neg.l	d1
	bra	udivsi
divmp:
	bsr	udivsi
	neg.l	d0
	rts
divpn:
	move.l	(8,sp),d1
	beq	divsi3_divbyzero
	bpl	udivsi
divpm:
	neg.l	d1
	bsr	udivsi
	neg.l	d0
	rts

*** 符号なし除算 ***

udivw:
	move.l	d0,d2
	clr	d2
	swap	d2
divsi3_divbyzero:
	divu	d1,d2
	move.l	d2,a0
	move	d0,d2
	divu	d1,d2
	move	a0,d0
	swap	d0
	move	d2,d0
	rts

___udivsi3::
	move.l	(4,sp),d1
	move.l	d1,d0
	swap	d0
	or	(8,sp),d0
	bne	divusi

	divu	(10,sp),d1
	moveq	#0,d0
	move	d1,d0
	rts

return_one:
	moveq	#1,d0
	rts
divusi:
	move.l	d1,d0
	move.l	(8,sp),d1
	beq	udivsi3_divbyzero
udivsi:
	cmp.l	d0,d1
	beq	return_one
	bhi	return_zero

	cmp.l	#$0001_0000,d1
	bcs	udivw

	move	d0,d2
	or	d1,d2
	bne	udivl

	swap	d0
	swap	d1
udivsi3_divbyzero:
	divu	d1,d0
	and.l	#$0000ffff,d0
	rts


*** 符号付き剰余 ***

___modsi3::
	move.l	(8,sp),d1
	beq	modsi3_divbyzero
	move.l	(4,sp),d0

	move	d1,a0
	cmp.l	d1,a0
	bne	modl

	move	d0,a0
	cmp.l	d0,a0
	bne	modl
modsi3_divbyzero:
	divs	d1,d0
	swap	d0
	ext.l	d0
	rts

modl:
	tst.l	d1
	bmi	modm
	tst.l	d0
	bpl	umod
modmp:
	neg.l	d0
	bsr	umod
	neg.l	d0
	rts
modm:
	tst.l	d0
	bmi	modmm
	neg.l	d1
	bra	umod
modmm:
	neg.l	d0
	neg.l	d1
	bsr	umod
	neg.l	d0
	rts


*** 符号なし剰余 ***

umodw:
	move.l	d0,d2
	swap	d2
	cmp	d1,d2
	bcs	umodww

	move.l	d0,d2
	clr	d0
	swap	d0
	divu	d1,d0
	move	d2,d0
umodww:
	divu	d1,d0
	clr	d0
	swap	d0
	rts

umodss:
	swap	d0
	swap	d1
umodsi3_divbyzero:
	divu	d1,d0
	clr	d0
	rts

return_zero:
	moveq	#0,d0
return_d0:
	rts

___umodsi3::
	move.l	(8,sp),d1
	beq	umodsi3_divbyzero
	move.l	(4,sp),d0
umod:
	cmp.l	d0,d1
	beq	return_zero
	bhi	return_d0

	cmp.l	#$0001_0000,d1
	bcs	umodw

	move	d0,d2
	or	d1,d2
	beq	umodss

	move.l	d1,a2
	move.l	d1,d2
	move.l	d0,a1
	swap	d2
	cmp	#$0100,d2
	bcc	msft16

	move.b	(sfttbl,pc,d2.w),d2
	bra	@f
msft16:
	lsr	#8,d2
	move.b	(sfttbl,pc,d2.w),d2
	addq	#8,d2
@@:
	lsr.l	d2,d1
	lsr.l	d2,d0
	divu	d1,d0
	move	d0,d2

	move.l	a2,d1
	mulu	d1,d2
	swap	d1
	mulu	d0,d1
	swap	d1
	clr	d1
	add.l	d1,d2
	move.l	a1,d0
	sub.l	d2,d0
	bpl	@f
	add.l	a2,d0
@@:
	rts


*** 符号なし除算その二 ***

udivl:
	move.l	d1,a2
	move.l	d1,d2
	move.l	d0,a1
	swap	d2
	cmp.l	#$0100,d2
	bcc	dsft16

	move.b	(sfttbl,pc,d2.w),d2
	bra	@f
dsft16:
	lsr	#8,d2
	move.b	(sfttbl,pc,d2.w),d2
	addq	#8,d2
@@:
	lsr.l	d2,d1
	lsr.l	d2,d0
	divu	d1,d0
	and.l	#$0000ffff,d0
	move.l	d0,d2

	move.l	a2,d1
	mulu	d1,d2
	swap	d1
	mulu	d0,d1
	swap	d1
	clr	d1
	add.l	d1,d2
	cmp.l	a1,d2
	bls	@f
	subq.l	#1,d0
@@:
	rts


*** 共通データ ***

sfttbl:
	.dc.b	0,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
	.dc.b	6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
	.dc.b	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	.dc.b	7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
	.dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	.dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	.dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	.dc.b	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8

.endif	/* !USE_FLOAT */

	.end
