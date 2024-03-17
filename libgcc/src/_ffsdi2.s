	.title	libgcc.a(_ffsdi2.o)

* long long int __ffsdi2 (long long int);
*	long long int中で最下位ビットから何番目に始めて'1'のビットが
*	表われるかをlong long intで返す('1'のビットがなければ0を返す)。
*	標準関数ffs()のlong long版。

	.cpu	68000

	.offset	4
lvall:	.ds.l	1
lvalh:	.ds.l	1

	.text

___ffsdi2::
	move.l	(lvall,sp),d0
	bne	ffs_sub
	move.l	(lvalh,sp),d0
	beq	return_d0
	bsr	ffs_sub
**	addi.l	#32,d0
	addi	#32,d0
return_d0:
	rts

ffs_sub:
	moveq	#32-1,d1
loop:
	lsr.l	#1,d0
	dbcs	d1,loop
	moveq	#32,d0
	sub	d1,d0
	rts

	.end
