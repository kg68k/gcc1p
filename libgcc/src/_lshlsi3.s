	.title	libgcc.a(_lshlsi3.o)

* int __ashlsi3 (int, int);
*	int を算術左シフトして int で返す.

* int __lshlsi3 (int, int);
*	int を論理左シフトして int で返す.

* 1998/10/26 立花.
* _ashlsi3.s を統合.

	.cpu	68000

	.text

___ashlsi3::
___lshlsi3::
	move.l	(4,sp),d0
	move.l	(8,sp),d1
	asl.l	d1,d0
	rts

	.end
