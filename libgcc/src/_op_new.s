	.title	libgcc.a(_op_new.o)

* void* __builtin_new (sizet);
*	new演算子によるメモリ確保を行う.

* void* __builtin_new (size_t);
*	new []演算子によるメモリ確保を行う.

* 1997/10/27 立花.
*	_op_vnew.sを統合.
*	高速化.


	.xref	___new_handler
	.xref	_malloc

	.cpu	68000

	.text

new_loop:
	movea.l	(___new_handler),a0
	jsr	(a0)
___builtin_new::
___builtin_vec_new::
	move.l	(4,sp),-(sp)
	bne	@f
	addq.l	#1,(sp)
@@:
	jsr	(_malloc)
	move.l	d0,(sp)+
	beq	new_loop
	rts

	.end
