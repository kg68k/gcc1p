/* Definitions of target machine for GNU compiler.  X68000/X68030 version.
   Copyright (C) 1987, 1988 Free Software Foundation, Inc.
   Copyright (C) 1993  FSHARP3 Mariko
   Compatibel for GCC 1.42/GCC 2.?? on X68000/X68030

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


/* Note that some other tm- files include this one and then override
   many of the definitions that relate to assembler syntax.  */

/* Names to predefine in the preprocessor for this target machine.  */

#define CPP_PREDEFINES "-Dmc68000 -Dhuman68k -DHUMAN68K -DMARIKO_CC -Dmariko_cc"

/* undef gcc search path */
#undef STANDARD_EXEC_PREFIX
#undef STANDARD_STARTFILE_PREFIX

/* has.x spec */
#define ASM_SPEC	"-1 -w -u -i %I"

/* hlk.x spec, but never used */
#define LIB_SPEC "%{ldos:doslib.a%s} %{liocs:iocslib.a%s} %{lbas:baslib.a%s}"

#define STARTFILE_SPEC	""

#define STANDARD_EXEC_PREFIX	""
#define STANDARD_STARTFILE_PREFIX ""

/* use memcpy(), memcmp(), memset() */
#define TARGET_MEM_FUNCTIONS

#undef DBX_DEBUGGING_INFO
#define SDB_DEBUGGING_INFO

/* Human68k/X68000's as.x is MOTOROLA syntax */
#define MOTOROLA

/* useing has.x & fas.x */
#define HUMAN68K_ASM

/* Print subsidiary information on the compiler version in use.  */
#define TARGET_VERSION fprintf (stderr, " (HAS Ver 3.XX syntax)\n ");

/* Run-time compilation parameters selecting different hardware subsets.  */

extern int target_flags;

/* Macros used in the machine description to test the flags.  */

/* Compile for a 68020 (not a 68000 or 68010).  */
#define TARGET_68020  (target_flags & 1)

/* Compile 68881 insns for floating point (not library calls).  */
#define TARGET_68881 (target_flags & 2)

/* Compile using 68020 bitfield insns.  */
#define TARGET_BITFIELD  (target_flags & 4)

/* Compile using rtd insn calling sequence.
   This will not work unless you use prototypes at least
   for all functions that can take varying numbers of args.  */

#define TARGET_RTD  (target_flags & 8)

/* Compile passing first two args in regs 0 and 1.
   This exists only to test compiler features that will
   be needed for RISC chips.  It is not usable
   and is not intended to be usable on this cpu.  */
#define TARGET_REGPARM (target_flags & 020)

/* Compile with 16-bit `int'.  */
#define TARGET_SHORT (target_flags & 040)

/* Compile with special insns for Sun FPA.  */
#define TARGET_FPA 0

/* Optimize for 68040, but still allow execution on 68020
   (-m68020-40 or -m68040).
   The 68040 will execute all 68030 and 68881/2 instructions, but some
   of them must be emulated in software by the OS.  When TARGET_68040 is
   turned on, these instructions won't be used.  This code will still
   run on a 68030 and 68881/2. */
#define TARGET_68040 (target_flags & 01400)

/* Macro to define tables used to set the flags.
   This is a list in braces of pairs in braces,
   each pair being { "NAME", VALUE }
   where VALUE is the bits to set or minus the bits to clear.
   An empty string NAME is used to identify the default VALUE.  */

#define TARGET_SWITCHES  \
  { { "68000", -5},				\
    { "c68000", -5},				\
    { "68020", 5},				\
    { "c68020", 5},				\
    { "68881", 2},				\
    { "68040",01407},				\
    { "soft-float", -0102},			\
    { "bitfield", 4},				\
    { "nobitfield", -4},			\
    { "short", 040},				\
    { "noshort", -040},				\
    { "regparm", 020},				\
    { "", TARGET_DEFAULT}}

#if (GNU_C_VERSION == 2)

#define X68KGET_TIME				\
  register int tim asm ("d0");			\
  tim = 0x7f;					\
  asm ("trap #15":"=d"(tim):"d"(tim));		\
  return tim * 10000;

/* Optimize for 68040, but still allow execution on 68020
   (-m68020-40 or -m68040).
   The 68040 will execute all 68030 and 68881/2 instructions, but some
   of them must be emulated in software by the OS.  When TARGET_68040 is
   turned on, these instructions won't be used.  This code will still
   run on a 68030 and 68881/2. */
#define TARGET_68040 (target_flags & 01400)

/* Use the 68040-only fp instructions (-m68040).  */
#define TARGET_68040_ONLY (target_flags & 01000)
#endif

#define TARGET_DEFAULT 0

/* Blow away 68881 flag silently on TARGET_FPA (since we can't clear
   any bits in TARGET_SWITCHES above) */
#define OVERRIDE_OPTIONS		\
{					\
  if (TARGET_FPA) target_flags &= ~2;	\
}

/* target machine storage layout */

/* Define this if most significant bit is lowest numbered
   in instructions that operate on numbered bit-fields.
   This is true for 68020 insns such as bfins and bfexts.
   We make it true always by avoiding using the single-bit insns
   except in special cases with constant bit numbers.  */

#define BITS_BIG_ENDIAN 1

/* Define this if most significant byte of a word is the lowest numbered.  */
/* That is true on the 68000.  */
#define BYTES_BIG_ENDIAN 1

/* Define this if most significant word of a multiword number is numbered.  */
/* For 68000 we can decide arbitrarily
   since there are no machine instructions for them.  */
#if (GNU_C_VERSION == 2)
#define WORDS_BIG_ENDIAN 1
#else
/* #define WORDS_BIG_ENDIAN */
#endif

/* number of bits in an addressible storage unit */
#define BITS_PER_UNIT 8

/* Width in bits of a "word", which is the contents of a machine register.
   Note that this is not necessarily the width of data type `int';
   if using 16-bit ints on a 68000, this would still be 32.
   But on a machine with 16-bit registers, this would be 16.  */
#define BITS_PER_WORD 32

/* Width of a word, in units (bytes).  */
#define UNITS_PER_WORD 4

/* Width in bits of a pointer.
   See also the macro `Pmode' defined below.  */
#define POINTER_SIZE 32

/* Allocation boundary (in *bits*) for storing pointers in memory.  */
#define POINTER_BOUNDARY 16

/* Allocation boundary (in *bits*) for storing arguments in argument list.  */
#define PARM_BOUNDARY (TARGET_SHORT ? 16 : 32)

/* Boundary (in *bits*) on which stack pointer should be aligned.  */
#define STACK_BOUNDARY 16

/* Allocation boundary (in *bits*) for the code of a function.  */
#define FUNCTION_BOUNDARY 16

/* Alignment of field after `int : 0' in a structure.  */
#define EMPTY_FIELD_BOUNDARY 16

/* No data type wants to be aligned rounder than this.  */
#define BIGGEST_ALIGNMENT 16

/* Define this if move instructions will actually fail to work
   when given unaligned data.  */
#define STRICT_ALIGNMENT 1

/* Every structure or union's size must be a multiple of 2 bytes.  */
#define STRUCTURE_SIZE_BOUNDARY 16

#if (GNU_C_VERSION == 2)
#define SELECT_RTX_SECTION(MODE, X)					\
{									\
  if (!flag_pic)							\
    readonly_data_section();						\
  else if (LEGITIMATE_PIC_OPERAND_P (X))				\
    readonly_data_section();						\
  else									\
    data_section();							\
}
#endif

/* Define number of bits in most basic integer type.
   (If undefined, default is BITS_PER_WORD).  */

#define INT_TYPE_SIZE (TARGET_SHORT ? 16 : 32)

#if (GNU_C_VERSION == 2)
/* Define this to be true when FUNCTION_VALUE_REGNO_P is true for
   more than one register.  */
#define NEEDS_UNTYPED_CALL 0

/* Define these to avoid dependence on meaning of `int'.
   Note that WCHAR_TYPE_SIZE is used in cexp.y,
   where TARGET_SHORT is not available.  */

#define WCHAR_TYPE "long int"
#define WCHAR_TYPE_SIZE 32
#endif


/* Standard register usage.  */

/* Number of actual hardware registers.
   The hardware registers are assigned numbers for the compiler
   from 0 to just below FIRST_PSEUDO_REGISTER.
   All registers that the compiler knows about must be given numbers,
   even those that are not normally considered general registers.
   For the 68000, we give the data registers numbers 0-7,
   the address registers numbers 010-017,
   and the 68881 floating point registers numbers 020-027.  */

/* X68000/X68030 not have fpa register */
#undef  SUPPORT_SUN_FPA
#ifndef SUPPORT_SUN_FPA
#define FIRST_PSEUDO_REGISTER 25
#else
#define FIRST_PSEUDO_REGISTER 56
#endif

#if (GNU_C_VERSION == 2)
/* This defines the register which is used to hold the offset table for PIC. */
#define PIC_OFFSET_TABLE_REGNUM 13

/* Used to output a (use pic_offset_table_rtx) so that we 
   always save/restore a5 in functions that use PIC relocation
   at *any* time during the compilation process. */
#define FINALIZE_PIC finalize_pic()
#endif

/* 1 for registers that have pervasive standard uses
   and are not available for the register allocator.
   On the 68000, only the stack pointer is such.  */
/* fpa0 is also reserved so that it can be used to move shit back and
   forth between high fpa regs and everything else. */
#define FIXED_REGISTERS  	\
 {0, 0, 0, 0, 0, 0, 0, 0, 	\
  0, 0, 0, 0, 0, 0, 0, 1, 	\
  0, 0, 0, 0, 0, 0, 0, 0,	\
  /* pc reg */			\
  1 }

/* 1 for registers not available across function calls.
   These must include the FIXED_REGISTERS and also any
   registers that can be used without being saved.
   The latter must include the registers where values are returned
   and the register where structure-value addresses are passed.
   Aside from that, you can include as many other registers as you like.  */
#define CALL_USED_REGISTERS	\
 { /* DATA register */		\
  1, 1, 1, 0, 0, 0, 0, 0, 	\
   /* ADDRESS register */	\
  1, 1, 1, 0, 0, 0, 0, 1,	\
/* 68881 register */     	\
  1, 1, 0, 0, 0, 0, 0, 0,	\
/* PC reg */			\
  1 }

/* Make sure everything's fine if we *don't* have a given processor.
   This assumes that putting a register in fixed_regs will keep the
   compilers mitt's completely off it.  We don't bother to zero it out
   of register classes.  If neither TARGET_FPA or TARGET_68881 is set,
   the compiler won't touch since no instructions that use these
   registers will be valid.  */

#if (GNU_C_VERSION == 2)
#define CONDITIONAL_REGISTER_USAGE \
{                                               \
  if (flag_pic)                                 \
    fixed_regs[PIC_OFFSET_TABLE_REGNUM] = 1;    \
}
#else
#define CONDITIONAL_REGISTER_USAGE
#endif

/* Return number of consecutive hard regs needed starting at reg REGNO
   to hold something of mode MODE.
   This is ordinarily the length in words of a value of mode MODE
   but can be less for certain modes in special long registers.

   On the 68000, ordinary registers hold 32 bits worth;
   for the 68881 registers, a single register is always enough for
   anything that can be stored in them at all.  */
#define HARD_REGNO_NREGS(REGNO, MODE)   \
  ((REGNO) >= 16 ? 1				\
   : ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD))

/* Value is 1 if hard register REGNO can hold a value of machine-mode MODE.
   On the 68000, the cpu registers can hold any mode but the 68881 registers
   can hold only SFmode or DFmode.  And the 68881 registers can't hold anything
   if 68881 use is disabled.  However, the Sun FPA register can
   (apparently) hold whatever you feel like putting in them.  */
#if (GNU_C_VERSION == 2)
#define HARD_REGNO_MODE_OK(REGNO, MODE) \
  (((REGNO) < 16)                                       \
   || ((REGNO) < 24				        \
       && TARGET_68881                                  \
       && (GET_MODE_CLASS (MODE) == MODE_FLOAT		\
	   || GET_MODE_CLASS (MODE) == MODE_COMPLEX_FLOAT)))
#else
#define HARD_REGNO_MODE_OK(REGNO, MODE) \
  ((((REGNO) < 16) && ((MODE) != DFmode || (REGNO) != 7))	\
   || ((REGNO) < 24 ? TARGET_68881 && ((MODE) == SFmode || (MODE) == DFmode) : 0))
#endif

/* Value is 1 if it is a good idea to tie two pseudo registers
   when one has mode MODE1 and one has mode MODE2.
   If HARD_REGNO_MODE_OK could produce different values for MODE1 and MODE2,
   for any hard reg, then this must be 0 for correct output.  */
#if (GNU_C_VERSION == 2)
#define MODES_TIEABLE_P(MODE1, MODE2)			\
  (! TARGET_68881					\
   || ((GET_MODE_CLASS (MODE1) == MODE_FLOAT		\
	|| GET_MODE_CLASS (MODE1) == MODE_COMPLEX_FLOAT)	\
       == (GET_MODE_CLASS (MODE2) == MODE_FLOAT		\
	   || GET_MODE_CLASS (MODE2) == MODE_COMPLEX_FLOAT)))
#else
#define MODES_TIEABLE_P(MODE1, MODE2)			\
  (! TARGET_68881					\
   || (((MODE1) == SFmode || (MODE1) == DFmode)		\
       == ((MODE2) == SFmode || (MODE2) == DFmode)))
#endif

/* Specify the registers used for certain standard purposes.
   The values of these macros are register numbers.  */

