	.title	libgcc.a(_ashrsi3.o)

* int __ashrsi3 (int, int);
*	intを算術右シフトしてintで返す。

	.cpu	68000

	.text

___ashrsi3::
	move.l	(4,sp),d0
	move.l	(8,sp),d1
	asr.l	d1,d0
	rts

	.end
