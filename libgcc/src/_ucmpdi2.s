	.title	libgcc.a(_ucmpdi2.o)

* int __ucmpdi2 (long long int, long long int);
*	long long int同士を符号なしで比較して、大小関係をintで返す。
*	0ならより小さい、1なら等しい、2ならより大きい。

	.cpu	68000

	.text

___ucmpdi2::
	movem.l	(4,sp),d0/d1/d2/a0
	cmp.l	a0,d1
	bhi	greater
	bcs	lower
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
