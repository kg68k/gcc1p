	.title	libgcc.a(_fixunssfsi.o)

* unsigned int __fixunssfsi (float);
*	floatをunsigned intに変換して返す。

	.cpu	68000

	.text

___fixunssfsi::
	move.l	(4,sp),d0
	ble	return_zero

	swap	d0
	move	d0,d1
	andi	#$ff<<7,d1
	subi	#$7f<<7,d1
	ble	return_zero_one

	andi	#$007f,d0
**	ori	#$0080,d0
	tas	d0
	lsr	#7,d1
	swap	d0		;仮数
	subi	#23,d1		;d0>>=23; d0<<=d1;
	bmi	shift_right

	cmpi	#8,d1
	bhi	return_max
	lsl.l	d1,d0
	rts

shift_right:
	neg	d1
	lsr.l	d1,d0
	rts

return_max:
	moveq	#-1,d0
	rts

return_zero_one:
	beq	return_one
return_zero:
	moveq	#0,d0
	rts
return_one:
	moveq	#1,d0
	rts


	.end
