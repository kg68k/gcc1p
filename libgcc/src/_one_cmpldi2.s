	.title	libgcc.a(_one_cmpldi2.o)

* long long int ___one_cmpldi2 (long long int);
*	long long int のビット否定(1の補数)。

	.cpu	68000

	.text

___one_cmpldi2::
	movem.l	(4,sp),d0/d1
	not.l	d0
	not.l	d1
	rts

	.end
