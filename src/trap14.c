/* Error Handler for X68000
   Copyright (C) 1987, 1988 Free Software Foundation, Inc.
   Copyright (C) 1991 Mariko,FSHARP

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

/* This file uses function of GCC Mariko Version ONLY!!
   so,if you use other GCC, omit this file and modify toplev.c */

/* system include */
#include <stdio.h>
#ifndef NO_CPP
#include <interrupt.h>

#ifndef NO_CC1
/* Gcc headers */
#include "tree.h"
#include "c-tree.h"
#include "rtl.h"

/* declered in toplev.c */
extern tree current_function_decl;
extern FILE *mariko_err_file;
extern int optimize;
extern int flag_debug_rtl;
#endif

static struct {
 int flag;
 unsigned short sr_reg;
 int pc_reg;
 char *mes;
} trapbuf;

static int local_stack[32];

void (*trap_14)();

trap14()
{
  PRAMREG( code, d7);
  PRAMREG( add,  a6);
  SET_FRAME(a5);
  char *p =(char *)add;
  switch (code&0xffff)
    {
    case 2:
      trapbuf.flag = code;
      trapbuf.mes = "バスエラーが発生しました";
      break;
    case 3:
      trapbuf.flag = code;
      trapbuf.mes = "アドレスエラーが発生しました";
      break;
    case 4:
      trapbuf.flag = code;
      trapbuf.mes = "おかしな命令を実行しました";
      break;
    }
  if ((code &0xff00) &&  (code & 0xff) == 2)
    {
      trapbuf.flag = -1;
      trapbuf.mes  = "ドライブの準備ができていません";
    }
  if (trapbuf.flag || (code&0xffff) == 0x1f || (code&0xffff) == 0x301f)
    {
      trapbuf.sr_reg = *(short *)p;
      p+=2;
      trapbuf.pc_reg = *(int *)p;
      asm ("\tmove.w #$ff,d0\n\ttrap #15\n");
      IJUMP_RTE();
    }
  else
    IJUMP(trap_14);
}
#endif

void stack_over (size)
int size;
{
#ifndef NO_CC1
  error ("スタックが不足です");
  error ("最低追加必要量 %d バイトです", size);
#else
  fprintf (stderr, "スタックが不足です\n");
  fprintf (stderr, "最低追加必要量 %d バイトです\n", size);
#endif
  fcloseall();
  exit (33);
}
#ifndef NO_CPP
#ifndef NO_CC1

void
x68kdebug()
{
  rtx insn = get_insns ();
  print_rtl (stderr, insn);
}

static void
output_debug_info ()
{
  extern char *current_process;
  int i;
  fprintf (stderr, "Processing %s\n", current_process);
}
#endif
extern INTVCS();

abort(int dummy)
{
  int asm_ok = 0;
  INTVCS(0x2e,trap_14);
#ifndef NO_CC1
  if (current_function_decl)
    {
      fprintf (stderr, "処理関数 %s\n",
	       DECL_PRINT_NAME (current_function_decl));
      if (asm_ok = TREE_ASM_WRITTEN (current_function_decl))
	fprintf (stderr,"insn 処理開始後発生\n");
#if 0
      if (asm_ok && !flag_debug_rtl)
	{
	  rtx insn = get_insns ();
	  print_rtl (stderr, insn);
	}
#endif
    }
#endif
  if (trapbuf.flag > 0)
    {
      extern int _SSTA;
      extern int _PSTA;
      int stack;
      trapbuf.flag = 0;
      asm( "move.l sp,%0":"=r"(stack):"0"(stack));
      fprintf(stderr,"%s\n",trapbuf.mes);
      fprintf(stderr," st=%X ",trapbuf.sr_reg);
      fprintf(stderr," pc=%X",trapbuf.pc_reg);
      fprintf(stderr," offset=%X",trapbuf.pc_reg - _PSTA);
      fprintf(stderr," abort stack=%X",stack);
      fprintf(stderr," stack top=%X\n\n",_SSTA);
#ifndef NO_CC1
      output_debug_info ();
#endif
      exit(512);
    }
  else
    {
      if (trapbuf.flag == -1)
	fprintf(stderr,"%s\n",trapbuf.mes);
      fprintf(stderr,"コンパイルを中断します");
      fprintf(stderr," exec addr=%X \n",(int)*((int *)&dummy-1));
#ifndef NO_CC1
      if (mariko_err_file)
	{
	  fcloseall();
	  exit (33);
	}
#endif
      exit(1);
    }
}
#endif