/* m68000 pc isn't overloaded on a register.  */
/* #define PC_REGNUM  */

/* Register to use for pushing function arguments.  */
#define STACK_POINTER_REGNUM 15

/* Base register for access to local variables of the function.  */
#if (GNU_C_VERSION == 2)
#define FRAME_POINTER_REGNUM 14
#else
extern int mariko_frame_pointer;
#define FRAME_POINTER_REGNUM mariko_frame_pointer
#endif

/* Value should be nonzero if functions must have frame pointers.
   Zero means the frame pointer need not be set up (and parms
   may be accessed via the stack pointer) in functions that seem suitable.
   This is computed in `reload', in reload1.c.  */
#define FRAME_POINTER_REQUIRED 0

/* Base register for access to arguments of the function.  */
#if (GNU_C_VERSION == 2)
#define ARG_POINTER_REGNUM 14
#else
/* #define ARG_POINTER_REGNUM 14 */
#endif

/* Register in which static-chain is passed to a function.  */
#define STATIC_CHAIN_REGNUM 8

/* Register in which address to store a structure value
   is passed to a function.  */
#define STRUCT_VALUE_REGNUM 9

/* Define the classes of registers for register constraints in the
   machine description.  Also define ranges of constants.

   One of the classes must always be named ALL_REGS and include all hard regs.
   If there is more than one class, another class must be named NO_REGS
   and contain no registers.

   The name GENERAL_REGS must be the name of a class (or an alias for
   another name such as ALL_REGS).  This is the class of registers
   that is allowed by "g" or "r" in a register constraint.
   Also, registers outside this class are allocated only when
   instructions express preferences for them.

   The classes must be numbered in nondecreasing order; that is,
   a larger-numbered class must never be contained completely
   in a smaller-numbered class.

   For any two classes, it is very desirable that there be another
   class that represents their union.  */

/* The 68000 has three kinds of registers, so eight classes would be
   a complete set.  One of them is not needed.  */

enum reg_class {
  NO_REGS, DATA_REGS,
  ADDR_REGS, FP_REGS,
  GENERAL_REGS, DATA_OR_FP_REGS,
  ADDR_OR_FP_REGS, ALL_REGS,
  LIM_REG_CLASSES };

#define N_REG_CLASSES (int) LIM_REG_CLASSES

/* Give names of register classes as strings for dump file.   */

#define REG_CLASS_NAMES \
 { "NO_REGS", "DATA_REGS",              \
   "ADDR_REGS", "FP_REGS",              \
   "GENERAL_REGS", "DATA_OR_FP_REGS",   \
   "ADDR_OR_FP_REGS", "ALL_REGS" }

/* Define which registers fit in which classes.
   This is an initializer for a vector of HARD_REG_SET
   of length N_REG_CLASSES.  */

#define REG_CLASS_CONTENTS \
{					\
 0x00000000,   	/* NO_REGS */		\
 0x000000ff,	/* DATA_REGS */		\
 0x0000ff00,	/* ADDR_REGS */		\
 0x00ff0000,	/* FP_REGS */		\
 0x0000ffff,	/* GENERAL_REGS */	\
 0x00ff00ff,	/* DATA_OR_FP_REGS */	\
 0x00ffff00,    /* ADDR_OR_FP_REGS */   \
 0x00ffffff,	/* ALL_REGS */		\
}

/* The same information, inverted:
   Return the class number of the smallest class containing
   reg number REGNO.  This could be a conditional expression
   or could index an array.  */

#define REGNO_REG_CLASS(REGNO) (((REGNO) >> 3) + 1)

/* The class value for index registers, and the one for base regs.  */

#define INDEX_REG_CLASS GENERAL_REGS
#define BASE_REG_CLASS ADDR_REGS

/* Get reg_class from a letter such as appears in the machine description.
   We do a trick here to modify the effective constraints on the
   machine description; we zorch the constraint letters that aren't
   appropriate for a specific target.  This allows us to guarantee
   that a specific kind of register will not be used for a given target
   without fiddling with the register classes above. */
#define REG_CLASS_FROM_LETTER(C) \
  ((C) == 'a' ? ADDR_REGS :			\
   ((C) == 'd' ? DATA_REGS :			\
    ((C) == 'f' ? (TARGET_68881 ? FP_REGS :	\
		   NO_REGS) :			\
     NO_REGS)))

/* The letters I, J, K, L and M in a register constraint string
   can be used to stand for particular ranges of immediate operands.
   This macro defines what the ranges are.
   C is the letter, and VALUE is a constant value.
   Return 1 if VALUE is in the range specified by C.

   For the 68000, `I' is used for the range 1 to 8
   allowed as immediate shift counts and in addq.
   `J' is used for the range of signed numbers that fit in 16 bits.
   `K' is for numbers that moveq can't handle.
   `L' is for range -8 to -1, range of values that can be added with subq.  */

#define CONST_OK_FOR_LETTER_P(VALUE, C)  \
  ((C) == 'I' ? (VALUE) > 0 && (VALUE) <= 8 :    \
   (C) == 'J' ? (VALUE) >= -0x8000 && (VALUE) <= 0x7FFF :	\
   (C) == 'K' ? (VALUE) < -0x80 || (VALUE) >= 0x80 :	\
   (C) == 'L' ? (VALUE) < 0 && (VALUE) >= -8 : 0)

/*
 * A small bit of explanation:
 * "G" defines all of the floating constants that are *NOT* 68881
 * constants.  this is so 68881 constants get reloaded and the
 * fpmovecr is used.  "H" defines *only* the class of constants that
 * the fpa can use, because these can be gotten at in any fpa
 * instruction and there is no need to force reloads.
 */

#define CONST_DOUBLE_OK_FOR_LETTER_P(VALUE, C)  \
  ((C) == 'G' ? ! (TARGET_68881 && standard_68881_constant_p (VALUE)) : 0)

/* Given an rtx X being reloaded into a reg required to be
   in class CLASS, return the class of reg to actually use.
   In general this is just CLASS; but on some machines
   in some cases it is preferable to use a more restrictive class.
   On the 68000 series, use a data reg if possible when the
   value is a constant in the range where moveq could be used
   and we ensure that QImodes are reloaded into data regs.  */
#if (GNU_C_VERSION == 2)
#define PREFERRED_RELOAD_CLASS(X,CLASS)  \
  ((GET_CODE (X) == CONST_INT			\
    && (unsigned) (INTVAL (X) + 0x80) < 0x100	\
    && (CLASS) != ADDR_REGS)			\
   ? DATA_REGS					\
   : (GET_MODE (X) == QImode && (CLASS) != ADDR_REGS) \
   ? DATA_REGS					\
   : (GET_CODE (X) == CONST_DOUBLE		\
      && GET_MODE_CLASS (GET_MODE (X)) == MODE_FLOAT) \
   ? NO_REGS					\
   : (CLASS))
#else
#define PREFERRED_RELOAD_CLASS(X,CLASS)  \
  ((GET_CODE (X) == CONST_INT			\
    && (unsigned) (INTVAL (X) + 0x80) < 0x100	\
    && (CLASS) != ADDR_REGS)			\
   ? DATA_REGS					\
   : GET_MODE (X) == QImode			\
   ? DATA_REGS					\
   : (CLASS))
#endif

/* Return the maximum number of consecutive registers
   needed to represent mode MODE in a register of class CLASS.  */
/* On the 68000, this is the size of MODE in words,
   except in the FP regs, where a single reg is always enough.  */
#define CLASS_MAX_NREGS(CLASS, MODE)	\
 ((CLASS) == FP_REGS ? 1 \
  : ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD))

#if (GNU_C_VERSION == 2)
/* Moves between fp regs and other regs are two insns.  */
#define REGISTER_MOVE_COST(CLASS1, CLASS2)		\
  (((CLASS1) == FP_REGS && (CLASS2) != FP_REGS)	        \
    || ((CLASS2) == FP_REGS && (CLASS1) != FP_REGS)	\
    ? 4 : 2)
#endif

/* Stack layout; function entry, exit and calling.  */

/* Define this if pushing a word on the stack
   makes the stack pointer a smaller address.  */
#define STACK_GROWS_DOWNWARD

#if (GNU_C_VERSION == 2)
/* Nonzero if we need to generate stack-probe insns.
   On most systems they are not needed.
   When they are needed, define this as the stack offset to probe at.  */
#define NEED_PROBE 0
#endif

/* Define this if the nominal address of the stack frame
   is at the high-address end of the local variables;
   that is, each additional local variable allocated
   goes at a more negative offset in the frame.  */
#define FRAME_GROWS_DOWNWARD

/* Offset within stack frame to start allocating local variables at.
   If FRAME_GROWS_DOWNWARD, this is the offset to the END of the
   first local allocated.  Otherwise, it is the offset to the BEGINNING
   of the first local allocated.  */
#define STARTING_FRAME_OFFSET 0

/* If we generate an insn to push BYTES bytes,
   this says how many the stack pointer really advances by.
   On the 68000, sp@- in a byte insn really pushes a word.  */
#define PUSH_ROUNDING(BYTES) (((BYTES) + 1) & ~1)

/* Offset of first parameter from the argument pointer register value.  */
#define FIRST_PARM_OFFSET(FNDECL) 8

/* Value is 1 if returning from a function call automatically
   pops the arguments described by the number-of-args field in the call.
   FUNTYPE is the data type of the function (as a tree),
   or for a library call it is an identifier node for the subroutine name.

   On the 68000, the RTS insn cannot pop anything.
   On the 68010, the RTD insn may be used to pop them if the number
     of args is fixed, but if the number is variable then the caller
     must pop them all.  RTD can't be used for library calls now
     because the library is compiled with the Unix compiler.
   Use of RTD is a selectable option, since it is incompatible with
   standard Unix calling sequences.  If the option is not selected,
   the caller must always pop the args.  */
#if (GNU_C_VERSION == 2)
#define RETURN_POPS_ARGS(FUNTYPE,SIZE)   \
  ((TARGET_RTD && TREE_CODE (FUNTYPE) != IDENTIFIER_NODE	\
    && (TYPE_ARG_TYPES (FUNTYPE) == 0				\
	|| (TREE_VALUE (tree_last (TYPE_ARG_TYPES (FUNTYPE)))	\
	    == void_type_node)))				\
   ? (SIZE) : 0)
#else
#define RETURN_POPS_ARGS(FUNTYPE)   \
  (TARGET_RTD && TREE_CODE (FUNTYPE) != IDENTIFIER_NODE		\
   && (TYPE_ARG_TYPES (FUNTYPE) == 0				\
       || TREE_VALUE (tree_last (TYPE_ARG_TYPES (FUNTYPE))) == void_type_node))
#endif

/* Define how to find the value returned by a function.
   VALTYPE is the data type of the value (as a tree).
   If the precise function being called is known, FUNC is its FUNCTION_DECL;
   otherwise, FUNC is 0.  */

/* On the 68000 the return value is in D0 regardless.  */

#define FUNCTION_VALUE(VALTYPE, FUNC)  \
  gen_rtx (REG, TYPE_MODE (VALTYPE), 0)

/* Define how to find the value returned by a library function
   assuming the value has mode MODE.  */

/* On the 68000 the return value is in D0 regardless.  */

#define LIBCALL_VALUE(MODE)  gen_rtx (REG, MODE, 0)

/* 1 if N is a possible register number for a function value.
   On the 68000, d0 is the only register thus used.  */

#define FUNCTION_VALUE_REGNO_P(N) ((N) == 0)

/* Define this if PCC uses the nonreentrant convention for returning
   structure and union values.  */

#define PCC_STATIC_STRUCT_RETURN

/* 1 if N is a possible register number for function argument passing.
   On the 68000, no registers are used in this way.  */

#define FUNCTION_ARG_REGNO_P(N) 0

/* Define a data type for recording info about an argument list
   during the scan of that argument list.  This data type should
   hold all necessary information about the function itself
   and about the args processed so far, enough to enable macros
   such as FUNCTION_ARG to determine where the next arg should go.

   On the m68k, this is a single integer, which is a number of bytes
   of arguments scanned so far.  */

#define CUMULATIVE_ARGS int

/* Initialize a variable CUM of type CUMULATIVE_ARGS
   for a call to a function whose data type is FNTYPE.
   For a library call, FNTYPE is 0.

   On the m68k, the offset starts at 0.  */
#if (GNU_C_VERSION == 2)
#define INIT_CUMULATIVE_ARGS(CUM,FNTYPE,LIBNAME)	\
 ((CUM) = 0)
#else
#define INIT_CUMULATIVE_ARGS(CUM,FNTYPE)	\
 ((CUM) = 0)
#endif

/* Update the data in CUM to advance over an argument
   of mode MODE and data type TYPE.
   (TYPE is null for libcalls where that information may not be available.)  */

#define FUNCTION_ARG_ADVANCE(CUM, MODE, TYPE, NAMED)	\
 ((CUM) += ((MODE) != BLKmode			\
	    ? (GET_MODE_SIZE (MODE) + 3) & ~3	\
	    : (int_size_in_bytes (TYPE) + 3) & ~3))

/* Define where to put the arguments to a function.
   Value is zero to push the argument on the stack,
   or a hard register in which to store the argument.

   MODE is the argument's machine mode.
   TYPE is the data type of the argument (as a tree).
    This is null for libcalls where that information may
    not be available.
   CUM is a variable of type CUMULATIVE_ARGS which gives info about
    the preceding args and about the function being called.
   NAMED is nonzero if this argument is a named parameter
    (otherwise it is an extra parameter matching an ellipsis).  */

