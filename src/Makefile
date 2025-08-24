# Makefile for GNU C compiler.
#   Copyright (C) 1987, 1988 Free Software Foundation, Inc.

#last modified for SHARP X68000 by Masaki KONDO, Oct 29 1989.

#This file is part of GNU CC.

#GNU CC is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 1, or (at your option)
#any later version.

#GNU CC is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with GNU CC; see the file COPYING.  If not, write to
#the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

SRCDIR_MK = ../srcdir.mk
SRC_DIR = ../src
-include $(SRCDIR_MK)

lx_opt = -i
EXTRACT_GCC142SR = lx -e $(SRC_DIR)/../archives/GCC142SR.LZH

# Variables that exist for you to override.
# See below for how to change them for certain systems.

CFLAGS = -O2 -cc1-stack=524288 $(ADD_FLAGS)
#CFLAGS = -O2 -cc1-stack=524288 -m68020-40
CC = gcc2
BISON = bison
BISONFLAGS =
AR = ar
#SHELL = command
SHELL = ksh
BINPREFIX =
prefix = a:
GCC-INCLUDE = $(gcc-include)
TMPDIR = $(temp)
AS-INCLUDE = $(include)
XSHELL=ksh

# gcc.x default heap and stack size
# do not use -z-heap= and -z-stack= option, because gcc2 outputs it in decimal.
GCCX_LDFLAGS = -Wl,-d_HEAP_SIZE=4000 -Wl,-d_STACK_SIZE=8000

# gcc_cpp.x and gcc_cc1.x default stack size
# do not use -z-heap= and -z-stack= option, because gcc2 outputs it in decimal.
STACK_SIZE_IN_HEX = 30000
LDFLAGS = -Wl,-d_STACK_SIZE=$(STACK_SIZE_IN_HEX)

# on sysV, define this as cp.
INSTALL = install -c

# Compiler to use for compiling gnulib.
# OLDCC should not be the GNU C compiler.
OLDCC = cc

# CFLAGS for use with OLDCC, for compiling gnulib.
# NOTE: -O does not work on some Unix systems!
# If you use it here, you are asking for trouble.
CCLIBFLAGS=

# Directory where sources are, from where we are.
srcdir = .
# Directory in which to put the executable for the command `gcc'
bindir = $(prefix)\gcc
# Directory in which to put the subprograms used by the compiler.
libdir = $(prefix)\lib
# Directory in which to put man pages.
mandir = $(prefix)\doc
# Number to put in man-page filename.
manext = n

# Additional system libraries to link with.
CLIB= -lsignal -lhmem -lhdi -lttyi
#CLIB= -lcshwild -ldos -liocs -lprof

# Change this to a null string if obstacks are installed in the
# system library.
OBSTACK=obstack.o

# Directory to link to, when using the target `maketest'.
DIR = ../gcc

# End of variables for you to override.


# Variables you should change for certain systems.

# These are what you would need on HPUX:
# CFLAGS = -Wc,-Ns2000 -Wc,-Ne700 -Wc,-Np300
# If you are using the GNU assembler and linker on HPUX,
# add -I../hp-include to CFLAGS.
# -g is desirable in CFLAGS, but a compiler bug in HPUX version 5
# bites whenever tree.def, rtl.def or machmode.def is included
# (ie., on every source file).
# If you have a floating point accelerator, you might want -lsetjmp as well.
# CCLIBFLAGS = -Wc,-Ns2000 -Wc,-Ne700
# For CCLIBFLAGS you might want to specify the switch that
# forces only 68000 instructions to be used.

# If you are making gcc for the first time, and if you are compiling it with
# a non-gcc compiler, and if your system doesn't have a working alloca() in any
# of the standard libraries (as is true for HP/UX or Genix),
# then get alloca.c from GNU Emacs and un-comment the following line:
# ALLOCA = alloca.o
# But don't do that if compiling using GCC.

# If your system has alloca() in /lib/libPW.a, un-comment the following line:
# CLIB= -lPW

# On a pyramid, you need to uncomment the following line:
# CLIB= -lalloca

# If your system's malloc() routine fails for any reason (as it does on
# certain versions of Genix), try getting the files
# malloc.c and getpagesize.h from GNU Emacs and un-comment the following line:
# MALLOC = malloc.o

