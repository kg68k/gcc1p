	.title	libgcc.a(_new_handler.o)

* vfp set_new_handler (vfp);
*	new_handler(new演算子によるメモリ確保に失敗した場合に呼び出される
*	ルーチン)を設定/収得する.

* void __default_new_handler ();
*	標準のエラー処理ルーチン.

* 1997/10/27 立花.
*	disの生成が良くなるようにルーチンの位置を変えた.
*	出力する文字列から'\0'を除いた.
*	省サイズ.


	.xref	_write
	.xref	__exit

	.cpu	68000

	.text

___new_handler::
	.dc.l	___default_new_handler

message:
	.dc.b	"Virtual memory exceeded in `new'",$0a
sizeof_message:	.equ	$-message
	.even

___default_new_handler::
	pea	(sizeof_message).w
	pea	(message,pc)
	pea	(2)
	jsr	(_write)
	pea	(-1)
	jsr	(__exit)

_set_new_handler::
	lea	(___new_handler,pc),a0
	move.l	(a0),d0
	move.l	(4,sp),(a0)
	bne	@f
	lea	(___default_new_handler,pc),a1
	move.l	a1,(a0)
@@:
	rts

	.end
