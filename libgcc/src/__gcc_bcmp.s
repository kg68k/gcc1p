	.title	libgcc.a(__gcc_bcmp.o)

* int __gcc_bcmp (unsigned char*, unsigned char*, size_t);
*	二つの領域の内容を比較し、大小関係をintで返す。

	.cpu	68000

	.text

___gcc_bcmp::
	movem.l	(4,sp),a0/a1/a2
	move.l	a2,d1
	ble	end
	subq.l	#1,d1
cmp_loop:
	cmp.b	(a0)+,(a1)+
	dbne	d1,cmp_loop
	bne	differ
	clr	d1
	subq.l	#1,d1
	bcc	cmp_loop
end:
	moveq	#0,d0
	rts
differ:
	move.b	-(a1),d0
	sub.b	-(a0),d0
	ext	d0
	ext.l	d0
	rts

	.end