# If you are running GCC on an Apollo (SR10.x),
# go into a Berkeley environment and use this:
# CFLAGS = -g -A nansi -A cpu,3000 -A runtype,bsd4.3 -A systype,any -DSHORT-ENUM-BUG
# (Says vasta@apollo.com.)


# Dependency on obstack, alloca, malloc or whatever library facilities
# are not installed in the system libraries.
LIBDEPS= $(OBSTACK) $(ALLOCA) $(MALLOC)

# How to link with both our special library facilities
# and the system's installed libraries.
LIBS = $(OBSTACK) $(ALLOCA) $(MALLOC) $(CLIB)

# Specify the directories to be searched for header files.
# Both . and srcdir are used, in that order,
# so that tm.h and config.h will be found in the compilation
# subdirectory rather than in the source directory.
#INCLUDES = -I. -I$(srcdir) -I$(srcdir)/config
#SUBDIR-INCLUDES = -I.. -I../$(srcdir) -I../$(srcdir)/config

# Always use -I$(srcdir)/config when compiling.
# .c.o:
#	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $<
%.o: %.c
	$(CC) $(BINPREFIX) -c $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $<

# Language-specific object files for C.
C-OBJS = c-parse-tab.o c-decl.o c-typeck.o c-convert.o

# Language-specific object files for C++.
# (These are not yet released.)
# CPLUS-OBJS = cplus-parse.o cplus-decl.o cplus-typeck.o \
#   cplus-cvt.o cplus-search.o cplus-lex.o \
#   cplus-class.o cplus-init.o cplus-method.o

# Language-independent object files.
OBJS = toplev.o version.o tree.o print-tree.o stor-layout.o fold-const.o \
 rtl.o rtlanal.o expr.o stmt.o expmed.o explow.o optabs.o varasm.o \
 emit-rtl.o insn-emit.o x68k-extra.o sdbout.o trap14.o\
 integrate.o jump.o cse.o loop.o flow.o stupid.o combine.o \
 regclass.o local-alloc.o global-alloc.o reload.o reload1.o caller-save.o \
 insn-peep.o final.o recog.o insn-recog.o insn-extract.o insn-output.o 

# Files to be copied away after each stage in building.
STAGE-GCC=gcc.x
STAGESTUFF = *.o insn-flags.h insn-config.h insn-codes.h \
 insn-output.c insn-recog.c insn-emit.c insn-extract.c insn-peep.c \
 stamp-flags.h stamp-config.h stamp-codes.h \
 stamp-output.c stamp-recog.c stamp-emit.c stamp-extract.c stamp-peep.c \
 genemit.x genoutput.x genrecog.x genextract.x genflags.x gencodes.x genconfig.x genpeep.x \
 gcc_cc1.x gcc_cpp.x # cc1plus

# Members of gnulib.
LIBFUNCS = -eprintf -builtin-new -builtin-New -builtin-del \
   -umulsi3 -mulsi3 -udivsi3 -divsi3 -umodsi3 -modsi3 \
   -lshrsi3 -lshlsi3 -ashrsi3 -ashlsi3 \
   -divdf3 -muldf3 -negdf2 -adddf3 -subdf3 -cmpdf2 \
   -fixunsdfsi -fixdfsi -floatsidf -truncdfsf2 -extendsfdf2 \
   -addsf3 -negsf2 -subsf3 -cmpsf2 -mulsf3 -divsf3 -varargs

# Library members defined in gnulib2.c.
LIB2FUNCS = -adddi3 -subdi3 -muldi3 -divdi3 -moddi3 -udivdi3 -umoddi3 -negdi2 \
    -anddi3 -iordi3 -xordi3 -lshrdi3 -lshldi3 -ashldi3 -ashrdi3 -one-cmpldi2  \
    -bdiv -cmpdi2 -ucmpdi2 -fixunsdfdi -fixdfdi -floatdidf

# Header files that are made available to programs compiled with gcc.
USER-H = stddef.h stdarg.h assert.h limits.h

