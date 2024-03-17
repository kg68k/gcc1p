	.title	libgcc.a(_clear_cache.o)

* void __clear_cache (char*, char*);
* 命令キャッシュの一部を消去する.

* ダミールーチンである.

	.cpu	68000

	.text

___clear_cache::
	rts

	.end
