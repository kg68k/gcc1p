	.title	libgcc.a(_fixxfsi.o)

* int __fixxfsi (long double);
*	long doubleをintに変換して返す.

* 1997/11/11 立花.
*	新規作成.


	.cpu	68000

	.offset	4
ld_h:	.ds	1
	.ds	1
ld_m:	.ds.l	1
ld_l:	.ds.l	1

	.text

___fixxfsi::
	moveq	#0,d0
	move	(ld_h,sp),d1
	beq	return
	move	d1,d2		;符号を保存
	andi	#$7fff,d1
	subi	#$3fff,d1
	bcs	return
	subi	#15,d1
	bls	word_shift
	subi	#16,d1
	bcc	return_over

	neg	d1		;16 <= e <= 30
	move.l	(ld_m,sp),d0
	lsr.l	d1,d0
	tst	d2
	bmi	return_neg
return:
	rts
word_shift:
	neg	d1		;0 <= e <= 15
	move	(ld_m,sp),d0
	lsr	d1,d0
	tst	d2
	bpl	return
return_neg:
	neg.l	d0
	rts

return_over:
	tst	d2
	bmi	return_min
*return_max:
**	move.l	#$7fffffff,d0
	moveq	#-1,d0
	bchg	d0,d0
	rts
return_min:
	move.l	#$80000000,d0
	rts

	.end
