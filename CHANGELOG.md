# patchlevel 6 (2024-03-17)

* 環境変数`GCC_LIB`、`GCC_NO_XCLIB`、`GCC_XCLIB`を削除しました。
  ライブラリファイルのファイル名形式は常に`lib*.a`となります。
* 環境変数`GCC_OPTION0`の`A`、`B`を常に有効にしました。
* 環境変数`GCC_OPTION1`の`O`、`+`を常に有効にしました。
* 環境変数`GCC_AS`の既定値を`has060`に変更しました。
  * アセンブラ実行時の引数の`-e`を`-1`に変更しました。
    そのため、`-1`に対応していないアセンブラは指定できません。
