	.title	libgcc.a(_eprintf.o)

* void __eprintf (const char*, const char*, int, const char*);
*	`assert'マクロで使用される.

* 1997/10/24 立花.
*	省サイズ、高速化.


	.xref	__iob
	.xref	_fprintf,_fflush
	.xref	_abort

	.cpu	68000

	.text

___eprintf::
	lea	(__iob+36*2),a3	;stderr
	move.l	a3,(sp)
	jsr	(_fprintf)
	move.l	a3,(sp)
	jsr	(_fflush)
	jsr	(_abort)

	.end
