	.title	libgcc.a(_op_delete.o)

* void __builtin_delete (void*);
*	delete演算子によるメモリの解放を行う.
*	(newで確保したメモリを解放する)

* void __builtin_vec_deleve (void*);
*	delete []演算子によるメモリの解放を行う.
*	(new []で確保したメモリを解放する)

* 1997/10/24 立花.
*	_op_vdel.sを統合.
*	一般にメモリを確保していない時にdeleteする事は少ないので、
*	free(NULL)が何もせずに戻るのを利用しここでのチェックを省いた.


	.xref	_free

	.cpu	68000

	.text

___builtin_delete::
___builtin_vec_delete::
	jmp	(_free)

	.end
