set GCC_AS=has
set GCC_TEXT_ALIGN=.quad
set GCC_BLOCK_ALIGN=.quad
set GCC_DATA_ALIGN=.quad
set GCC_OPTION= FMLJOK
IF EXIST cc1.x GOTO REDO
make ADD_FLAGS=-m68020 all
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
make ADD_FLAGS=-m68020 all
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
make ADD_FLAGS=-m68020 all
IF NOT EXIST gccnew.x GOTO ERR
IF NOT EXIST cpp.x GOTO ERR
IF NOT EXIST cc1.x GOTO ERR
ren gcc_cc1.x 2ndcc1.x
ren gcc.x     2ndgcc.x
ren gcc_cpp.x 2ndcpp.x
copy *.o 030OBJ
copy *.x 030OBJ
:ERR