# The files that "belong" in CONFIG-H are deliberately omitted
# because having them there would not be useful in actual practice.
# All they would do is cause complete recompilation every time
# one of the machine description files is edited.
# That may or may not be what one wants to do.
# If it is, rm *.o is an easy way to do it.
CONFIG-H = config.h tm.h
#CONFIG-H =
RTL-H = rtl.h rtl.def machmode.def
TREE-H = tree.h real.h tree.def machmode.def
CPLUS-TREE-H = $(TREE-H) cplus-tree.h c-tree.h

# Note that dependencies on obstack.h are not written
# because that file is not part of GCC.
# Dependencies on gvarargs.h are not written
# because all that file does, when not compiling with GCC,
# is include the system varargs.h.

all: gencodes.x genconfig.x genemit.x genextract.x genflags.x genoutput.x genpeep.x genrecog.x \
     gcc.x gcc_cpp.x gcc_cc1.x

#lang-c: gnulib.a gcc.x cc1.x cpp.x gnulib2.a
# lang-cplus: gnulib gcc cc1plus cpp gnulib2

#doc: $(srcdir)/cpp.info $(srcdir)/gplus.info $(srcdir)/gcc.info

compilations: ${OBJS}

asmcmp.x: asmcmp.c
	$(CC) $(CFLAGS) -o$@ $^

gcc.x: gcc.o version.o trapgcc.o $(LIBDEPS)
	$(CC) $(BINPREFIX) $(GCCX_LDFLAGS) -o$@ gcc.o trapgcc.o version.o $(LIBS)

g++.x: g++.o version.o $(LIBDEPS)
	$(CC) $(BINPREFIX) -o g++.x g++.o version.o $(LIBS)

# Go via `gccnew' to avoid `file busy' if $(CC) is `gcc'.
#	mv gccnew.x gcc.x

gcc_cc1.x: $(C-OBJS) $(OBJS) $(LIBDEPS) lastfile.o
	$(CC) $(LDFLAGS) -o $@ lastfile.o $(C-OBJS) $(OBJS) $(LIBS)

dummy.o:dummy.c

lastfile.o:lastfile.s

#Library of arithmetic subroutines
# Don't compile this with gcc!
# (That would cause most arithmetic functions to call themselves.)
# mkgnulib.x : mkgnulib.c
#	gcc -o mkgnulib.x mkgnulib.c -lcshwild -ldos

# gnulib.a: gnulib.c $(CONFIG-H) mkgnulib.x
#	@-rm -f stamp-gnulib2 gnulib.a -INDIRECT-
#	fecho -f -INDIRECT- gnulib CC /O $(INCLUDES) /L ---- $(LIBFUNCS)
#	mkgnulib.x -+-+--INDIRECT-
#	rm -f -INDIRECT-
# Actually build it in tmpgnulib above, then rename now,
# so that gnulib itself remains nonexistent if compilation is aborted.
#	mv tmpgnulib gnulib
# On HPUX, if you are working with the GNU assembler and linker,
# the previous line must be replaced with the following two lines.
# No change is needed here if you are using the HPUX assembler and linker.
#	mv gnulib gnulib-hp
#	../hp-bin/hpxt gnulib-hp gnulib

# gnulib2.a: stamp-gnulib2;
# stamp-gnulib2: gnulib2.c gnulib.a cc1.x gcc.x cpp.x $(CONFIG-H) mkgnulib.x
#	rm -f -INDIRECT- gnulib2.a
#	fecho -f -INDIRECT- gnulib2 gcc -fstrength-reduce -O $(INCLUDES) -c ---- $(LIB2FUNCS)
#	mkgnulib -+-+--INDIRECT-
#	@rm -f -INDIRECT-
# On HPUX, if you are working with the GNU assembler and linker,
# the previous line must be commented out.
# No change is needed here if you are using the HPUX assembler and linker.
#	touch stamp-gnulib2

float.h: hard-params.x
# Originally, we used `make' rather than $(MAKE), to avoid propagating
# a CC=gcc command option.  However, since hard-params is now made
# with $(OLDCC) explicitly, this is no longer important.
# However, $(MAKE) fails on some systems where it isn't defined.
# `make' has the disadvantage of sometimes running the system's make,
# instead of GNU make.  And the system's make might not support VPATH.
# However, the compilation of hard-params should not need to use VPATH,
# due to the explicit use of `$(srcdir)'.
	-hard-params.x -f > float.h

