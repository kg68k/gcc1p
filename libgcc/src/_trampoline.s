	.title	libgcc.a(_trampoline.o)

* void __transfer_from_trampoline ();
*	ライブラリで使用?

	.cpu	68000

	.text

___transfer_from_trampoline::
___trampoline::
	move.l	(22,a0),(sp)
	lea	(18,a0),a0
	movea.l	(a0),a0
	rts

	.end
