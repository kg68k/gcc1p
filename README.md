# GCC(真里子版)の改造版
gcc version 1.30 Tool#2(X680x0)の改造版です。

無保証につき各自の責任で使用して下さい。


## 必要ファイル

* ファイル「***doscall.equ***」が必要です。インクルードディレクトリに置いてください。
  * ライブラリとしてLIBCを使う場合は、LIBCに同梱されてるので特別な作業は必要ありません。


## 仕様

### 追加された機能
* -Oオプションに0～2のレベルを指定できます。
  * -O0 ... 最適化を抑止します。
  * -O  ... 通常の最適化を行います。互換性のため、環境変数`GCC_OPTION1`で指定した最適化は変化しません。
  * -O1 ... -Oと同じ。ただし`GCC_OPTION1`で指定した最適化は無効になります。
  * -O2 ... -Oに加え、-fstrength-reduce -fomit-frame-pointer -finline-functions -fforce-mem
            が指定されます。また`GCC_OPTION1=P`の最適化(pea 0.w → clr.l -(sp))が有効になります。

### 削除された機能

* GVRAM、TVRAMの使用。
* インダイレクトファイル。
* ワイルドカード展開。


### 各種ファイル名

* 既定のアセンブラ: has060
* 既定のリンカー: hlk
* エラーログ: gcc.err
* ライブラリ: lib\*.a


### 環境変数(Human68k共通)

* `TEMP`、`temp` ... テンポラリファイルを作成するディレクトリ。
* `include` ... インクルードファイルの置かれているディレクトリ。

`include`、`lib`に複数のディレクトリを記述することはできません。


### 環境変数(オリジナルGCC)

* `GCC_EXEC_PREFIX` ... コンパイラ実行ファイルの接頭語。
* `SUNPRO_DEPENDENCIES` ... ファイル依存関係を出力するファイル名(`-M`オプション)。
* `DEPENDENCIES_OUTPUT` ... ファイル依存関係を出力するファイル名(`-MM`オプション)。


### 環境変数(X680x0版固有)

* `GCC_OPTION0` ... X680x0版GCCの拡張を許可します。
  真里子版GCCの`真里子`、`MARIKO`からリネームされました。
  * `C`: ソースコードデバッガ対応(-gオプション)
  * `D`: 疑似統合環境(エラーのみ)
  * `E`: 疑似統合環境(ワーニング含む)
  * `F`: コンパイル過程の表示
  * 真里子版GCCにおける`A`、`B`は常に有効になっています。
    * `A`: 2進数表記。割り込み処理関数。日本語識別子。
      `__asm("extern reg")`。`B_SUPER()`、`SUPER()`の特別扱い。
    * `B`: `__asm("frame reg")`

* `GCC_OPTION1` ... オプションスイッチの指定。
  真里子版GCCの`GCC_OPTION`からリネームされました。
  * `A`: -fforce-addr
  * `E`: エラータグをED.X形式にする
  * `F`: -fomit-frame-pointer
  * `I`: -finline-functions
  * `L`: -fstrength-reduce
  * `M`: -fforce-mem
  * `P`: pea 0.w → clr.l -(sp)
  * `S`: -fstack_check
  * `W`: -Wall
  * `@`: エラーメッセージを標準出力に出力する(既定では標準エラー出力)
  * 真里子版GCCで指定できる`G`、`T`は使用できません。
  * 真里子版GCCにおける`O`、`+`は常に有効になっています。
    * `O`: X680x0専用の最適化を行う
    * `+`: C++コメント`//`を認識する

* `GCC_ED` ... 疑似統合環境で使用するテキストエディタの指定(既定値 `em -e`)。
  真里子版GCCの`満里奈`、`MARINA`からリネームされました。

* `SXEQU` ... `-SX`オプション指定時にアセンブリコードに出力する
  `.include sxcall.equ`のファイル名を指定します。

* `DOSEQU` ... `-SX`オプション無指定時(または`-fhuman`指定時)に
  アセンブリコードに出力する`.include doscall.equ`のファイル名を指定します。

* `GCC_AS` ... アセンブラを指定します(既定値 `has060`)。

* `GCC_LINK` ... リンカを指定します(既定値 `hlk`)。

* `-m68020`～`-m68040`指定時に出力するアラインメント整合命令を指定します。
  * `GCC_TEXT_ALIGN` ... 関数直前(既定値 `\\t.even\\n`)。
  * `GCC_BLOCK_ALIGN` ... 無条件分岐直後。
  * `GCC_DATA_ALIGN` ... データ直前(既定値 `\\t.even\\n`)。


## Build
PCやネット上での取り扱いを用意にするために、src/内のファイルはUTF-8で記述されています。
X68000上でビルドする際には、UTF-8からShift_JISへの変換が必要です。

### u8tosjを使用する方法

あらかじめ、[u8tosj](https://github.com/kg68k/u8tosj)をビルドしてインストールしておいてください。

トップディレクトリで`make`を実行してください。以下の処理が行われます。
1. build/ディレクトリの作成。
2. src/内の各ファイルをShift_JISに変換してbuild/へ保存。

次に、カレントディレクトリをbuild/に変更し、`make`を実行してください。
実行ファイルが作成されます。

### u8tosjを使用しない方法

ファイルを適当なツールで適宜Shift_JISに変換してから`make`を実行してください。
UTF-8のままでは正しくビルドできませんので注意してください。


## License
GNU GENERAL PUBLIC LICENSE Version 2 or later.


## Author
TcbnErik / 立花@桑島技研  
https://github.com/kg68k/gcc1p