/* On the 68000 all args are pushed, except if -mregparm is specified
   then the first two words of arguments are passed in d0, d1.
   *NOTE* -mregparm does not work.
   It exists only to test register calling conventions.  */

#define FUNCTION_ARG(CUM, MODE, TYPE, NAMED) \
((TARGET_REGPARM && (CUM) < 8) ? gen_rtx (REG, (MODE), (CUM) / 4) : 0)

/* For an arg passed partly in registers and partly in memory,
   this is the number of registers used.
   For args passed entirely in registers or entirely in memory, zero.  */

#define FUNCTION_ARG_PARTIAL_NREGS(CUM, MODE, TYPE, NAMED) \
((TARGET_REGPARM && (CUM) < 8					\
  && 8 < ((CUM) + ((MODE) == BLKmode				\
		      ? int_size_in_bytes (TYPE)		\
		      : GET_MODE_SIZE (MODE))))  		\
 ? 2 - (CUM) / 4 : 0)

/* This macro generates the assembly code for function entry.
   FILE is a stdio stream to output the code to.
   SIZE is an int: how many units of temporary storage to allocate.
   Refer to the array `regs_ever_live' to determine which registers
   to save; `regs_ever_live[I]' is nonzero if register number I
   is ever used in the function.  This macro is responsible for
   knowing which registers should not be saved even if used.  */

/* Note that the order of the bit mask for fmovem is the opposite
   of the order for movem!  */
#if (GNU_C_VERSION == 2)
#define FUNCTION_PROLOGUE(FILE, SIZE)				\
{ register int regno;						\
  register int mask = 0;					\
  char reglist[64];						\
  register char *p, *r;						\
  extern char call_used_regs[];					\
  extern char global_regs[];					\
  int fsize = (SIZE + 1) & -2;					\
  if (frame_pointer_needed)					\
    {								\
      if (TARGET_68020 || fsize < 0x8000)			\
        fprintf (FILE, "\tlink %s,#%d\n",			\
        	reg_names[FRAME_POINTER_REGNUM], -fsize);	\
      else							\
       { 							\
	fprintf (FILE, "\tlink %s,#0\n\tsub.l #%d,sp\n",	\
		reg_names[FRAME_POINTER_REGNUM], fsize); }}	\
  mask = 0; p = reglist; *p = 0;				\
  for (regno = 16; regno < 24; regno++)				\
    if (regs_ever_live[regno] && ! call_used_regs[regno])	\
      {								\
        mask = 1;						\
        r = reg_names[regno];					\
        if (reglist[0]) *p ++ = '/';				\
        *p ++ = *r ++;						\
        *p ++ = *r ++;						\
        *p ++ = *r ++;}						\
  *p = 0;							\
  if (mask)							\
    fprintf (FILE, "\tfmovem.x %s,-(sp)\n", reglist);	        \
  mask = 0;							\
  for ((p = reglist)[0] = 0, regno = 0; regno < 16; regno++)	\
    if (regs_ever_live[regno] && !call_used_regs[regno]		\
        && !global_regs[regno]					\
        && regno != STACK_POINTER_REGNUM)			\
       { mask |= 1 << (15 - regno);				\
	 if (!frame_pointer_needed || regno != FRAME_POINTER_REGNUM)	\
	    { r = reg_names[regno];				\
	      if (reglist[0])					\
	         *p++ = '/';					\
	      *p++ = *r++;					\
	      *p++ = *r++; }}					\
  *p = 0;							\
  if (frame_pointer_needed)					\
    mask &= ~ (1 << (15-FRAME_POINTER_REGNUM));			\
  if (exact_log2 (mask) >= 0)					\
    fprintf (FILE, "\tmove.l %s,-(sp)\n", reg_names[15 - exact_log2 (mask)]);  \
  else if (mask) fprintf (FILE, "\tmovem.l %s,-(sp)\n", reglist); }
#else
#define FUNCTION_PROLOGUE(FILE, SIZE)				\
{ register int regno;						\
  register int mask = 0;					\
  char reglist[64];						\
  register char *p, *r;						\
  extern int flag_interrupt;					\
  extern int flag_stack_check;					\
  extern int flag_call_seen;					\
  extern char call_used_regs[];					\
  extern char global_regs[];					\
  extern char inter_use_regs[];					\
  int fsize = (SIZE + 1) & -2;					\
  target_cpu ((FILE));						\
  if (flag_stack_check && (!flag_interrupt)) {			\
  	fprintf (FILE,"\t___STACK_CHK\t%d\n",fsize);		\
  }								\
  if (flag_interrupt==3) {					\
  	fprintf (FILE,"\tsubq.w #4,sp\n");			\
  }								\
  if (current_function_pretend_args_size) {			\
  	fprintf(FILE,"\tsubq.w #8,sp\n");			\
  	fprintf(FILE,"\tmove.l 8(sp),(sp)\n");			\
  }								\
  if (frame_pointer_needed)					\
    { if (fsize >= 0x8000)					\
	message ("stack frameが32kバイトを越えました\n"		\
	         "\x1b""1");					\
      if (TARGET_68020 || fsize < 0x8000)			\
        fprintf (FILE, "\tlink %s,#%d\n",			\
        	reg_names[FRAME_POINTER_REGNUM], -fsize);	\
      else							\
       { 							\
	fprintf (FILE, "\tlink %s,#0\n\tsub.l #%d,sp\n",	\
		reg_names[FRAME_POINTER_REGNUM], fsize); }}	\
  mask = 0; p = reglist; *p = 0;				\
  for (regno = 16; regno < 24; regno++)				\
    if (regs_ever_live[regno] && ! call_used_regs[regno])	\
      {								\
        mask = 1;						\
        r = reg_names[regno];					\
        if (reglist[0]) *p ++ = '/';				\
        *p ++ = *r ++;						\
        *p ++ = *r ++;						\
        *p ++ = *r ++;}						\
  *p = 0;							\
  if (mask)							\
    fprintf (FILE, "\tfmovem.x %s,-(sp)\n", reglist);	        \
  mask = 0;							\
  for ((p = reglist)[0] = 0, regno = 0; regno < 16; regno++)	\
    if ((regs_ever_live[regno] && ! call_used_regs[regno]	\
         && !flag_interrupt) ||					\
        (flag_interrupt						\
        && (flag_call_seen ? (call_used_regs[regno] || regs_ever_live[regno]) \
        	: regs_ever_live[regno])			\
        && !global_regs[regno]					\
        && regno != STACK_POINTER_REGNUM			\
        && !inter_use_regs[regno]))				\
       { mask |= 1 << (15 - regno);				\
	 if (!frame_pointer_needed || regno != FRAME_POINTER_REGNUM)	\
	    { r = reg_names[regno];				\
	      if (reglist[0])					\
	         *p++ = '/';					\
	      *p++ = *r++;					\
	      *p++ = *r++; }}					\
  *p = 0;							\
  if (frame_pointer_needed)					\
    mask &= ~ (1 << (15-FRAME_POINTER_REGNUM));			\
  if (exact_log2 (mask) >= 0)					\
    fprintf (FILE, "\tmove.l %s,-(sp)\n", reg_names[15 - exact_log2 (mask)]);  \
  else if (mask) fprintf (FILE, "\tmovem.l %s,-(sp)\n", reglist); }
#endif

/* Output assembler code to FILE to increment profiler label # LABELNO
   for profiling a function entry.  */

#define FUNCTION_PROFILER(FILE, LABEL_NO)	\
  fprintf (FILE,"\tlea ?P%d,a2\n\tjsr ___ftime_start\n",(LABEL_NO))

#define FUNCTION_PROFILER_END(FILE, LABEL_NO)	\
  fprintf (FILE,"\tlea ?P%d,a2\n\tjsr ___ftime_end\n",(LABEL_NO))

/* Output assembler code to FILE to initialize this source file's
   basic block profiling info, if that has not already been done.  */
#if (GNU_C_VERSION == 2)
#define FUNCTION_BLOCK_PROFILER(FILE, LABELNO)	\
  fprintf (FILE, "\ttst.l LPBX0\n\tbne LPI%d\n\tpea LPBX0\n\tjsr ___bb_init_func\n\taddq.w #4,sp\nLPI%d:\n" \
  ,(LABELNO),(LABELNO))
#else
#define FUNCTION_BLOCK_PROFILER(FILE, LABELNO)	\
  fprintf (FILE, "\ttst.l ?PBX0\n\tbne ?PI%d\n\tpea ?PBX0\n\tjsr ___bb_init_func\n\taddq.w #4,sp\n?PI%d:\n" \
  ,(LABELNO),(LABELNO))
#endif

/* Output assembler code to FILE to increment the entry-count for
   the BLOCKNO'th basic block in this source file.  */
#if (GNU_C_VERSION == 2)
#define BLOCK_PROFILER(FILE,BLOCKNO)	\
  fprintf (FILE, "\taddq.l #1,LPBX2+%d\n", 4 * (BLOCKNO))
#else
#define BLOCK_PROFILER(FILE,BLOCKNO)	\
  fprintf (FILE, "\taddq.l #1,?PBX2+%d\n", 4 * (BLOCKNO))
#endif

/* EXIT_IGNORE_STACK should be nonzero if, when returning from a function,
   the stack pointer does not matter.  The value is tested only in
   functions that have frame pointers.
   No definition is equivalent to always zero.  */

#define EXIT_IGNORE_STACK 1

/* This macro generates the assembly code for function exit,
   on machines that need it.  If FUNCTION_EPILOGUE is not defined
   then individual return instructions are generated for each
   return statement.  Args are same as for FUNCTION_PROLOGUE.

   The function epilogue should not depend on the current stack pointer!
   It should use the frame pointer only.  This is mandatory because
   of alloca; we also take advantage of it to omit stack adjustments
   before returning.  */