# Compile hard-params with standard cc.  It avoids some headaches.
#hard-params.x: hard-params.c
#	$(OLDCC) $(CCLIBFLAGS) $(CPPFLAGS) /I. /S /DNO-SC hard-params.c
#	as /u /w /i $(AS-INCLUDE) /m 3000 hard-params.s
#	@-rm -f hard-params.s
#	$(OLDCC) hard-params.o

# C language specific files.

c-parse-tab.o : c-parse-tab.c $(CONFIG-H) $(TREE-H) c-parse.h c-tree.h input.h
c-parse-tab.c : c-parse.y
	$(BISON) $(BISONFLAGS) c-parse.y -o $@

c-decl.o : c-decl.c $(CONFIG-H) $(TREE-H) c-tree.h c-parse.h flags.h
c-typeck.o : c-typeck.c $(CONFIG-H) $(TREE-H) c-tree.h flags.h
c-convert.o : c-convert.c $(CONFIG-H) $(TREE-H)

# Language-independent files.

gcc.o : gcc.c $(CONFIG-H)
	$(CC) -c $(CFLAGS) -fall-bsr $<

g++.o : g++.c $(CONFIG-H)
	$(CC) -c $(CFLAGS) -fall-bsr $<

version.o: version.c
obstack.o: obstack.c

tree.o : tree.c $(CONFIG-H) $(TREE-H) flags.h
print-tree.o : print-tree.c $(CONFIG-H) $(TREE-H)
stor-layout.o : stor-layout.c $(CONFIG-H) $(TREE-H) $(RTL-H)
fold-const.o : fold-const.c $(CONFIG-H) $(TREE-H)
toplev.o : toplev.c $(CONFIG-H) $(TREE-H) flags.h input.h

rtl.o : rtl.c $(CONFIG-H) $(RTL-H)

rtlanal.o : rtlanal.c $(CONFIG-H) $(RTL-H)

varasm.o : varasm.c $(CONFIG-H) $(TREE-H) $(RTL-H) flags.h expr.h \
   insn-codes.h hard-reg-set.h
stmt.o : stmt.c $(CONFIG-H) $(RTL-H) $(TREE-H) flags.h  \
   insn-flags.h expr.h insn-config.h regs.h hard-reg-set.h insn-codes.h
expr.o : expr.c $(CONFIG-H) $(RTL-H) $(TREE-H) flags.h  \
   insn-flags.h insn-codes.h expr.h insn-config.h recog.h
expmed.o : expmed.c $(CONFIG-H) $(RTL-H) $(TREE-H) flags.h  \
   insn-flags.h insn-codes.h expr.h insn-config.h recog.h
explow.o : explow.c $(CONFIG-H) $(RTL-H) $(TREE-H) flags.h expr.h insn-codes.h
optabs.o : optabs.c $(CONFIG-H) $(RTL-H) $(TREE-H) flags.h  \
   insn-flags.h insn-codes.h expr.h insn-config.h recog.h
symout.o : symout.c $(CONFIG-H) $(TREE-H) $(RTL-H) symseg.h gdbfiles.h
dbxout.o : dbxout.c $(CONFIG-H) $(TREE-H) $(RTL-H) flags.h
sdbout.o : sdbout.c $(CONFIG-H) $(TREE-H) $(RTL-H) sdbinf.h
trap14.o : trap14.c
emit-rtl.o : emit-rtl.c $(CONFIG-H) $(RTL-H) regs.h insn-config.h real.h

integrate.o : integrate.c $(CONFIG-H) $(RTL-H) $(TREE-H) flags.h expr.h \
   insn-flags.h insn-codes.h

jump.o : jump.c $(CONFIG-H) $(RTL-H) flags.h regs.h
stupid.o : stupid.c $(CONFIG-H) $(RTL-H) regs.h hard-reg-set.h

cse.o : cse.c $(CONFIG-H) $(RTL-H) regs.h hard-reg-set.h flags.h real.h
loop.o : loop.c $(CONFIG-H) $(RTL-H) insn-config.h insn-codes.h \
   regs.h hard-reg-set.h recog.h flags.h expr.h
x68k-extra.o : x68k-extra.c $(CONFIG-H) $(RTL-H) insn-config.h insn-codes.h \
   regs.h hard-reg-set.h recog.h flags.h expr.h
