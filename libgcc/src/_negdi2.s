	.title	libgcc.a(_negdi2.o)

* long long int __negdi2 (long long int);
*	long long intを符号反転してlong long intで返す.

* 1997/10/24 立花.
* libgnu-1.50p2 negdi2.sのコードに入れ換えた.

	.cpu	68000

	.text

___negdi2::
	movem.l	(4,sp),d0/d1
	neg.l	d0
	negx.l	d1
	rts

	.end
