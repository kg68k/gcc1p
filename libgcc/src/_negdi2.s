	.title	libgcc.a(_negdi2.o)

* long long int __negdi2 (long long int);
*	long long intを符号反転してlong long intで返す。

	.cpu	68000

	.text

___negdi2::
	movem.l	(4,sp),d0/d1
	neg.l	d0
	negx.l	d1
	rts

	.end
