	.title	libgcc.a(_cmpdi2.o)

* int __cmpdi2 (long long int, long long int);
*	long long int同士を比較し、大小関係をintで返す。
*	0ならより小さい、1なら等しい、2ならより大きい。

* 1997/10/24 立花.
*	libgnu-1.50p2 cmpdi2.sのコードに入れ換えた。

	.cpu	68000

	.text

___cmpdi2::
	movem.l	(4,sp),d0/d1/d2/a0
	cmp.l	a0,d1
	bgt	greater
	blt	lower
	cmp.l	d2,d0
	bhi	greater
	bcs	lower
	moveq	#1,d0
	rts
greater:
	moveq	#2,d0
	rts
lower:
	moveq	#0,d0
	rts

	.end
