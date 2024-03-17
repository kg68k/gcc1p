	.title	libgcc.a(_subdi3.o)

* long long int __subdi3 (long long int, long long int);
*	long long int 同士の減算。

	.cpu	68000

	.text

___subdi3::
	movem.l	(4,sp),d0/d1/d2/a0
	exg.l	d2,a0
	sub.l	a0,d0
	subx.l	d2,d1
	rts

	.end
