IF EXIST gcc.x GOTO NOREN
ren botgcc.x gcc.x
ren botcpp.x gcc_cpp.x
ren botcc1.x gcc_cc1.x
:NOREN
set GCC_AS=has
set GCC_TEXT_ALIGN=
set GCC_BLOCK_ALIGN=
set GCC_DATA_ALIGN=
set GCC_OPTION= FMLJOK
IF EXIST cc1.x GOTO REDO
make all
IF NOT EXIST gccnew.x GOTO ERR
IF NOT EXIST cpp.x GOTO ERR
IF NOT EXIST cc1.x GOTO ERR
ren gcc_cc1.x botcc1.x
ren gcc.x     botgcc.x
ren gcc_cpp.x botcpp.x
:REDO
ren gccnew.x  gcc.x
ren cpp.x     gcc_cpp.x
ren cc1.x     gcc_cc1.x
touch tm.h
make all
IF NOT EXIST gccnew.x GOTO ERR
IF NOT EXIST cpp.x GOTO ERR
IF NOT EXIST cc1.x GOTO ERR
ren gcc_cc1.x 1stcc1.x
ren gcc.x     1stgcc.x
ren gcc_cpp.x 1stcpp.x
ren gccnew.x  gcc.x
ren cpp.x     gcc_cpp.x
ren cc1.x     gcc_cc1.x
touch tm.h
make all
IF NOT EXIST gccnew.x GOTO ERR
IF NOT EXIST cpp.x GOTO ERR
IF NOT EXIST cc1.x GOTO ERR
ren gcc_cc1.x 2ndcc1.x
ren gcc.x     2ndgcc.x
ren gcc_cpp.x 2ndcpp.x