#if (GNU_C_VERSION == 2)
#define FUNCTION_EPILOGUE(FILE, SIZE) \
{ register int regno;						\
  register int mask;						\
  register int fmask;						\
  register int nregs;						\
  static short dummy_output = 0;				\
  int offset, foffset;						\
  char reglist[64];						\
  char freglist[64];						\
  register char *p, *r;						\
  extern char call_used_regs[];					\
  extern char global_regs[];					\
  extern int current_function_pops_args;			\
  extern int current_function_args_size;			\
  extern int flag_interrupt;					\
  extern int flag_call_seen;					\
  extern rtx interrupt_rtx;					\
  int fsize = (SIZE + 1) & -2;					\
  int big = 0;							\
  FUNCTION_EXTRA_EPILOGUE (FILE, SIZE);				\
  foffset = 0;							\
  nregs = fmask = 0;p = freglist; *p = 0;			\
  for (regno = 16; regno < 24; regno++)				\
    if (regs_ever_live[regno] && ! call_used_regs[regno])	\
      { nregs++; fmask = 1; r = reg_names[regno];		\
      	if (freglist[0])  *p ++ = '/';				\
      	*p ++ = *r ++;						\
      	*p ++ = *r ++;						\
      	*p ++ = *r ++;						\
      }								\
  *p = 0;foffset = nregs * 12;					\
  nregs = 0;  mask = 0;						\
  if (frame_pointer_needed) regs_ever_live[FRAME_POINTER_REGNUM] = 0; \
  for ((p = reglist)[0] = 0, regno = 0; regno < 16; regno++)	\
    if (regs_ever_live[regno]					\
        && !call_used_regs[regno]				\
        && !global_regs[regno]					\
        && regno != STACK_POINTER_REGNUM)			\
      { nregs++; mask |= 1 << regno;				\
	if (!frame_pointer_needed || regno != FRAME_POINTER_REGNUM)	\
	   { r = reg_names[regno];					\
	     if (reglist[0])					\
	        *p++ = '/';					\
	     *p++ = *r++;					\
	     *p++ = *r++; }}					\
  *p = 0;							\
  offset = foffset + nregs * 4;					\
  if (offset + fsize >= 0x8000 && frame_pointer_needed && mask) \
    { fprintf (FILE, "\tmove.l #%d,a0\n", -fsize);		\
      fsize = 0, big = 1; }					\
  if (exact_log2 (mask) >= 0) {					\
    if (big)							\
      fprintf (FILE, "\tmove.l -%d(%s,a0.l),%s\n",		\
	       offset,reg_names[FRAME_POINTER_REGNUM],		\
	        reg_names[exact_log2 (mask)]);			\
    else if (! frame_pointer_needed)				\
      fprintf (FILE, "\tmove.l (sp)+,%s\n",			\
	       reg_names[exact_log2 (mask)]);			\
    else							\
      fprintf (FILE, "\tmove.l -%d(%s),%s\n",			\
	       offset + fsize, reg_names[FRAME_POINTER_REGNUM],	\
	       reg_names[exact_log2 (mask)]); }			\
  else if (mask) {						\
    if (big)							\
      fprintf (FILE, "\tmovem.l -%d(%s,a0.l),%s\n",		\
	       offset,reg_names[FRAME_POINTER_REGNUM],		\
	        reglist);					\
    else if (!frame_pointer_needed)				\
      fprintf (FILE, "\tmovem.l (sp)+,%s\n", reglist);		\
    else							\
      fprintf (FILE, "\tmovem.l -%d(%s),%s\n",			\
	       offset + fsize,reg_names[FRAME_POINTER_REGNUM],	\
	        reglist); }					\
  if (fmask) {							\
    if (big)							\
      fprintf (FILE, "\tfmovem.x -%d(%s,a0.l),%s\n",		\
	     foffset,reg_names[FRAME_POINTER_REGNUM],freglist);	\
    else if (!frame_pointer_needed)				\
      fprintf (FILE, "\tfmovem.x (sp)+,%s\n", freglist);	\
    else							\
      fprintf (FILE, "\tfmovem.x -%d(%s),%s\n",			\
	       foffset + fsize,reg_names[FRAME_POINTER_REGNUM],	\
	        freglist); }					\
  if (frame_pointer_needed)					\
    fprintf (FILE, "\tunlk %s\n",				\
    	reg_names[FRAME_POINTER_REGNUM]);			\
  fprintf (FILE, "\trts\n");					\
}
#else
#define FUNCTION_EPILOGUE(FILE, SIZE) \
{ register int regno;						\
  register int mask;						\
  register int fmask;						\
  register int nregs;						\
  static short dummy_output = 0;				\
  int offset, foffset;						\
  char reglist[64];						\
  char freglist[64];						\
  register char *p, *r;						\
  extern char call_used_regs[];					\
  extern char global_regs[];					\
  extern char inter_use_regs[];					\
  extern int current_function_pops_args;			\
  extern int current_function_args_size;			\
  extern int flag_interrupt;					\
  extern int flag_call_seen;					\
  extern rtx interrupt_rtx;					\
  int fsize = (SIZE + 1) & -2;					\
  int big = 0;							\
  FUNCTION_EXTRA_EPILOGUE (FILE, SIZE);				\
  foffset = 0;							\
  nregs = fmask = 0;p = freglist; *p = 0;			\
  for (regno = 16; regno < 24; regno++)				\
    if (regs_ever_live[regno] && ! call_used_regs[regno])	\
      { nregs++; fmask = 1; r = reg_names[regno];		\
      	if (freglist[0])  *p ++ = '/';				\
      	*p ++ = *r ++;						\
      	*p ++ = *r ++;						\
      	*p ++ = *r ++;						\
      }								\
  *p = 0;foffset = nregs * 12;					\
  nregs = 0;  mask = 0;						\
  if (frame_pointer_needed) regs_ever_live[FRAME_POINTER_REGNUM] = 0; \
  for ((p = reglist)[0] = 0, regno = 0; regno < 16; regno++)	\
    if ((regs_ever_live[regno] && ! call_used_regs[regno]	\
        && !flag_interrupt) ||		\
        ( flag_interrupt &&			\
        ( flag_call_seen ? ( call_used_regs[regno] || regs_ever_live[regno])	\
           : regs_ever_live[regno] )				\
        && !global_regs[regno]					\
        && regno != STACK_POINTER_REGNUM && !inter_use_regs[regno]))	\
      { nregs++; mask |= 1 << regno;				\
	if (!frame_pointer_needed || regno != FRAME_POINTER_REGNUM)	\
	   { r = reg_names[regno];					\
	     if (reglist[0])					\
	        *p++ = '/';					\
	     *p++ = *r++;					\
	     *p++ = *r++; }}					\
  *p = 0;flag_call_seen = 0;					\
  offset = foffset + nregs * 4;					\
  if (offset + fsize >= 0x8000 && frame_pointer_needed && mask) \
    { fprintf (FILE, "\tmove.l #%d,a0\n", -fsize);		\
      fsize = 0, big = 1; }					\
  if (exact_log2 (mask) >= 0) {					\
    if (big)							\
      fprintf (FILE, "\tmove.l -%d(%s,a0.l),%s\n",		\
	       offset,reg_names[FRAME_POINTER_REGNUM],		\
	        reg_names[exact_log2 (mask)]);			\
    else if (! frame_pointer_needed)				\
      fprintf (FILE, "\tmove.l (sp)+,%s\n",			\
	       reg_names[exact_log2 (mask)]);			\
    else							\
      fprintf (FILE, "\tmove.l -%d(%s),%s\n",			\
	       offset + fsize, reg_names[FRAME_POINTER_REGNUM],	\
	       reg_names[exact_log2 (mask)]); }			\
  else if (mask) {						\
    if (big)							\
      fprintf (FILE, "\tmovem.l -%d(%s,a0.l),%s\n",		\
	       offset,reg_names[FRAME_POINTER_REGNUM],		\
	        reglist);					\
    else if (! frame_pointer_needed)				\
      fprintf (FILE, "\tmovem.l (sp)+,%s\n", reglist);		\
    else							\
      fprintf (FILE, "\tmovem.l -%d(%s),%s\n",			\
	       offset + fsize,reg_names[FRAME_POINTER_REGNUM],	\
	        reglist); }					\
  if (fmask) {							\
    if (big)							\
      fprintf (FILE, "\tfmovem.x -%d(%s,a0.l),%s\n",		\
	     foffset,reg_names[FRAME_POINTER_REGNUM],freglist);	\
    else if (! frame_pointer_needed)				\
      fprintf (FILE, "\tfmovem.x (sp)+,%s\n", freglist);	\
    else							\
      fprintf (FILE, "\tfmovem.x -%d(%s),%s\n",			\
	       foffset + fsize,reg_names[FRAME_POINTER_REGNUM],	\
	        freglist); }					\
  if (frame_pointer_needed)					\
    fprintf (FILE, "\tunlk %s\n",				\
    	reg_names[FRAME_POINTER_REGNUM]);			\
  if (flag_interrupt ==1 ) {					\
  	 fprintf (FILE, "\trte\n");				\
  } else							\
  if (flag_interrupt ==3) {					\
  	 fprintf (FILE, "\trts\n");				\
         if (!dummy_output) {					\
         	fprintf (FILE,"___builtin_saveregs:\n");	\
         	fprintf (FILE,"\trte\n");			\
         	dummy_output = 1;				\
         }							\
  } else							\
  if (current_function_pretend_args_size) {			\
  	fprintf(FILE,"\tmove.l (sp),a0\n");			\
  	fprintf(FILE,"\tlea 12(sp),sp\n");			\
  	fprintf(FILE,"\tjmp (a0)\n");				\
  } else							\
  	 fprintf (FILE, "\trts\n");				\
  flag_interrupt = 0;}
#endif

/* This is a hook for other tm files to change.  */
#if (GNU_C_VERSION == 2)
#define FUNCTION_EXTRA_EPILOGUE(FILE, SIZE)
#else
#define FUNCTION_EXTRA_EPILOGUE(FILE, SIZE)
#endif

#if (GNU_C_VERSION == 2)

/* Determine if the epilogue should be output as RTL.
   You should override this if you define FUNCTION_EXTRA_EPILOGUE.  */
#define USE_RETURN_INSN use_return_insn ()
/* Store in the variable DEPTH the initial difference between the
   frame pointer reg contents and the stack pointer reg contents,
   as of the start of the function body.  This depends on the layout
   of the fixed parts of the stack frame and on how registers are saved.

   On the 68k, if we have a frame, we must add one word to its length
   to allow for the place that a6 is stored when we do have a frame pointer.
   Otherwise, we would need to compute the offset from the frame pointer
   of a local variable as a function of frame_pointer_needed, which
   is hard.  */

#define INITIAL_FRAME_POINTER_OFFSET(DEPTH)			\
{ int regno;							\
  int offset = -4;						\
  for (regno = 16; regno < FIRST_PSEUDO_REGISTER; regno++)	\
    if (regs_ever_live[regno] && ! call_used_regs[regno])	\
      offset += 12;						\
  for (regno = 0; regno < 16; regno++)				\
    if (regs_ever_live[regno] && ! call_used_regs[regno])	\
      offset += 4;						\
  (DEPTH) = (offset + ((get_frame_size () + 3) & -4)		\
	     + (get_frame_size () == 0 ? 0 : 4));		\
}

/* Output assembler code for a block containing the constant parts
   of a trampoline, leaving space for the variable parts.  */

/* On the 68k, the trampoline looks like this:
     mov  @#.,a0
     jsr  @#___trampoline
     jsr  @#___trampoline
     .long STATIC
     .long FUNCTION
The reason for having three jsr insns is so that an entire line
of the instruction cache is filled in a predictable way
that will always be the same.

We always use the assembler label ___trampoline
regardless of whether the system adds underscores.  */

#define TRAMPOLINE_TEMPLATE(FILE)					\
{									\
  ASM_OUTPUT_SHORT (FILE, gen_rtx (CONST_INT, VOIDmode, 0x207c));	\
  ASM_OUTPUT_SHORT (FILE, const0_rtx);					\
  ASM_OUTPUT_SHORT (FILE, const0_rtx);					\
  ASM_OUTPUT_SHORT (FILE, gen_rtx (CONST_INT, VOIDmode, 0x4eb9));	\
  ASM_OUTPUT_INT (FILE, gen_rtx (SYMBOL_REF, SImode, "*___trampoline"));\
  ASM_OUTPUT_SHORT (FILE, gen_rtx (CONST_INT, VOIDmode, 0x4eb9));	\
  ASM_OUTPUT_INT (FILE, gen_rtx (SYMBOL_REF, SImode, "*___trampoline"));\
  ASM_OUTPUT_SHORT (FILE, const0_rtx);					\
  ASM_OUTPUT_SHORT (FILE, const0_rtx);					\
  ASM_OUTPUT_SHORT (FILE, const0_rtx);					\
  ASM_OUTPUT_SHORT (FILE, const0_rtx);					\
}

/* Length in units of the trampoline for entering a nested function.  */

#define TRAMPOLINE_SIZE 26

/* Alignment required for a trampoline.  16 is used to find the
   beginning of a line in the instruction cache.  */

#define TRAMPOLINE_ALIGN 16

/* Emit RTL insns to initialize the variable parts of a trampoline.
   FNADDR is an RTX for the address of the function's pure code.
   CXT is an RTX for the static chain value for the function.  */

#define INITIALIZE_TRAMPOLINE(TRAMP, FNADDR, CXT)			\
{									\
  emit_move_insn (gen_rtx (MEM, SImode, plus_constant (TRAMP, 2)), TRAMP); \
  emit_move_insn (gen_rtx (MEM, SImode, plus_constant (TRAMP, 18)), CXT); \
  emit_move_insn (gen_rtx (MEM, SImode, plus_constant (TRAMP, 22)), FNADDR); \
}

/* This is the library routine that is used
   to transfer control from the trampoline
   to the actual nested function.  */

/* A colon is used with no explicit operands
   to cause the template string to be scanned for %-constructs.  */
/* The function name __transfer_from_trampoline is not actually used.
   The function definition just permits use of "asm with operands"
   (though the operand list is empty).  */
#define TRANSFER_FROM_TRAMPOLINE				\
void								\
__transfer_from_trampoline ()					\
{								\
  register char *a0 asm ("%a0");				\
  asm (GLOBAL_ASM_OP " ___trampoline");				\
  asm ("___trampoline:");					\
  asm volatile ("move%.l %0,%@" : : "m" (a0[22]));		\
  asm volatile ("move%.l %1,%0" : "=a" (a0) : "m" (a0[18]));	\
  asm ("rts":);							\
}

#endif

/* If the memory address ADDR is relative to the frame pointer,
   correct it to be relative to the stack pointer instead.
   This is for when we don't use a frame pointer.
   ADDR should be a variable name.  */

#define FIX_FRAME_POINTER_ADDRESS(ADDR,DEPTH)  \
{ int offset = -1;							\
  rtx regs = stack_pointer_rtx;						\
  if (ADDR == frame_pointer_rtx)					\
    offset = 0;								\
  else if (GET_CODE (ADDR) == PLUS && XEXP (ADDR, 0) == frame_pointer_rtx \
	   && GET_CODE (XEXP (ADDR, 1)) == CONST_INT)			\
    offset = INTVAL (XEXP (ADDR, 1));					\
  else if (GET_CODE (ADDR) == PLUS && XEXP (ADDR, 0) == frame_pointer_rtx) \
    { rtx other_reg = XEXP (ADDR, 1);					\
      offset = 0;							\
      regs = gen_rtx (PLUS, Pmode, stack_pointer_rtx, other_reg); }	\
  else if (GET_CODE (ADDR) == PLUS && XEXP (ADDR, 1) == frame_pointer_rtx) \
    { rtx other_reg = XEXP (ADDR, 0);					\
      offset = 0;							\
      regs = gen_rtx (PLUS, Pmode, stack_pointer_rtx, other_reg); }	\
  else if (GET_CODE (ADDR) == PLUS					\
	   && GET_CODE (XEXP (ADDR, 0)) == PLUS				\
	   && XEXP (XEXP (ADDR, 0), 0) == frame_pointer_rtx		\
	   && GET_CODE (XEXP (ADDR, 1)) == CONST_INT)			\
    { rtx other_reg = XEXP (XEXP (ADDR, 0), 1);				\
      offset = INTVAL (XEXP (ADDR, 1));					\
      regs = gen_rtx (PLUS, Pmode, stack_pointer_rtx, other_reg); }	\
  else if (GET_CODE (ADDR) == PLUS					\
	   && GET_CODE (XEXP (ADDR, 0)) == PLUS				\
	   && XEXP (XEXP (ADDR, 0), 1) == frame_pointer_rtx		\
	   && GET_CODE (XEXP (ADDR, 1)) == CONST_INT)			\
    { rtx other_reg = XEXP (XEXP (ADDR, 0), 0);				\
      offset = INTVAL (XEXP (ADDR, 1));					\
      regs = gen_rtx (PLUS, Pmode, stack_pointer_rtx, other_reg); }	\
  if (offset >= 0)							\
    { int regno;							\
      extern char call_used_regs[];					\
      extern int flag_interrupt;					\
      extern int flag_call_seen;					\
      for (regno = 16; regno < FIRST_PSEUDO_REGISTER; regno++)		\
        if (regs_ever_live[regno] && ! call_used_regs[regno])		\
          offset += 12;							\
      for (regno = 0; regno < 16; regno++)				\
	if ((regs_ever_live[regno] && ! call_used_regs[regno] && !flag_interrupt) \
	 || (flag_interrupt && regno !=STACK_POINTER_REGNUM		\
	   && (flag_call_seen ? (regs_ever_live[regno] || call_used_regs[regno]) \
	          : regs_ever_live[regno])				\
	   && !global_regs[regno]					\
	   && !inter_use_regs[regno]))					\
	  offset += 4;							\
      offset -= 4;							\
      ADDR = plus_constant (regs, offset + (DEPTH)); } }		\

