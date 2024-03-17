	.title	libgcc.a(__version.o)

* 1997/10/27 立花.
*	管理のため新規作成. 実行ファイルにはリンクされない.

* 1997/11/11 立花.
*	ファイル名を version.s から __version.s に変更.

* 1998/10/29 立花.
*	タイトルのファイル名が _version.o になっていたのを修正.
*	libgcc ベースの libgnu の作成を考慮してコードを追加.
*	ラベル定義のコメントアウトを外した.
*	日付及び著作者名を追加.

* 1998/11/12 立花.
*	バージョン更新.

* 1998/12/15 立花.
*	patchlevel 5.

* 1999/05/29 立花.
*	patchlevel 6.


	.cpu	68000

	.data

.ifdef	LIBGNU
___libgnu_patchlevel::
	.dc.b	'libgnu based on '
.endif	/* LIBGNU */

___libgcc_patchlevel::
	.dc.b	'libgcc version x.xx patchlevel 6'
	.dc.b	', 1999/05/29 Tachibana Eriko.',0
	.even

	.end
