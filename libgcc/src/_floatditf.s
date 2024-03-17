	.title	libgcc.a(_floatditf.o)

* long double __fixtfdi (long long int);
*	long long intをlong doubleに変換して返す.
*	ただし、このルーチンはlong doubleが128ビット長として定義されて
*	いる場合にだけ生成されるので、このファイルはダミーである.

	.cpu	68000

*	.text
*
*___floatditf::
*	rts

	.end
