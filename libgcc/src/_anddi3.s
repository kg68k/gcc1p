	.title	libgcc.a(_anddi3.o)

* long long int __anddi3 (long long int, long long int);
*	long long int 同士の論理積。

	.cpu	68000

	.text

___anddi3::
	movem.l	(4,sp),d0/d1/d2/a0
	and.l	d2,d0
	move.l	a0,d2
	and.l	d2,d1
	rts

	.end
