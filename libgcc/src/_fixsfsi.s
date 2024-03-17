	.title	libgcc.a(_fixsfsi.o)

* int __fixsfsi (float);
*	floatをintに変換して返す。

	.include	fefunc.mac

	.cpu	68000

	.offset	4
fval:	.ds.s	1

	.text

___fixsfsi::
	move.l	(fval,sp),d0
	beq	return_d0

.ifdef	USE_FLOAT
	FPACK	__FTOL
return_d0:
	rts
.else
	swap	d0
	move	d0,d1
	andi	#$ff<<7,d1
	subi	#$7f<<7,d1	;指数
	ble	return_zero_one

	move	d0,d2		;符号
	andi	#$007f,d0
**	ori	#$0080,d0
	tas	d0
	lsr	#7,d1
	swap	d0		;仮数
	subi	#23,d1		;d0>>=23; d0<<=d1;
	bmi	shift_right
	beq	check_sign

	cmpi	#7,d1
	bhi	return_max_min
	lsl.l	d1,d0
check_sign:
	tst	d2
	bmi	return_neg_d0
return_d0:
	rts

shift_right:
	neg	d1
	lsr.l	d1,d0
	tst	d2
	bpl	return_d0
return_neg_d0:
	neg.l	d0
	rts

return_zero_one:
	beq	return_one
	moveq	#0,d0
	rts
return_one:
	tst	d0
	bmi	return_minus_one
	moveq	#1,d0
	rts
return_minus_one:
	moveq	#-1,d0
	rts

return_max_min:
	tst	d2
	bpl	return_max
	move.l	#$80000000,d0
	rts
return_max:
	moveq	#-1,d0
	bchg	d0,d0
	rts
.endif	/* !USE_FLOAT */

	.end
