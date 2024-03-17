	.title	libgcc.a(_pure.o)

* void __pure_virtual (void);
*	純粋仮想関数が呼び出された場合のエラー処理?

	.xref	_write
	.xref	__exit

	.cpu	68000

	.text

message:
	.dc.b	'pure virtual method called',$0a
sizeof_message:	.equ	$-message
	.even

___pure_virtual::
	pea	(sizeof_message).w
	pea	(message,pc)
	pea	(2)
	jsr	(_write)
	pea	(-1)
	jsr	(__exit)

	.end
