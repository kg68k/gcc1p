	.title	libgcc.a(_lshrsi3.o)

* int __lshrsi3 (int, int);
*	intを論理右シフトしてintで返す.

* libgnu-1.50pl2 ashrsi3.sと同じ.

	.cpu	68000

	.text

___lshrsi3::
	move.l	(4,sp),d0
	move.l	(8,sp),d1
	lsr.l	d1,d0
	rts

	.end
