	.title	libgcc.a(_xordi3.o)

* long long int __xordi3 (long long int, long long int);
*	long long int 同士の排他的論理和。

	.cpu	68000

	.text

___xordi3::
	movem.l	(4,sp),d0/d1/d2/a0
	eor.l	d2,d0
	move.l	a0,d2
	eor.l	d2,d1
	rts

	.end