flow.o : flow.c $(CONFIG-H) $(RTL-H) basic-block.h regs.h hard-reg-set.h
combine.o : combine.c $(CONFIG-H) $(RTL-H) flags.h  \
   insn-config.h regs.h basic-block.h recog.h
regclass.o : regclass.c $(CONFIG-H) $(RTL-H) hard-reg-set.h flags.h \
   basic-block.h regs.h insn-config.h recog.h 
local-alloc.o : local-alloc.c $(CONFIG-H) $(RTL-H) flags.h basic-block.h regs.h \
   hard-reg-set.h insn-config.h recog.h
global-alloc.o : global-alloc.c $(CONFIG-H) $(RTL-H) flags.h  \
   basic-block.h regs.h hard-reg-set.h insn-config.h

reload.o : reload.c $(CONFIG-H) $(RTL-H) flags.h \
   reload.h recog.h hard-reg-set.h insn-config.h regs.h
reload1.o : reload1.c $(CONFIG-H) $(RTL-H) flags.h  \
   reload.h regs.h hard-reg-set.h insn-config.h basic-block.h recog.h
caller-save.o : caller-save.c $(CONFIG-H) $(RTL-H) flags.h \
   reload.h regs.h hard-reg-set.h insn-config.h basic-block.h recog.h
final.o : final.c $(CONFIG-H) $(RTL-H) flags.h regs.h recog.h conditions.h \
   gdbfiles.h insn-config.h real.h output.h
recog.o : recog.c $(CONFIG-H) $(RTL-H)  \
   regs.h recog.h hard-reg-set.h insn-config.h real.h

# Normally this target is not used; but it is used if you
# define ALLOCA=alloca.o.  In that case, you must get a suitable alloca.c
# from the GNU Emacs distribution.
# Note some machines won't allow $(CC) without -S on this source file.
#alloca.o:	alloca.c
#	$(CC) $(CFLAGS) -S `echo $(srcdir)/alloca.c | sed 's,^\./,,'`
#	as alloca.s -o alloca.o

# Now the source files that are generated from the machine description.

.PRECIOUS: insn-config.h insn-flags.h insn-codes.h \
  insn-emit.c insn-recog.c insn-extract.c insn-output.c insn-peep.c

# The following pair of rules has this effect:
# genconfig is run only if the md has changed since genconfig was last run;
# but the file insn-config.h is touched only when its contents actually change.

# Each of the other insn-* files is handled by a similar pair of rules.

cmp.x: cmp.c
	$(CC) $(CFLAGS) -o$@ $^

insn-config.h: s-config;
s-config: md cmp.x
	$(XSHELL) -c "./genconfig md > t-config.h"
	$(XSHELL) move-if-change t-config.h insn-config.h
	touch	s-config

insn-flags.h: s-flags;
s-flags: md cmp.x
	$(XSHELL) -c "./genflags md > t-flags.h"
	$(XSHELL) move-if-change t-flags.h insn-flags.h
	touch	s-flags

insn-codes.h: s-codes;
s-codes: md cmp.x
	$(XSHELL) -c "./gencodes md > t-codes.h"
	$(XSHELL) move-if-change t-codes.h insn-codes.h
	touch	s-codes

insn-emit.o : insn-emit.c $(CONFIG-H) $(RTL-H) expr.h real.h insn-codes.h \
  insn-config.h insn-flags.h asmcmp.x
	$(CC) $(BINPREFIX) $(CFLAGS) $(INCLUDES) -S insn-emit.c -o temp.s
	./asmcmp _gen_nop: temp.s tmp0.s
	$(CC) tmp0.s -c -o insn-emit.o
	rm tmp0.s temp.s

insn-emit.c:s-emit;
s-emit: md cmp.x
	$(XSHELL) -c "./genemit md > t-emit.c"
	$(XSHELL) move-if-change t-emit.c insn-emit.c
	touch	s-emit

insn-recog.o : insn-recog.c $(CONFIG-H) $(RTL-H) insn-config.h real.h recog.h
	$(CC) $(BINPREFIX) $(CFLAGS) $(INCLUDES) -c insn-recog.c

insn-recog.c:s-recog;
s-recog: md cmp.x
	$(XSHELL) -c "./genrecog md > t-recog.c"
	$(XSHELL) move-if-change t-recog.c insn-recog.c
	touch	s-recog