/* Addressing modes, and classification of registers for them.  */

#define HAVE_POST_INCREMENT
/* #define HAVE_POST_DECREMENT */

#define HAVE_PRE_DECREMENT
/* #define HAVE_PRE_INCREMENT */

/* Macros to check register numbers against specific register classes.  */

/* These assume that REGNO is a hard or pseudo reg number.
   They give nonzero only if REGNO is a hard reg of the suitable class
   or a pseudo reg currently allocated to a suitable hard reg.
   Since they use reg_renumber, they are safe only once reg_renumber
   has been allocated, which happens in local-alloc.c.  */

#define REGNO_OK_FOR_INDEX_P(REGNO) \
((REGNO) < 16 || (unsigned) reg_renumber[REGNO] < 16)
#define REGNO_OK_FOR_BASE_P(REGNO) \
(((REGNO) ^ 010) < 8 || (unsigned) (reg_renumber[REGNO] ^ 010) < 8)
#define REGNO_OK_FOR_DATA_P(REGNO) \
((REGNO) < 8 || (unsigned) reg_renumber[REGNO] < 8)
#define REGNO_OK_FOR_FP_P(REGNO) \
(((REGNO) ^ 020) < 8 || (unsigned) (reg_renumber[REGNO] ^ 020) < 8)
#define REGNO_OK_FOR_FPA_P(REGNO) \
(((REGNO) >= 24 && (REGNO) < 56) || (reg_renumber[REGNO] >= 24 && reg_renumber[REGNO] < 56))

/* Now macros that check whether X is a register and also,
   strictly, whether it is in a specified class.

   These macros are specific to the 68000, and may be used only
   in code for printing assembler insns and in conditions for
   define_optimization.  */

/* 1 if X is a data register.  */

#define DATA_REG_P(X) (REG_P (X) && REGNO_OK_FOR_DATA_P (REGNO (X)))

/* 1 if X is an fp register.  */

#define FP_REG_P(X) (REG_P (X) && REGNO_OK_FOR_FP_P (REGNO (X)))

/* 1 if X is an address register  */

#define ADDRESS_REG_P(X) (REG_P (X) && REGNO_OK_FOR_BASE_P (REGNO (X)))

/* 1 if X is a register in the Sun FPA.  */
#define FPA_REG_P(X) 0

/* Maximum number of registers that can appear in a valid memory address.  */
#define MAX_REGS_PER_ADDRESS 2

/* Recognize any constant value that is a valid address.  */

#define CONSTANT_ADDRESS_P(X)  CONSTANT_P (X)

/* Nonzero if the constant value X is a legitimate general operand.
   It is given that X satisfies CONSTANT_P or is a CONST_DOUBLE.  */

#define LEGITIMATE_CONSTANT_P(X) 1

#if (GNU_C_VERSION == 2)
/* Nonzero if the constant value X is a legitimate general operand
   when generating PIC code.  It is given that flag_pic is on and 
   that X satisfies CONSTANT_P or is a CONST_DOUBLE.  */

#define LEGITIMATE_PIC_OPERAND_P(X)	\
  (! symbolic_operand (X, VOIDmode))
#endif

/* The macros REG_OK_FOR..._P assume that the arg is a REG rtx
   and check its validity for a certain class.
   We have two alternate definitions for each of them.
   The usual definition accepts all pseudo regs; the other rejects
   them unless they have been allocated suitable hard regs.
   The symbol REG_OK_STRICT causes the latter definition to be used.

   Most source files want to accept pseudo regs in the hope that
   they will get allocated to the class that the insn wants them to be in.
   Source files for reload pass need to be strict.
   After reload, it makes no difference, since pseudo regs have
   been eliminated by then.  */

#ifndef REG_OK_STRICT
#define GO_IF_MEMORY_INDIRECT_ADDRESS(MODE, X, ADDR)		\
{ if (memory_indirect_address_p ((X), 0)) goto ADDR; }
/* Nonzero if X is a hard reg that can be used as an index
   or if it is a pseudo reg.  */
#define REG_OK_FOR_INDEX_P(X) ((REGNO (X) ^ 020) >= 8)
/* Nonzero if X is a hard reg that can be used as a base reg
   or if it is a pseudo reg.  */
#define REG_OK_FOR_BASE_P(X) ((REGNO (X) & ~027) != 0)

#else
#define GO_IF_MEMORY_INDIRECT_ADDRESS(MODE, X, ADDR)		\
{ if (memory_indirect_address_p ((X), 1)) goto ADDR; }
/* Nonzero if X is a hard reg that can be used as an index.  */
#define REG_OK_FOR_INDEX_P(X) REGNO_OK_FOR_INDEX_P (REGNO (X))
/* Nonzero if X is a hard reg that can be used as a base reg.  */
#define REG_OK_FOR_BASE_P(X) REGNO_OK_FOR_BASE_P (REGNO (X))

#endif

#if (GNU_C_VERSION == 2)
/* GO_IF_LEGITIMATE_ADDRESS recognizes an RTL expression
   that is a valid memory address for an instruction.
   The MODE argument is the machine mode for the MEM expression
   that wants to use this address.

   When generating PIC, an address involving a SYMBOL_REF is legitimate
   if and only if it is the sum of pic_offset_table_rtx and the SYMBOL_REF.
   We use LEGITIMATE_PIC_OPERAND_P to throw out the illegitimate addresses,
   and we explicitly check for the sum of pic_offset_table_rtx and a SYMBOL_REF.

   Likewise for a LABEL_REF when generating PIC.

   The other macros defined here are used only in GO_IF_LEGITIMATE_ADDRESS.  */

#define INDIRECTABLE_1_ADDRESS_P(X)  \
  ((CONSTANT_ADDRESS_P (X) && (!flag_pic || LEGITIMATE_PIC_OPERAND_P (X))) \
   || (GET_CODE (X) == REG && REG_OK_FOR_BASE_P (X))			\
   || ((GET_CODE (X) == PRE_DEC || GET_CODE (X) == POST_INC)		\
       && REG_P (XEXP (X, 0))						\
       && REG_OK_FOR_BASE_P (XEXP (X, 0)))				\
   || (GET_CODE (X) == PLUS						\
       && REG_P (XEXP (X, 0)) && REG_OK_FOR_BASE_P (XEXP (X, 0))	\
       && GET_CODE (XEXP (X, 1)) == CONST_INT				\
       && ((unsigned) INTVAL (XEXP (X, 1)) + 0x8000) < 0x10000)		\
   || (GET_CODE (X) == PLUS && XEXP (X, 0) == pic_offset_table_rtx 	\
       && flag_pic && GET_CODE (XEXP (X, 1)) == SYMBOL_REF)		\
   || (GET_CODE (X) == PLUS && XEXP (X, 0) == pic_offset_table_rtx 	\
       && flag_pic && GET_CODE (XEXP (X, 1)) == LABEL_REF))		\

#if 0
/* This should replace the last two (non-pic) lines
   except that Sun's assembler does not seem to handle such operands.  */
       && (TARGET_68020 ? CONSTANT_ADDRESS_P (XEXP (X, 1))		\
	   : (GET_CODE (XEXP (X, 1)) == CONST_INT			\
	      && ((unsigned) INTVAL (XEXP (X, 1)) + 0x8000) < 0x10000))))
#endif


#define GO_IF_NONINDEXED_ADDRESS(X, ADDR)  \
{ if (INDIRECTABLE_1_ADDRESS_P (X)) goto ADDR; }

/* Only labels on dispatch tables are valid for indexing from.  */
#define GO_IF_INDEXABLE_BASE(X, ADDR)				\
{ rtx temp;							\
  if (GET_CODE (X) == LABEL_REF					\
      && (temp = next_nonnote_insn (XEXP (X, 0))) != 0		\
      && GET_CODE (temp) == JUMP_INSN				\
      && (GET_CODE (PATTERN (temp)) == ADDR_VEC			\
	  || GET_CODE (PATTERN (temp)) == ADDR_DIFF_VEC))	\
    goto ADDR;							\
  if (GET_CODE (X) == REG && REG_OK_FOR_BASE_P (X)) goto ADDR; }

#define GO_IF_INDEXING(X, ADDR)	\
{ if (GET_CODE (X) == PLUS && LEGITIMATE_INDEX_P (XEXP (X, 0)))		\
    { GO_IF_INDEXABLE_BASE (XEXP (X, 1), ADDR); }			\
  if (GET_CODE (X) == PLUS && LEGITIMATE_INDEX_P (XEXP (X, 1)))		\
    { GO_IF_INDEXABLE_BASE (XEXP (X, 0), ADDR); } }

#define GO_IF_INDEXED_ADDRESS(X, ADDR)	 \
{ GO_IF_INDEXING (X, ADDR);						\
  if (GET_CODE (X) == PLUS)						\
    { if (GET_CODE (XEXP (X, 1)) == CONST_INT				\
	  && (unsigned) INTVAL (XEXP (X, 1)) + 0x80 < 0x100)		\
	{ rtx go_temp = XEXP (X, 0); GO_IF_INDEXING (go_temp, ADDR); }	\
      if (GET_CODE (XEXP (X, 0)) == CONST_INT				\
	  && (unsigned) INTVAL (XEXP (X, 0)) + 0x80 < 0x100)		\
	{ rtx go_temp = XEXP (X, 1); GO_IF_INDEXING (go_temp, ADDR); } } }

#define LEGITIMATE_INDEX_REG_P(X)   \
  ((GET_CODE (X) == REG && REG_OK_FOR_INDEX_P (X))	\
   || (GET_CODE (X) == SIGN_EXTEND			\
       && GET_CODE (XEXP (X, 0)) == REG			\
       && GET_MODE (XEXP (X, 0)) == HImode		\
       && REG_OK_FOR_INDEX_P (XEXP (X, 0))))

#define LEGITIMATE_INDEX_P(X)   \
   (LEGITIMATE_INDEX_REG_P (X)				\
    || (TARGET_68020 && GET_CODE (X) == MULT		\
	&& LEGITIMATE_INDEX_REG_P (XEXP (X, 0))		\
	&& GET_CODE (XEXP (X, 1)) == CONST_INT		\
	&& (INTVAL (XEXP (X, 1)) == 2			\
	    || INTVAL (XEXP (X, 1)) == 4		\
	    || INTVAL (XEXP (X, 1)) == 8)))

#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, ADDR)  \
{ GO_IF_NONINDEXED_ADDRESS (X, ADDR);			\
  GO_IF_INDEXED_ADDRESS (X, ADDR); }

#else /* GNU_C_VERSION == 2 */

/* GO_IF_LEGITIMATE_ADDRESS recognizes an RTL expression
   that is a valid memory address for an instruction.
   The MODE argument is the machine mode for the MEM expression
   that wants to use this address.

   The other macros defined here are used only in GO_IF_LEGITIMATE_ADDRESS.  */

#define CONST_PLUS_OK_ADDR(X)	\
  (GET_CODE (X) == CONST							\
   && GET_CODE (XEXP (X, 0)) == PLUS						\
   && ((GET_CODE (XEXP (XEXP (X, 0), 0)) == SYMBOL_REF				\
	 && ! MEM_IN_REMOTE (XEXP (XEXP (X, 0), 0))				\
	 && GET_CODE (XEXP (XEXP (X, 0), 1)) == CONST_INT			\
	 && INTVAL (XEXP (XEXP (X, 0), 1)) > 0					\
	 && INTVAL (XEXP (XEXP (X, 0), 1)) < 0x10000)				\
      || (GET_CODE (XEXP (XEXP (X, 0), 1)) == SYMBOL_REF			\
	 && ! MEM_IN_REMOTE (XEXP (XEXP (X, 0), 1))				\
	 && GET_CODE (XEXP (XEXP (X, 0), 0)) == CONST_INT			\
	 && INTVAL (XEXP (XEXP (X, 0), 0)) > 0					\
	 && INTVAL (XEXP (XEXP (X, 0), 0)) < 0x10000)))

#define INDIRECTABLE_1_ADDRESS_P(X)  \
  (CONSTANT_ADDRESS_P (X)						\
   || (GET_CODE (X) == REG && REG_OK_FOR_BASE_P (X))			\
   || ((GET_CODE (X) == PRE_DEC || GET_CODE (X) == POST_INC)		\
       && REG_P (XEXP (X, 0))						\
       && REG_OK_FOR_BASE_P (XEXP (X, 0)))				\
   || (GET_CODE (X) == PLUS						\
       && REG_P (XEXP (X, 0)) && REG_OK_FOR_BASE_P (XEXP (X, 0))	\
       &&   ((GET_CODE (XEXP (X, 1)) == CONST_INT			\
              && ((unsigned) INTVAL (XEXP (X, 1)) + 0x8000) < 0x10000)	\
	    || (GET_CODE (XEXP (X, 1)) == SYMBOL_REF			\
	        && (! MEM_IN_REMOTE (XEXP (X, 1))))			\
	    || CONST_PLUS_OK_ADDR (XEXP (X, 1)))))

