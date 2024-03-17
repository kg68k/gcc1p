	.title	libgcc.a(_adddi3.o)

* long long int __adddi3 (long long int, long long int);
*	long long int 同士の加算。

	.cpu	68000

	.text

___adddi3::
	movem.l	(4,sp),d0/d1/d2/a0
	exg.l	d2,a0
	add.l	a0,d0
	addx.l	d2,d1
	rts

	.end
