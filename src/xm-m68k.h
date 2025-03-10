/* Configuration for GNU C-compiler for Motorola 68000 family.
   Copyright (C) 1987 Free Software Foundation, Inc.

This file is part of GNU CC.

GNU CC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

GNU CC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU CC; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */

/* #defines that need visibility everywhere.  */
#define FALSE 0
#define TRUE 1

/* This describes the machine the compiler is hosted on.  */
#define HOST_BITS_PER_CHAR 8
#define HOST_BITS_PER_SHORT 16
#define HOST_BITS_PER_INT 32
#define HOST_BITS_PER_LONG 32
#define HOST_WORDS_BIG_ENDIAN 1

/* target machine dependencies.
   tm.h is a symbolic link to the actual target specific file.   */
#include "tm.h"

/* Arguments to use with `exit'.  */
#define SUCCESS_EXIT_CODE 0
#define FATAL_EXIT_CODE 33

/* If compiled with GNU C, use the built-in alloca */
#ifdef __GNUC__
#if !(GNU_C_VERSION == 2)
#define alloca(SIZE)                                                \
  ({                                                                \
    extern int *_SSTA;                                              \
    extern volatile stack_over();                                   \
    int stpos;                                                      \
    int alloca_size = (SIZE);                                       \
    asm("move.l sp,%0" : "=g"(stpos));                              \
    stpos -= alloca_size;                                           \
    if ((unsigned)stpos < (unsigned)_SSTA) stack_over(alloca_size); \
    __builtin_alloca(alloca_size);                                  \
  })
#else
#define alloca __builtin_alloca
#define index strchr
#define rindex strrchr
#endif
#endif