#if 0
/* This should replace the last two lines
   except that Sun's assembler does not seem to handle such operands.  */
       && (TARGET_68020 ? CONSTANT_ADDRESS_P (XEXP (X, 1))		\
	   : (GET_CODE (XEXP (X, 1)) == CONST_INT			\
	      && ((unsigned) INTVAL (XEXP (X, 1)) + 0x8000) < 0x10000))))
#endif


#define GO_IF_NONINDEXED_ADDRESS(X, ADDR)  \
{ if (INDIRECTABLE_1_ADDRESS_P (X)) goto ADDR; }

#define GO_IF_INDEXABLE_BASE(X, ADDR)	\
{ if (GET_CODE (X) == LABEL_REF) goto ADDR;				\
  if (GET_CODE (X) == REG && REG_OK_FOR_BASE_P (X)) goto ADDR; }

#define GO_IF_INDEXING(X, ADDR)	\
{ if (GET_CODE (X) == PLUS && LEGITIMATE_INDEX_P (XEXP (X, 0)))		\
    { GO_IF_INDEXABLE_BASE (XEXP (X, 1), ADDR); }			\
  if (GET_CODE (X) == PLUS && LEGITIMATE_INDEX_P (XEXP (X, 1)))		\
    { GO_IF_INDEXABLE_BASE (XEXP (X, 0), ADDR); } }

#define GO_IF_INDEXED_ADDRESS(X, ADDR)	 \
{ GO_IF_INDEXING (X, ADDR);						\
  if (GET_CODE (X) == PLUS)						\
    { if (GET_CODE (XEXP (X, 1)) == CONST_INT				\
	  && (unsigned) INTVAL (XEXP (X, 1)) + 0x80 < 0x100)		\
	{ rtx go_temp = XEXP (X, 0); GO_IF_INDEXING (go_temp, ADDR); }	\
      if (GET_CODE (XEXP (X, 0)) == CONST_INT				\
	  && (unsigned) INTVAL (XEXP (X, 0)) + 0x80 < 0x100)		\
	{ rtx go_temp = XEXP (X, 1); GO_IF_INDEXING (go_temp, ADDR); } } }

#define LEGITIMATE_INDEX_REG_P(X)   \
  ((GET_CODE (X) == REG && REG_OK_FOR_INDEX_P (X))	\
   || (GET_CODE (X) == SIGN_EXTEND			\
       && GET_CODE (XEXP (X, 0)) == REG			\
       && GET_MODE (XEXP (X, 0)) == HImode		\
       && REG_OK_FOR_INDEX_P (XEXP (X, 0))))

#define LEGITIMATE_INDEX_P(X)   \
   (LEGITIMATE_INDEX_REG_P (X)				\
    || (TARGET_68020 && GET_CODE (X) == MULT		\
	&& LEGITIMATE_INDEX_REG_P (XEXP (X, 0))		\
	&& GET_CODE (XEXP (X, 1)) == CONST_INT		\
	&& (INTVAL (XEXP (X, 1)) == 2			\
	    || INTVAL (XEXP (X, 1)) == 4		\
	    || INTVAL (XEXP (X, 1)) == 8)))


#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, ADDR)	\
{if (check_pcr_addr (X))			\
{ GO_IF_NONINDEXED_ADDRESS (X, ADDR);		\
  GO_IF_INDEXED_ADDRESS (X, ADDR);		\
  GO_IF_MEMORY_INDIRECT_ADDRESS(MODE, X, ADDR);}}
#endif /* GNU_C_VERSION == 2 */


/* Try machine-dependent ways of modifying an illegitimate address
   to be legitimate.  If we find one, return the new, valid address.
   This macro is used in only one place: `memory_address' in explow.c.

   OLDX is the address as it was before break_out_memory_refs was called.
   In some cases it is useful to look at this to decide what needs to be done.

   MODE and WIN are passed so that this macro can use
   GO_IF_LEGITIMATE_ADDRESS.

   It is always safe for this macro to do nothing.  It exists to recognize
   opportunities to optimize the output.

   For the 68000, we handle X+REG by loading X into a register R and
   using R+REG.  R will go in an address reg and indexing will be used.
   However, if REG is a broken-out memory address or multiplication,
   nothing needs to be done because REG can certainly go in an address reg.  */

#define COPY_ONCE(Y) if (!copied) { Y = copy_rtx (Y); copied = ch = 1; }
#define LEGITIMIZE_ADDRESS(X,OLDX,MODE,WIN)   \
{ register int ch = (X) != (OLDX);					\
  if (GET_CODE (X) == PLUS)						\
    { int copied = 0;							\
      if (GET_CODE (XEXP (X, 0)) == MULT)				\
	{ COPY_ONCE (X); XEXP (X, 0) = force_operand (XEXP (X, 0), 0);}	\
      if (GET_CODE (XEXP (X, 1)) == MULT)				\
	{ COPY_ONCE (X); XEXP (X, 1) = force_operand (XEXP (X, 1), 0);}	\
      if (ch && GET_CODE (XEXP (X, 1)) == REG				\
	  && GET_CODE (XEXP (X, 0)) == REG)				\
	return X;							\
      if (ch) { GO_IF_LEGITIMATE_ADDRESS (MODE, X, WIN); }		\
      if (GET_CODE (XEXP (X, 0)) == REG					\
	       || (GET_CODE (XEXP (X, 0)) == SIGN_EXTEND		\
		   && GET_CODE (XEXP (XEXP (X, 0), 0)) == REG		\
		   && GET_MODE (XEXP (XEXP (X, 0), 0)) == HImode))	\
	{ register rtx temp = gen_reg_rtx (Pmode);			\
	  register rtx val = force_operand (XEXP (X, 1), 0);		\
	  emit_move_insn (temp, val);					\
	  COPY_ONCE (X);						\
	  XEXP (X, 1) = temp;						\
	  return X; }							\
      else if (GET_CODE (XEXP (X, 1)) == REG				\
	       || (GET_CODE (XEXP (X, 1)) == SIGN_EXTEND		\
		   && GET_CODE (XEXP (XEXP (X, 1), 0)) == REG		\
		   && GET_MODE (XEXP (XEXP (X, 1), 0)) == HImode))	\
	{ register rtx temp = gen_reg_rtx (Pmode);			\
	  register rtx val = force_operand (XEXP (X, 0), 0);		\
	  emit_move_insn (temp, val);					\
	  COPY_ONCE (X);						\
	  XEXP (X, 0) = temp;						\
	  return X; }}}

/* Go to LABEL if ADDR (a legitimate address expression)
   has an effect that depends on the machine mode it is used for.
   On the 68000, only predecrement and postincrement address depend thus
   (the amount of decrement or increment being the length of the operand).  */

#define GO_IF_MODE_DEPENDENT_ADDRESS(ADDR,LABEL)	\
 if (GET_CODE (ADDR) == POST_INC || GET_CODE (ADDR) == PRE_DEC) goto LABEL

/* Specify the machine mode that this machine uses
   for the index in the tablejump instruction.  */
#define CASE_VECTOR_MODE HImode

/* Define this if the tablejump instruction expects the table
   to contain offsets from the address of the table.
   Do not define this if the table should contain absolute addresses.  */
#define CASE_VECTOR_PC_RELATIVE

/* Specify the tree operation to be used to convert reals to integers.  */
#define IMPLICIT_FIX_EXPR FIX_ROUND_EXPR

/* This is the kind of divide that is easiest to do in the general case.  */
#define EASY_DIV_EXPR TRUNC_DIV_EXPR

/* Define this as 1 if `char' should by default be signed; else as 0.  */
#define DEFAULT_SIGNED_CHAR 1

#if (GNU_C_VERSION == 2)
/* Don't cse the address of the function being compiled.  */
#define NO_RECURSIVE_FUNCTION_CSE
#endif

/* Max number of bytes we can move from memory to memory
   in one reasonably fast instruction.  */
#define MOVE_MAX 4

/* Define this if zero-extension is slow (more than one real instruction).  */
#define SLOW_ZERO_EXTEND

/* Nonzero if access to memory by bytes is slow and undesirable.  */
#define SLOW_BYTE_ACCESS 0

/* Define if shifts truncate the shift count
   which implies one can omit a sign-extension or zero-extension
   of a shift count.  */
#if (GNU_C_VERSION == 2)
#undef SHIFT_COUNT_TRUNCATED
#else
#define SHIFT_COUNT_TRUNCATED
#endif
/* Value is 1 if truncating an integer of INPREC bits to OUTPREC bits
   is done just by pretending it is already truncated.  */
#define TRULY_NOOP_TRUNCATION(OUTPREC, INPREC) 1

/* We assume that the store-condition-codes instructions store 0 for false
   and some other value for true.  This is the value stored for true.  */

#define STORE_FLAG_VALUE -1

/* When a prototype says `char' or `short', really pass an `int'.  */
#define PROMOTE_PROTOTYPES

/* Specify the machine mode that pointers have.
   After generation of rtl, the compiler makes no further distinction
   between pointers and any other objects of this machine mode.  */
#define Pmode SImode

/* A function address in a call instruction
   is a byte address (for indexing purposes)
   so give the MEM rtx a byte's mode.  */
#define FUNCTION_MODE QImode

/* Compute the cost of computing a constant rtl expression RTX
   whose rtx-code is CODE.  The body of this macro is a portion
   of a switch statement.  If the code is computed here,
   return it with a return statement.  Otherwise, break from the switch.  */

#if (GNU_C_VERSION == 2)
#define CONST_COSTS(RTX,CODE,OUTER_CODE) \
  case CONST_INT:						\
    /* Constant zero is super cheap due to clr instruction.  */	\
    if (RTX == const0_rtx) return 0;				\
    /* Constants between -128 and 127 are cheap due to moveq */ \
    if (INTVAL (RTX) >= -128 && INTVAL (RTX) <= 127) return 1;	\
    /* Constants between -136 and 254 are easily generated */	\
    /* by intelligent uses of moveq, add[q], and subq 	   */   \
    if ((OUTER_CODE) == SET && INTVAL (RTX) >= -136		\
	&& INTVAL (RTX) <= 254) return 2;			\
  case CONST:							\
  case LABEL_REF:						\
  case SYMBOL_REF:						\
    return 3;							\
  case CONST_DOUBLE:						\
    return 5;
/* Compute the cost of various arithmetic operations.
   These are vaguely right for a 68020.  */
/* The costs for long multiply have been adjusted to
   work properly in synth_mult on the 68020,
   relative to an average of the time for add and the time for shift,
   taking away a little more because sometimes move insns are needed.  */
#define MULL_COST (TARGET_68040 ? 5 : 13)
#define MULW_COST (TARGET_68040 ? 3 : 8)

#define RTX_COSTS(X,CODE,OUTER_CODE)				\
  case PLUS:							\
    /* An lea costs about three times as much as a simple add.  */  \
    if (GET_MODE (X) == SImode					\
	&& GET_CODE (XEXP (X, 0)) == REG			\
	&& GET_CODE (XEXP (X, 1)) == MULT			\
	&& GET_CODE (XEXP (XEXP (X, 1), 0)) == REG		\
	&& GET_CODE (XEXP (XEXP (X, 1), 1)) == CONST_INT	\
	&& (INTVAL (XEXP (XEXP (X, 1), 1)) == 2			\
	    || INTVAL (XEXP (XEXP (X, 1), 1)) == 4		\
	    || INTVAL (XEXP (XEXP (X, 1), 1)) == 8))		\
      return COSTS_N_INSNS (3);	 /* lea an@(dx:l:i),am */	\
    break;							\
  case ASHIFT:							\
  case ASHIFTRT:						\
  case LSHIFT:							\
  case LSHIFTRT:						\
    /* A shift by a big integer takes an extra instruction.  */ \
    if (GET_CODE (XEXP (X, 1)) == CONST_INT			\
	&& (INTVAL (XEXP (X, 1)) == 16))			\
      return COSTS_N_INSNS (2);	 /* clrw;swap */		\
    if (GET_CODE (XEXP (X, 1)) == CONST_INT			\
	&& !(INTVAL (XEXP (X, 1)) > 0				\
	     && INTVAL (XEXP (X, 1)) <= 8))			\
      return COSTS_N_INSNS (3);	 /* lsr #i,dn */		\
    break;							\
  case MULT:							\
    if (GET_CODE (XEXP (x, 1)) == CONST_INT			\
	&& exact_log2 (INTVAL (XEXP (x, 1))) >= 0)		\
      {								\
	/* A shift by a big integer takes an extra instruction.  */ \
	if (GET_CODE (XEXP (X, 1)) == CONST_INT			\
	    && (INTVAL (XEXP (X, 1)) == (1 << 16)))		\
	  return COSTS_N_INSNS (2);	 /* clrw;swap */	\
	if (GET_CODE (XEXP (X, 1)) == CONST_INT			\
	    && !(INTVAL (XEXP (X, 1)) > 1			\
		 && INTVAL (XEXP (X, 1)) <= 256))		\
	  return COSTS_N_INSNS (3);	 /* lsr #i,dn */	\
	break;							\
      }								\
    else if (GET_MODE (X) == QImode || GET_MODE (X) == HImode)	\
      return COSTS_N_INSNS (MULW_COST);				\
    else							\
      return COSTS_N_INSNS (MULL_COST);				\
    break;							\
  case DIV:							\
  case UDIV:							\
  case MOD:							\
  case UMOD:							\
    if (GET_MODE (X) == QImode || GET_MODE (X) == HImode)	\
      return COSTS_N_INSNS (27); /* div.w */			\
    return COSTS_N_INSNS (43);	 /* div.l */