insn-extract.o : insn-extract.c $(CONFIG-H) $(RTL-H) asmcmp.x
	$(CC) $(BINPREFIX) $(CFLAGS) $(INCLUDES) -S insn-extract.c -o temp.s
	./asmcmp _insn_extract_fn: temp.s  tmp.s
	$(CC) tmp.s -c -o insn-extract.o
	rm tmp.s temp.s

insn-extract.c:s-extract;
s-extract: md cmp.x
	$(XSHELL) -c "./genextract md > t-extract.c"
	$(XSHELL) move-if-change t-extract.c insn-extract.c
	touch	s-extract

insn-peep.o : insn-peep.c $(CONFIG-H) $(RTL-H) regs.h real.h
	$(CC) $(BINPREFIX) $(CFLAGS) $(INCLUDES) -c insn-peep.c

insn-peep.c:s-peep;
s-peep: md cmp.x
	$(XSHELL) -c "./genpeep md > t-peep.c"
	$(XSHELL) move-if-change t-peep.c insn-peep.c
	touch	s-peep

insn-output.o : insn-output.c $(CONFIG-H) $(RTL-H) regs.h real.h conditions.h \
    hard-reg-set.h insn-config.h insn-flags.h output.h aux-output.c
	$(CC) $(BINPREFIX) $(CFLAGS) $(INCLUDES) -c insn-output.c

insn-output.c:s-output;
s-output: md cmp.x
	$(XSHELL) -c "./genoutput md > t-output.c"
	$(XSHELL) move-if-change t-output.c insn-output.c
	touch	s-output

insn.o: insn.c

# Now the programs that generate those files.
# $(CONFIG-H) is omitted from the deps of the gen*.o
# because these programs don't really depend on anything 
# about the target machine.  They do depend on config.h itself,
# since that describes the host machine.
#
#genconfig.x : genconfig.o rtl.o $(LIBDEPS)
#	$(CC) $(BINPREFIX) -o genconfig.x genconfig.o rtl.o $(LIBS)
#
#genconfig.o : genconfig.c $(RTL-H) config.h
#
#genflags.x : genflags.o rtl.o $(LIBDEPS)
#	$(CC) $(BINPREFIX) -o genflags.x genflags.o rtl.o $(LIBS)
#
#genflags.o : genflags.c $(RTL-H) config.h
#
#gencodes.x : gencodes.o rtl.o $(LIBDEPS)
#	$(CC) $(BINPREFIX) -o gencodes.x gencodes.o rtl.o $(LIBS)
#
#gencodes.o : gencodes.c $(RTL-H) config.h
#
#genemit.x : genemit.o rtl.o $(LIBDEPS)
#	$(CC) $(BINPREFIX) -o genemit.x genemit.o rtl.o $(LIBS)
#
#genemit.o : genemit.c $(RTL-H) config.h
#
#genrecog.x : genrecog.o rtl.o $(LIBDEPS)
#	$(CC) $(BINPREFIX) -o genrecog.x genrecog.o rtl.o $(LIBS)
#
#genrecog.o : genrecog.c $(RTL-H) config.h
#
#genextract.x : genextract.o rtl.o $(LIBDEPS)
#	$(CC) $(BINPREFIX) -o genextract.x genextract.o rtl.o $(LIBS)
#
#genextract.o : genextract.c $(RTL-H) config.h
#
#genpeep.x : genpeep.o rtl.o $(LIBDEPS)
#	$(CC) $(BINPREFIX) -o genpeep.x genpeep.o rtl.o $(LIBS)
#
#genpeep.o : genpeep.c $(RTL-H) config.h
#
#genoutput.x : genoutput.o rtl.o $(LIBDEPS)
#	$(CC) $(BINPREFIX)  -o genoutput.x genoutput.o rtl.o $(LIBS)
#
#genoutput.o : genoutput.c $(RTL-H) config.h

gencodes.x genconfig.x genemit.x genextract.x genflags.x genoutput.x genpeep.x genrecog.x:
	$(EXTRACT_GCC142SR) GCC/$@

