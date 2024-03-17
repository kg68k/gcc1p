	.title	libgcc.a(_iordi3.o)

* long long int __iordi3 (long long int, long long int);
*	long long int 同士の論理和。

	.cpu	68000

	.text

___iordi3::
	movem.l	(4,sp),d0/d1/d2/a0
	or.l	d2,d0
	move.l	a0,d2
	or.l	d2,d1
	rts

	.end
