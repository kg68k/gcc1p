	.title	libgcc.a(_fixtfdi.o)

* long long int __fixtfdi (long double);
*	long doubleをlong long intに変換して返す。
*	ただし、このルーチンはlong doubleが128ビット長として定義されて
*	いる場合にだけ生成されるので、このファイルはダミーである。

	.cpu	68000

*	.text
*
*___fixtfdi::
*	rts

	.end
