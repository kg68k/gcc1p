	.title	libgcc.a(_pure.o)

* void __pure_virtual (void);
*	純粋仮想関数が呼び出された場合のエラー処理?
*	(そのようなオブジェクトは定義できない筈だが...)

* 1997/10/24 立花.
*	文字列末尾の無駄な'\0'を削除.


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
