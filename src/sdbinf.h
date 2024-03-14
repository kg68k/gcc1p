/* SDB info header for X68000
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


#ifdef __human68k__

/* Maximum number of dimensions the assembler will allow.  */

#define SDB_MAX_DIM 4


#define PUT_SDB_SCL(a) fprintf(asm_out_file, "\t.scl\t%d\n", (a))

#define PUT_SDB_INT_VAL(a) fprintf (asm_out_file, "\t.val\t%d\n", (a))


#define PUT_SDB_VAL(a)				\
( fputs ("\t.val\t", asm_out_file),		\
  output_addr_const (asm_out_file, (a)),	\
  fputc ('\n', asm_out_file))

#define PUT_SDB_DEF(a)				\
do { fprintf (asm_out_file, "\t.def\t");	\
     ASM_OUTPUT_LABELREF (asm_out_file, a); 	\
     fprintf (asm_out_file, "\n"); } while (0)

#define PUT_SDB_PLAIN_DEF(a) fprintf(asm_out_file,"\t.def\t.%s\n",a)

#define PUT_SDB_ENDEF fputs("\t.endef\n", asm_out_file)

#define PUT_SDB_TYPE(a) fprintf(asm_out_file, "\t.type\t%d\n", a)

#define PUT_SDB_SIZE(a) fprintf(asm_out_file, "\t.size\t%d\n", a)

#define PUT_SDB_START_DIM fprintf(asm_out_file, "\t.dim\t")

#define PUT_SDB_NEXT_DIM(a) fprintf(asm_out_file, "%d,", a)

#define PUT_SDB_LAST_DIM(a) fprintf(asm_out_file, "%d\n", a)

#define PUT_SDB_TAG(a)				\
do { fprintf (asm_out_file, "\t.tag\t");	\
     ASM_OUTPUT_LABELREF (asm_out_file, a);	\
     fprintf (asm_out_file, "\n"); } while (0)

#define PUT_SDB_BLOCK_START(LINE)		\
  fprintf (asm_out_file,			\
	   "\t.def\t.bb\n\t.val\t.\n\t.scl\t100\n\t.line\t%d\n\t.endef\n",	\
	   (LINE))

#define PUT_SDB_BLOCK_END(LINE)			\
  fprintf (asm_out_file,			\
	   "\t.def\t.eb\n\t.val\t.\n\t.scl\t100\n\t.line\t%d\n\t.endef\n",	\
	   (LINE))

#define PUT_SDB_FUNCTION_START(LINE)		\
  fprintf (asm_out_file,			\
	   "\t.def\t.bf\n\t.val\t.\n\t.scl\t101\n\t.line\t%d\n\t.endef\n",	\
	   (LINE))

#define PUT_SDB_FUNCTION_END(LINE)		\
  fprintf (asm_out_file,			\
	   "\t.def\t.ef\n\t.val\t.\n\t.scl\t101\n\t.line\t%d\n\t.endef\n",	\
	   (LINE))

#define PUT_SDB_EPILOGUE_END(NAME)		\
  fprintf (asm_out_file,			\
	   "\t.def\t_%s\n\t.val\t.\n\t.scl\t-1\n\t.endef\n",	\
	   (NAME))

#define SDB_GENERATE_FAKE(BUFFER, NUMBER) \
  sprintf ((BUFFER), ".fake%d", (NUMBER));

#endif
