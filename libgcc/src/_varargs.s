	.title	libgcc.a(_varargs.o)

* void* __builtin_saveregs ();
*	呼び出されることはない筈なのでアボートする.


	.xref	_abort

	.cpu	68000

	.text

___builtin_saveregs::
	jsr	(_abort)

	.end