#else /* GNU_C_VERSION == 2 */
#define CONST_COSTS(RTX,CODE) \
  case CONST_INT:						\
    /* Constant zero is super cheap due to clr instruction.  */	\
    if (TARGET_68020 && RTX == const0_rtx) return 0;		\
    /* Constants between -128 and 127 are cheap due to moveq */ \
    if (INTVAL (RTX) >= -128 && INTVAL (RTX) <= 127) return 1;	\
  case CONST:							\
  case LABEL_REF:						\
  case SYMBOL_REF:						\
    return 3;							\
  case CONST_DOUBLE:						\
    return 5;
#endif /* GNU_C_VERSION == 2 */

/* Tell final.c how to eliminate redundant test instructions.  */

/* Here we define machine-dependent flags and fields in cc_status
   (see `conditions.h').  */

/* Set if the cc value is actually in the 68881, so a floating point
   conditional branch must be output.  */
#define CC_IN_68881 04000

/* Store in cc_status the expressions
   that the condition codes will describe
   after execution of an instruction whose pattern is EXP.
   Do not alter them if the instruction would not alter the cc's.  */

/* On the 68000, all the insns to store in an address register
   fail to set the cc's.  However, in some cases these instructions
   can make it possibly invalid to use the saved cc's.  In those
   cases we clear out some or all of the saved cc's so they won't be used.  */

/* It was claimed recently that addq, subq to an address register
   do update the cc's, but the 68000 and 68020 manuals say otherwise.  */
#if (GNU_C_VERSION == 2)
#define NOTICE_UPDATE_CC(EXP,INSN) notice_update_cc (EXP, INSN)
#else
#define NOTICE_UPDATE_CC(EXP, INSN) \
{								\
  /* If the cc is being set from the fpa and the
     expression is not an explicit floating point
     test instruction (which has code to deal with
     this), reinit the CC */					\
  if (((cc_status.value1 && FPA_REG_P (cc_status.value1))	\
       || (cc_status.value2 && FPA_REG_P (cc_status.value2)))	\
      && !(GET_CODE(EXP) == PARALLEL				\
	   && GET_CODE (XVECEXP(EXP, 0, 0)) == SET		\
	   && XEXP (XVECEXP (EXP, 0, 0), 0) == cc0_rtx))	\
    { CC_STATUS_INIT; }						\
  else if (GET_CODE (EXP) == SET)				\
    { if (GET_CODE (SET_SRC (EXP)) == CALL)			\
	{ CC_STATUS_INIT; }					\
      else if (ADDRESS_REG_P (SET_DEST (EXP)))			\
	{ if (cc_status.value1					\
	      && reg_overlap_mentioned_p (SET_DEST (EXP), cc_status.value1)) \
	    cc_status.value1 = 0;				\
	  if (cc_status.value2					\
	      && reg_overlap_mentioned_p (SET_DEST (EXP), cc_status.value2)) \
	    cc_status.value2 = 0; }				\
      else if (!FP_REG_P (SET_DEST (EXP))			\
	       && SET_DEST (EXP) != cc0_rtx			\
	       && (FP_REG_P (SET_SRC (EXP))			\
		   || GET_CODE (SET_SRC (EXP)) == FIX		\
		   || GET_CODE (SET_SRC (EXP)) == FLOAT_TRUNCATE \
		   || GET_CODE (SET_SRC (EXP)) == FLOAT_EXTEND)) \
	{ CC_STATUS_INIT; }					\
      /* A pair of move insns doesn't produce a useful overall cc.  */ \
      else if (!FP_REG_P (SET_DEST (EXP))			\
	       && !FP_REG_P (SET_SRC (EXP))			\
	       && GET_MODE_SIZE (GET_MODE (SET_SRC (EXP))) > 4	\
	       && (GET_CODE (SET_SRC (EXP)) == REG		\
		   || GET_CODE (SET_SRC (EXP)) == MEM		\
		   || GET_CODE (SET_SRC (EXP)) == CONST_DOUBLE))\
	{ CC_STATUS_INIT; }					\
      else if (XEXP (EXP, 0) != pc_rtx)				\
	{ cc_status.flags = 0;					\
	  cc_status.value1 = XEXP (EXP, 0);			\
	  cc_status.value2 = XEXP (EXP, 1); } }			\
  else if (GET_CODE (EXP) == PARALLEL				\
	   && GET_CODE (XVECEXP (EXP, 0, 0)) == SET)		\
    {								\
      if (ADDRESS_REG_P (XEXP (XVECEXP (EXP, 0, 0), 0)))	\
	CC_STATUS_INIT;						\
      else if (XEXP (XVECEXP (EXP, 0, 0), 0) != pc_rtx)		\
	{ cc_status.flags = 0;					\
	  cc_status.value1 = XEXP (XVECEXP (EXP, 0, 0), 0);	\
	  cc_status.value2 = XEXP (XVECEXP (EXP, 0, 0), 1); } }	\
  else CC_STATUS_INIT;						\
  if (cc_status.value2 != 0					\
      && ADDRESS_REG_P (cc_status.value2)			\
      && GET_MODE (cc_status.value2) == QImode)			\
    CC_STATUS_INIT;						\
  if (cc_status.value2 != 0					\
      && !(cc_status.value1 && FPA_REG_P (cc_status.value1)))	\
    switch (GET_CODE (cc_status.value2))			\
      { case PLUS: case MINUS: case MULT: case UMULT:		\
	case DIV: case UDIV: case MOD: case UMOD: case NEG:	\
	case ASHIFT: case LSHIFT: case ASHIFTRT: case LSHIFTRT:	\
	case ROTATE: case ROTATERT:				\
	  if (GET_MODE (cc_status.value2) != VOIDmode)		\
	    cc_status.flags |= CC_NO_OVERFLOW;			\
	  break;						\
	case ZERO_EXTEND:					\
	case ZERO_EXTRACT:					\
	  /* (SET r1 (ZERO_EXTEND r2)) on this machine
	     ends with a move insn moving r2 in r2's mode.
	     Thus, the cc's are set for r2.
	     This can set N bit spuriously. */			\
	  cc_status.flags |= CC_NOT_NEGATIVE; }			\
  if (cc_status.value1 && GET_CODE (cc_status.value1) == REG	\
      && cc_status.value2					\
      && reg_overlap_mentioned_p (cc_status.value1, cc_status.value2))	\
    cc_status.value2 = 0;					\
  if (((cc_status.value1 && FP_REG_P (cc_status.value1))	\
       || (cc_status.value2 && FP_REG_P (cc_status.value2)))	\
      && !((cc_status.value1 && FPA_REG_P (cc_status.value1))	\
	   || (cc_status.value2 && FPA_REG_P (cc_status.value2)))) \
    cc_status.flags = CC_IN_68881; }
#endif

#define OUTPUT_JUMP(NORMAL, FLOAT, NO_OV)  \
do { if (cc_prev_status.flags & CC_IN_68881)			\
       return FLOAT;						\
     if (cc_prev_status.flags & CC_NO_OVERFLOW)			\
       return NO_OV;						\
     return NORMAL; } while (0)

/* Control the assembler format that we output.  */

/* Output at beginning of assembler file.  */

#define ASM_FILE_START(FILE) fprintf (FILE, "* NO_APP\n");

/* Don't try to define `gcc_compiled.' since the assembler might not
   accept symbols with periods and GDB doesn't run on this machine anyway.  */
#define ASM_IDENTIFY_GCC(FILE) fprintf (FILE, "* X68 GCC Develop\n")

/* Output to assembler file text saying following lines
   may contain character constants, extra white space, comments, etc.  */

#define ASM_APP_ON "* APP ON (APP)\n"

/* Output to assembler file text saying following lines
   no longer contain unusual constructs.  */

#define ASM_APP_OFF "* APP OFF (NO_APP)\n"

/* Output before read-only data.  */

#define TEXT_SECTION_ASM_OP "\t.text"

/* Output before writable data.  */

#define DATA_SECTION_ASM_OP "\t.data"

#if (GNU_C_VERSION == 2)
/* Here are four prefixes that are used by asm_fprintf to
   facilitate customization for alternate assembler syntaxes.
   Machines with no likelihood of an alternate syntax need not
   define these and need not use asm_fprintf.  */

/* The prefix for register names.  Note that REGISTER_NAMES
   is supposed to include this prefix.  */

#define REGISTER_PREFIX ""

/* The prefix for local labels.  You should be able to define this as
   an empty string, or any arbitrary string (such as ".", ".L%", etc)
   without having to make any other changes to account for the specific
   definition.  Note it is a string literal, not interpreted by printf
   and friends. */

#define LOCAL_LABEL_PREFIX ""

/* The prefix to add to user-visible assembler symbols.  */

#define USER_LABEL_PREFIX "_"

/* The prefix for immediate operands.  */

#define IMMEDIATE_PREFIX "#"

#endif
/* How to refer to registers in assembler output.
   This sequence is indexed by compiler's hard-register-number (see above).  */

#define REGISTER_NAMES \
{"d0", "d1", "d2", "d3", "d4", "d5", "d6", "d7",	\
 "a0", "a1", "a2", "a3", "a4", "a5", "a6", "sp",	\
 "fp0", "fp1", "fp2", "fp3", "fp4", "fp5", "fp6", "fp7",\
 "pc" }

/* How to renumber registers for dbx and gdb.
   On the Sun-3, the floating point registers have numbers
   18 to 25, not 16 to 23 as they do in the compiler.  */
/* for X68000 scd.x */
   
#define DBX_REGISTER_NUMBER(REGNO) (REGNO)
/* ((REGNO) < 16 ? (REGNO) : (REGNO) + 2) */

/* This is how to output the definition of a user-level label named NAME,
   such as the label on a static function or variable NAME.  */

#define ASM_OUTPUT_LABEL(FILE,NAME)	\
  do { assemble_name (FILE, NAME); fputs (":\n", FILE); } while (0)

/* This is how to output a command to make the user-level label named NAME
   defined for reference from other files.  */

#define ASM_GLOBALIZE_LABEL(FILE,NAME)		\
do {						\
  if (strcmp("main", NAME))		 	\
    fputs ("\t.globl ", FILE);		 	\
  else					 	\
    fputs ("\t.xref __main\n\t.xdef ", FILE);	\
  assemble_name (FILE, NAME);			\
  fputs ("\n", FILE);				\
} while (0)

/* This is how to output a reference to a user-level label named NAME.
   `assemble_name' uses this.  */

#define ASM_OUTPUT_LABELREF(FILE,NAME)	\
  fprintf (FILE, "_%s", NAME)

/* This is how to output an internal numbered label where
   PREFIX is the class of label and NUM is the number within the class.  */

#define ASM_OUTPUT_INTERNAL_LABEL(FILE,PREFIX,NUM)	\
  fprintf (FILE, "%s%d:\n", PREFIX, NUM)

/* This is how to store into the string LABEL
   the symbol_ref name of an internal numbered label where
   PREFIX is the class of label and NUM is the number within the class.
   This is suitable for output with `assemble_name'.  */

#define ASM_GENERATE_INTERNAL_LABEL(LABEL,PREFIX,NUM)	\
  sprintf (LABEL, "*%s%d", PREFIX, NUM)

/* This is how to output an assembler line defining a `double' constant.  */
#define ASM_OUTPUT_DOUBLE(FILE,VALUE)					\
do {									\
  if (1 /* flag_fppp */ )						\
    {									\
      union { double d; long l[2];} tem;				\
      tem.d = (VALUE);							\
      fprintf (FILE, "\t.dc.l $%08x,$%08x\n", tem.l[0], tem.l[1]);	\
    }									\
  else									\
    fprintf ((FILE), "\t.dc.d 0f%.20g\n", (VALUE));			\
} while (0)


/* This is how to output an assembler line defining a `float' constant.  */
#define ASM_OUTPUT_FLOAT(FILE,VALUE)			\
do {							\
  if (1 /* flag_fppp */)				\
    {							\
      union { float f; long l;} tem;			\
      tem.f = (VALUE);					\
      fprintf (FILE, "\t.dc.l $%08x\n", tem.l);		\
    }							\
  else							\
    fprintf ((FILE),"\t.dc.s 0f%.10g\n", (VALUE));	\
} while (0)

/* Sun's assembler can't handle floating constants written as floating.
   However, when cross-compiling, always use that in case format differs.  */

#ifdef CROSS_COMPILER
#define ASM_OUTPUT_FLOAT(FILE,VALUE)  \
  fprintf (FILE, "\t.float 0r%.10g\n", (VALUE))
#endif /* CROSS_COMPILER */

/* This is how to output an assembler line defining an `int' constant.  */

#define ASM_OUTPUT_INT(FILE,VALUE)		\
( fprintf (FILE, "\t.dc.l "),			\
  output_addr_const (FILE, (VALUE)),		\
  fprintf (FILE, "\n"))

/* Likewise for `char' and `short' constants.  */

#define ASM_OUTPUT_SHORT(FILE,VALUE)		\
( fprintf (FILE, "\t.dc.w "),			\
  output_addr_const (FILE, (VALUE)),		\
  fprintf (FILE, "\n"))

#define ASM_OUTPUT_CHAR(FILE,VALUE)		\
( fprintf (FILE, "\t.dc.b "),			\
  output_addr_const (FILE, (VALUE)),		\
  fprintf (FILE, "\n"))