# Making the preprocessor
gcc_cpp.x: cccp.o cexp.o version.o trap.o $(LIBDEPS)
	$(CC) $(BINPREFIX) $(LDFLAGS) -o$@ cccp.o cexp.o trap.o version.o $(LIBS)

cpcpp.x: cpcccp.o cexp.o version.o $(LIBDEPS)
	$(CC) $(BINPREFIX) -o cpcpp.x cpcccp.o cexp.o trap.o version.o $(LIBS)
cexp.o: cexp.c $(CONFIG-H)
cexp.c: cexp.y
	$(BISON) -o cexp.c cexp.y
cccp.o: cccp.c $(CONFIG-H)
cpcccp.o: cccp.c $(CONFIG-H)
	$(CC) $(CFLAGS) -DCPLUSPLUS -c -o cpcccp.o cccp.c
trap.o: trap14.c
	$(CC) $(CFLAGS) -DNO_CC1 -o trap.o -c trap14.c

trapgcc.o: trap14.c
	$(CC) $(CFLAGS) -DNO_CC1 -DNO_CPP -o trapgcc.o -c trap14.c

# gnulib is not deleted because deleting it would be inconvenient
# for most uses of this target.
clean:
	-rm -f $(STAGESTUFF) $(STAGE-GCC)
# Delete the temp files made in the course of building gnulib.
	-rm -f tmpgnulib
	-rm -f stamp-*.[ch] tmp-insn-*
	-rm -f *.s
	-rm -f float.h hard-params.x

# Get rid of every file that's generated from some other file (except INSTALL).
realclean: clean
	-rm -f c-parse-tab.c c-parse.out c-parse-tab.out
	-rm -f gnulib.a cexp.c

# Copy the files into directories where they will be run.
install: all
	cp cc1.x $(bindir)/gcc-cc1.x
	cp cpp.x $(bindir)/gcc-cpp.x
	cp gcc.x $(bindir)/gcc.x
	-mkdir $(GCC-INCLUDE)
	cp $(USER-H) $(GCC-INCLUDE)
	cp float.h $(GCC-INCLUDE)/float.h
	cp gvarargs.h $(GCC-INCLUDE)/varargs.h
#	cp gnulib.a $(libdir)/gnulib.a
#	cp gnulib2.a $(libdir)/gnulib2.a

bootstrap: all force
	$(MAKE) stage1
	$(MAKE) CC=stage1/gcc BINPREFIX=-Bstage1/ "CFLAGS=-O $(CFLAGS)" libdir=$(libdir)
	$(MAKE) stage2
	$(MAKE) CC=stage2/gcc BINPREFIX=-Bstage2/ "CFLAGS=-O $(CFLAGS)" libdir=$(libdir)

bootstrap2: force
	$(MAKE) CC=stage1/gcc BINPREFIX=-Bstage1/ "CFLAGS=-O $(CFLAGS)" libdir=$(libdir)
	$(MAKE) stage2
	$(MAKE) CC=stage2/gcc BINPREFIX=-Bstage2/ "CFLAGS=-O $(CFLAGS)" libdir=$(libdir)

bootstrap3: force
	$(MAKE) CC=stage2/gcc BINPREFIX=-Bstage2/ "CFLAGS=-O $(CFLAGS)" libdir=$(libdir)

# Copy the object files from a particular stage into a subdirectory.
stage1: force
	-mkdir stage1
	-mv $(STAGESTUFF) $(STAGE-GCC) stage1
	-mv stage1/cc1.x stage1/gcc-cc1.x
	-mv stage1/cpp.x stage1/gcc-cpp.x
	-rm -f stage1/gnulib

stage2: force
	-mkdir stage2
	-mv $(STAGESTUFF) $(STAGE-GCC) stage2
	-mv stage2/cc1.x stage2/gcc-cc1.x
	-mv stage2/cpp.x stage2/gcc-cpp.x
	-rm -f stage2/gnulib

stage3: force
	-mkdir stage3
	-mv $(STAGESTUFF) $(STAGE-GCC) stage3
	-rm -f stage3/gnulib

stage4: force
	-mkdir stage4
	-mv $(STAGESTUFF) $(STAGE-GCC) stage4
	-rm -f stage4/gnulib

#In GNU Make, ignore whether `stage*' exists.
.PHONY: stage1 stage2 stage3 stage4 clean realclean TAGS bootstrap

force:

