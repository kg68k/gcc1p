# libgcc for gcc1p
gcc2のlibgcc.aをGCC(真里子版)で使用できるように調整したライブラリです。

gcc2での使用については、`main()`関数の冒頭に`__main()`関数の呼び出しコードを追加しない
バージョンであれば使用できます。  
※gcc version 2.6.3 (68k, Human68k, Lv.3 Exp.16)などは追加するので、パッチが必要です。

無保証につき各自の責任で使用して下さい。


## Build
PCやネット上での取り扱いを用意にするために、src/内のファイルはUTF-8で記述されています。
X68000上でビルドする際には、UTF-8からShift_JISへの変換が必要です。

### u8tosjを使用する方法

あらかじめ、[u8tosj](https://github.com/kg68k/u8tosj)をビルドしてインストールしておいてください。

トップディレクトリで`make`を実行してください。以下の処理が行われます。
1. build/ディレクトリの作成。
2. src/内の各ファイルをShift_JISに変換してbuild/へ保存。

次に、カレントディレクトリをbuild/に変更し、`make`を実行してください。

ライブラリファイルが`libgcc.a`というファイル名で作成されるので、
`libgnu.a`にリネームしてください。

### u8tosjを使用しない方法

ファイルを適当なツールで適宜Shift_JISに変換してから`make`を実行してください。
UTF-8のままでは正しくビルドできませんので注意してください。


## License

ライセンスはオリジナルのlibgccの通り、GNU GENERAL PUBLIC LICENSEバージョン2
またはそれ以降のバージョンでで、ランタイムライブラリ例外が適用されます。

>As a special exception, if you link this library with other files,  
>some of which are compiled with GCC, to produce an executable,  
>this library does not by itself cause the resulting executable  
>to be covered by the GNU General Public License.  
>This exception does not however invalidate any other reasons why  
>the executable file might be covered by the GNU General Public License.  


## Author
TcbnErik / 立花@桑島技研  
https://github.com/kg68k/gcc1p/libgcc
