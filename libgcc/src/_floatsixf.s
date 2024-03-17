	.title	libgcc.a(_floatsixf.o)

* long double __floatsixf (int);
*	intをlong doubleに変換して返す.

* 1997/11/11 立花.
*	新規作成.


	.cpu	68000

	.text

___floatsixf::
	moveq	#0,d0
	moveq	#0,d2
	move.l	(4,sp),d1
	beq	return		;d0=d1=d2=0
	bpl	@f
	neg.l	d1
	moveq	#1,d0
@@:
	ror	#1,d0		;符号
	ori	#$3fff+31,d0

	tst.l	d1
	bra	@f
msb_loop:
	add.l	d1,d1		;最上位ビットを'1'にする
@@:	dbmi	d0,msb_loop

	swap	d0
return:
	rts

	.end