/* This is how to output an assembler line for a numeric constant byte.  */

#define ASM_OUTPUT_BYTE(FILE,VALUE)		\
  fprintf (FILE, "\t.dc.b $%02x\n", (VALUE))

/* This is how to output an insn to push a register on the stack.
   It need not be very fast code.  */

#define ASM_OUTPUT_REG_PUSH(FILE,REGNO)  \
  fprintf (FILE, "\tmove.l %s,-(sp)\n", reg_names[REGNO])

/* This is how to output an insn to pop a register from the stack.
   It need not be very fast code.  */

#define ASM_OUTPUT_REG_POP(FILE,REGNO)  \
  fprintf (FILE, "\tmove.l (sp)+,%s\n", reg_names[REGNO])

#define iskanji(c) ((0x81<=(c)&&(c)<=0x9f)||(0xe0<=(c)&&(c)<=0xfc))
#define iskanji2(c) ((0x40<=(c)&&(c)<=0x7e)||(0x80<=(c)&&(c)<=0xfc))
#define isprkana(c) ((0x20<=(c))&&((0x7e>=(c))) || ((0xa1<=(c))&&(0xdf>=(c))))

#define ASM_OUTPUT_ASCII(FILE,VALUE,SIZE)		\
do {							\
  unsigned char *s = (VALUE);				\
  int i = 0, x = 0, q = 0, c, n;			\
  fputs("\t.dc.b ", (FILE));				\
  for(;;) {						\
    c = *s++;						\
    n = (iskanji(c) && iskanji2(*s)) ?			\
         2 : (isprkana(c) && c != '\'') ? 1 : 0;	\
    if (n) {						\
      if (q == 0) {					\
	q = 1;						\
        fputc('\'', (FILE));				\
	x++;						\
      }							\
      fputc(c, (FILE));					\
      if (n == 2) {					\
	fputc(*s++, (FILE));				\
	i++;						\
      }							\
      x += n;						\
    }							\
    else {						\
      if (q) {						\
	q = 0;						\
        fputs("',", (FILE));				\
	x += 2;						\
      }							\
      fprintf((FILE), "$%02x", c);			\
      x += 3;						\
    }							\
    if (++i >= (SIZE))					\
      {							\
        if (q)						\
          fputc('\'', (FILE));				\
        break;						\
      }							\
    if (x > 76) {					\
      if (q) {						\
	q = 0;						\
        fputc('\'', (FILE));				\
      }							\
      fputs("\n\t.dc.b ", (FILE));			\
      x = 0;						\
    }							\
    else if (q == 0) {					\
      fputc(',', (FILE));				\
      x++;						\
    }							\
  }							\
  fputc('\n', (FILE));					\
} while(0)


/* This is how to output an element of a case-vector that is absolute.
   (The 68000 does not use such vectors,
   but we must define this macro anyway.)  */
#if (GNU_C_VERSION == 2)
#define ASM_OUTPUT_ADDR_VEC_ELT(FILE, VALUE)  \
  fprintf (FILE, "\t.dc.l L%d\n", VALUE)
#else
#define ASM_OUTPUT_ADDR_VEC_ELT(FILE, VALUE)  \
  fprintf (FILE, "\t.dc.l ?%d\n", VALUE)
#endif

/* This is how to output an element of a case-vector that is relative.  */

#if (GNU_C_VERSION == 2)
#define ASM_OUTPUT_ADDR_DIFF_ELT(FILE, VALUE, REL)  \
  fprintf (FILE, "\t.dc.w L%d-L%d\n", VALUE, REL)
#else
#define ASM_OUTPUT_ADDR_DIFF_ELT(FILE, VALUE, REL)  \
  fprintf (FILE, "\t.dc.w ?%d-?%d\n", VALUE, REL)
#endif

/* This is how to output an assembler line
   that says to advance the location counter
   to a multiple of 2**LOG bytes.  */
#if (GNU_C_VERSION == 2)
#define ASM_OUTPUT_ALIGN(FILE,LOG)		\
  if ((LOG) == 1)				\
    fputs ("\t.even\n", FILE);			\
  else if ((LOG) != 0)				\
    abort ();
#else
#define ASM_OUTPUT_ALIGN_CODE(FILE)		\
if (TARGET_68020 || TARGET_68040)		\
  {						\
   extern char *block_align_op;			\
   fputs (block_align_op,FILE);			\
  }

#define ASM_OUTPUT_ALIGN(FILE,LOG)		\
  if ((LOG) == 1)				\
    if (TARGET_68020 || TARGET_68040)		\
      {						\
      	extern char *data_section_align_op;	\
      	extern char *text_section_align_op;	\
	if (in_text_section ())			\
	  fputs (text_section_align_op, FILE);	\
	else					\
	  fputs (data_section_align_op, FILE);	\
      }						\
    else					\
      fputs ("\t.even\n", FILE);		\
  else if ((LOG) != 0)				\
    abort ();
#endif

#define ASM_OUTPUT_SKIP(FILE,SIZE)	\
  fprintf (FILE, "\t.ds.b %d\n", (SIZE))

/* This says how to output an assembler line
   to define a global common symbol.  */
/* This macro is simple. In SX gcc, output section selected
   befor this macro use */
#if (GNU_C_VERSION == 2)
#define ASM_OUTPUT_COMMON(FILE, NAME, SIZE, ROUNDED)	\
do {							\
 fputs ("\t.xdef ", (FILE));				\
 assemble_name ((FILE), (NAME));			\
 fputs ("\n\t.comm ", (FILE));				\
 assemble_name ((FILE), (NAME));			\
 fprintf ((FILE), ",%d\n", (ROUNDED));			\
} while (0)
#else
#define ASM_OUTPUT_COMMON(FILE, NAME, SIZE, ROUNDED)	\
do {							\
 fputs ("\t.xdef ", (FILE));				\
 assemble_name ((FILE), (NAME));			\
 if (flag_text || in_section == in_text)		\
   {							\
     fputs("\n",(FILE));				\
     assemble_name ((FILE),(NAME));			\
     fprintf((FILE),":\n\t.ds.b %d\n",(ROUNDED));	\
   }							\
 else							\
   {							\
     if (in_section == in_rbss)				\
       fputs ("\n\t.rcomm ", (FILE));			\
     else if (in_section == in_rlbss)			\
       fputs ("\n\t.rlcomm ", (FILE));			\
     else if (in_section == in_bss)			\
       fputs ("\n\t.comm ", (FILE));			\
     else						\
       abort ();					\
     assemble_name ((FILE), (NAME));			\
     fprintf ((FILE), ",%d\n", (ROUNDED));		\
   }							\
} while (0)
#endif

/* This says how to output an assembler line
   to define a local common symbol.  */

#define ASM_OUTPUT_LOCAL(FILE, NAME, SIZE, ROUNDED)	\
do {							\
  assemble_name ((FILE), (NAME));			\
  fprintf ((FILE), ":\n\t.ds.b %d\n", (ROUNDED));	\
} while (0)

/* Store in OUTPUT a string (made with alloca) containing
   an assembler-name for a local static variable named NAME.
   LABELNO is an integer which is different for each call.  */

#define ASM_FORMAT_PRIVATE_NAME(OUTPUT, NAME, LABELNO)	\
( (OUTPUT) = (char *) alloca (strlen ((NAME)) + 12),	\
  sprintf ((OUTPUT), "?%s_%d", (NAME), (LABELNO)))

/* Define the parentheses used to group arithmetic operations
   in assembler code.  */

#define ASM_OPEN_PAREN "("
#define ASM_CLOSE_PAREN ")"

/* Define results of standard character escape sequences.  */
#define TARGET_BELL 007
#define TARGET_BS 010
#define TARGET_TAB 011
#define TARGET_NEWLINE 012
#define TARGET_VT 013
#define TARGET_FF 014
#define TARGET_CR 015

/* Output a float value (represented as a C double) as an immediate operand.
   This macro is a 68k-specific macro.  */
#if (GNU_C_VERSION == 2)
#define ASM_OUTPUT_FLOAT_OPERAND(CODE,FILE,VALUE)		\
 do {								\
      if (CODE == 'f')						\
        {							\
          char dstr[30];					\
          REAL_VALUE_TO_DECIMAL (VALUE, "%.9g", dstr);		\
          asm_fprintf ((FILE), "%I0r%s", dstr);			\
        }							\
      else							\
        {							\
          long l;						\
          REAL_VALUE_TO_TARGET_SINGLE (VALUE, l);		\
          if (sizeof (int) == sizeof (long))			\
            asm_fprintf ((FILE), "%I0x%x", l);			\
          else							\
            asm_fprintf ((FILE), "%I0x%lx", l);			\
        }							\
     } while (0)
/* Output a double value (represented as a C double) as an immediate operand.
   This macro is a 68k-specific macro.  */
#define ASM_OUTPUT_DOUBLE_OPERAND(FILE,VALUE)				\
 do { char dstr[30];							\
      REAL_VALUE_TO_DECIMAL (VALUE, "%.20g", dstr);			\
      asm_fprintf (FILE, "%I0r%s", dstr);				\
    } while (0)

/* Note, long double immediate operands are not actually
   generated by m68k.md.  */
#define ASM_OUTPUT_LONG_DOUBLE_OPERAND(FILE,VALUE)			\
 do { char dstr[30];							\
      REAL_VALUE_TO_DECIMAL (VALUE, "%.20g", dstr);			\
      asm_fprintf (FILE, "%I0r%s", dstr);				\
    } while (0)

#else /* GNUC Ver 2 else */

#define ASM_OUTPUT_FLOAT_OPERAND(FILE,VALUE)				\
  fprintf (FILE, "#0r%.9g", (VALUE))
/* Output a double value (represented as a C double) as an immediate operand.
   This macro is a 68k-specific macro.  */
#define ASM_OUTPUT_DOUBLE_OPERAND(FILE,VALUE)				\
  fprintf (FILE, "#0r%.20g", (VALUE))
#endif

/* Print operand X (an rtx) in assembler syntax to file FILE.
   CODE is a letter or dot (`z' in `%z0') or 0 if no letter was specified.
   For `%' followed by punctuation, CODE is the punctuation and X is null.

   On the 68000, we use several CODE characters:
   '.' for dot needed in Motorola-style opcode names.
   '-' for an operand pushing on the stack:
       sp@-, -(sp) or -(%sp) depending on the style of syntax.
   '+' for an operand pushing on the stack:
       sp@+, (sp)+ or (%sp)+ depending on the style of syntax.
   '@' for a reference to the top word on the stack:
       sp@, (sp) or (%sp) depending on the style of syntax.
   '#' for an immediate operand prefix (# in MIT and Motorola syntax
       but & in SGS syntax).
   '!' for the cc register (used in an `and to cc' insn).

   'b' for byte insn (no effect, on the Sun; this is for the ISI).
   'd' to force memory addressing to be absolute, not relative.
   'f' for float insn (print a CONST_DOUBLE as a float rather than in hex)
   'w' for FPA insn (print a CONST_DOUBLE as a SunFPA constant rather
       than directly).  Second part of 'y' below.
   'x' for float insn (print a CONST_DOUBLE as a float rather than in hex),
       or print pair of registers as rx:ry.
   'y' for a FPA insn (print pair of registers as rx:ry).  This also outputs
       CONST_DOUBLE's as SunFPA constant RAM registers if
       possible, so it should not be used except for the SunFPA. */

#define PRINT_OPERAND_PUNCT_VALID_P(CODE)				\
  ((CODE) == '.' || (CODE) == '#' || (CODE) == '-'			\
   || (CODE) == '+' || (CODE) == '@' || (CODE) == '!')

/* This assumes the compiler is running on a big-endian machine.
   The support for the other case is left for version 2.  */
#define PRINT_OPERAND_EXTRACT_FLOAT(X)					\
      u.i[0] = CONST_DOUBLE_LOW (X); u.i[1] = CONST_DOUBLE_HIGH (X);

#ifdef CROSS_COMPILER
#define PRINT_OPERAND_PRINT_FLOAT(CODE, FILE)   \
  ASM_OUTPUT_FLOAT_OPERAND (FILE, u1.f);
#else
#define PRINT_OPERAND_PRINT_FLOAT(CODE, FILE)   \
{ if (CODE == 'f')							\
    ASM_OUTPUT_FLOAT_OPERAND (FILE, u1.f);				\
  else									\
    fprintf (FILE, "#0x%x", u1.i); }
#endif

#define PRINT_OPERAND(FILE, X, CODE) print_operand ((FILE),(X), (CODE))


/* Note that this contains a kludge that knows that the only reason
   we have an address (plus (label_ref...) (reg...))
   is in the insn before a tablejump, and we know that m68k.md
   generates a label LInnn: on such an insn.  */

#define PRINT_OPERAND_ADDRESS(FILE, ADDR)  print_operand_address ((FILE),(ADDR))

/* Define functions defined in aux-output.c and used in templates.  */

extern char *output_move_double ();
extern char *output_move_const_single ();
extern char *output_move_const_double ();
extern char *output_btst ();
extern int x68k_test_operand ();


extern int mariko;

#define MARIKO_A (mariko & 0x1) /* __builtin_save  expand */
#define MARIKO_B (mariko & 0x2) /* frame_pointer   expand */
#define MARIKO_C (mariko & 0x4) /* mult expand */
#define MARIKO_D (mariko & 0x8) /* like tc */
#define MARIKO_E (mariko & 0x10)
#define MARIKO_F (mariko & 0x20)


/*
Local variables:
version-control: t
End:
*/

