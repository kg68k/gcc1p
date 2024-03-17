	.title	libgcc.a(_extendsfdf2.o)

* double __extendsfdf2 (float);
*	float を double に変換して返す.

* 1997/10/26 立花.
*	libgnu-1.50p2 extendsfdf2.s のコードに入れ換えた.
*	-0.0(及び負の非正規化数)は符号を保存して -0.0 に変換するようにし
*	た.

* 1998/10/28 立花.
*	USE_FLOAT 定義時は FLOAT を呼び出すようにした.

	.include	fefunc.mac

	.cpu	68000

	.offset	4
fval:	.ds.s	1

	.text

.ifdef	USE_FLOAT
___extendsfdf2::
	move.l	(fval,sp),d0
	FPACK	__FTOD
	rts

.else
___extendsfdf2::
	move.l	(4,sp),d0
	move.l	d0,d1
	beq	return
	swap	d1
	and	#$7f80,d1
	beq	returnzero
	cmp	#$7f80,d1
	beq	returnnaninf

	moveq	#%111,d1
	and	d0,d1
	asr.l	#3,d0
	ror.l	#3,d1
	swap	d0
	and	#$8fff,d0
	add	#$3800,d0
	swap	d0
return:
	rts

returnzero:
**	moveq	#0,d0
	and.l	#$80000000,d0
	moveq	#0,d1
	rts

returnnaninf:
	move.l	d0,d1
	and.l	#$007fffff,d1
	bne	returnnan
*returninf:
	or.l	#$7ff00000,d0
**	moveq	#0,d1
	rts
returnnan:
	or.l	#$7fffffff,d0
	moveq	#-1,d1
	rts
.endif	/* !USE_FLOAT */

	.end
