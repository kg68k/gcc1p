/* Subroutines for insn-output.c for Motorola 68000 family.
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


/* Some output-actions in m68k.md need these.  */
#include <stdio.h>
extern FILE *asm_out_file;

/* Index into this array by (register number >> 3) to find the
   smallest class which contains that register.  */
enum reg_class regno_reg_class[]
  = { DATA_REGS, ADDR_REGS, FP_REGS,};

static rtx find_addr_reg ();

char *
output_btst (operands, countop, dataop, insn, signpos)
     rtx *operands;
     rtx countop, dataop;
     rtx insn;
     int signpos;
{
  operands[0] = countop;
  operands[1] = dataop;

  if (GET_CODE (countop) == CONST_INT)
    {
      register int count = INTVAL (countop);
      /* If COUNT is bigger than size of storage unit in use,
	 advance to the containing unit of same size.  */
      if (count > signpos)
	{
	  int offset = (count & ~signpos) / 8;
	  count = count & signpos;
	  operands[1] = dataop = adj_offsettable_operand (dataop, offset);
	}
      if (count == signpos)
	cc_status.flags = CC_NOT_POSITIVE | CC_Z_IN_NOT_N;
      else
	cc_status.flags = CC_NOT_NEGATIVE | CC_Z_IN_NOT_N;

      if (count == 31
	  && next_insns_test_no_inequality (insn))
	return "tst%.l %1";
      if (count == 15
	  && next_insns_test_no_inequality (insn))
	return "tst%.w %1";
      if (count == 7
	  && next_insns_test_no_inequality (insn))
	return "tst%.b %1";

      cc_status.flags = CC_NOT_NEGATIVE;
    }
  return "btst %0,%1";
}

/* Return the best assembler insn template
   for moving operands[1] into operands[0] as a fullword.  */

static char *
singlemove_string (operands)
     rtx *operands;
{
  extern flag_slow;
  if (operands[1] != const0_rtx)
    return "move%.l %1,%0";
  if (ADDRESS_REG_P (operands[0]))
    return "sub%.l %0,%0";
  else if (DATA_REG_P (operands[0]))
    return TARGET_68020 ? "clr%.l %0" : "moveq%.l %#0,%0";
  else if (push_operand (operands[0] ,GET_MODE (operands[0]))
           && !flag_slow)
    return TARGET_68020 ? "clr%.l %0": "pea  0%.w";
  else
    return "clr%.l %0";
}

/* Output assembler code to perform a doubleword move insn
   with operands OPERANDS.  */

char *
output_move_double (operands)
     rtx *operands;
{
  enum { REGOP, OFFSOP, MEMOP, PUSHOP, POPOP, CNSTOP, RNDOP } optype0, optype1;
  rtx latehalf[2];
  rtx addreg0 = 0, addreg1 = 0;

  /* First classify both operands.  */

  if (REG_P (operands[0]))
    optype0 = REGOP;
  else if (offsettable_memref_p (operands[0]))
    optype0 = OFFSOP;
  else if (GET_CODE (XEXP (operands[0], 0)) == POST_INC)
    optype0 = POPOP;
  else if (GET_CODE (XEXP (operands[0], 0)) == PRE_DEC)
    optype0 = PUSHOP;
  else if (GET_CODE (operands[0]) == MEM)
    optype0 = MEMOP;
  else
    optype0 = RNDOP;

  if (REG_P (operands[1]))
    optype1 = REGOP;
  else if (CONSTANT_P (operands[1])
	   || GET_CODE (operands[1]) == CONST_DOUBLE)
    optype1 = CNSTOP;
  else if (offsettable_memref_p (operands[1]))
    optype1 = OFFSOP;
  else if (GET_CODE (XEXP (operands[1], 0)) == POST_INC)
    optype1 = POPOP;
  else if (GET_CODE (XEXP (operands[1], 0)) == PRE_DEC)
    optype1 = PUSHOP;
  else if (GET_CODE (operands[1]) == MEM)
    optype1 = MEMOP;
  else
    optype1 = RNDOP;

  /* Check for the cases that the operand constraints are not
     supposed to allow to happen.  Abort if we get one,
     because generating code for these cases is painful.  */

  if (optype0 == RNDOP || optype1 == RNDOP)
    abort ();

  /* If one operand is decrementing and one is incrementing
     decrement the former register explicitly
     and change that operand into ordinary indexing.  */

  if (optype0 == PUSHOP && optype1 == POPOP)
    {
      operands[0] = XEXP (XEXP (operands[0], 0), 0);
      output_asm_insn ("subq%.l %#8,%0", operands);
      operands[0] = gen_rtx (MEM, DImode, operands[0]);
      optype0 = OFFSOP;
    }
  if (optype0 == POPOP && optype1 == PUSHOP)
    {
      operands[1] = XEXP (XEXP (operands[1], 0), 0);
      output_asm_insn ("subq%.l %#8,%1", operands);
      operands[1] = gen_rtx (MEM, DImode, operands[1]);
      optype1 = OFFSOP;
    }

  /* If an operand is an unoffsettable memory ref, find a register
     we can increment temporarily to make it refer to the second word.  */

  if (optype0 == MEMOP)
    addreg0 = find_addr_reg (XEXP (operands[0], 0));

  if (optype1 == MEMOP)
    addreg1 = find_addr_reg (XEXP (operands[1], 0));

  /* Ok, we can do one word at a time.
     Normally we do the low-numbered word first,
     but if either operand is autodecrementing then we
     do the high-numbered word first.

     In either case, set up in LATEHALF the operands to use
     for the high-numbered word and in some cases alter the
     operands in OPERANDS to be suitable for the low-numbered word.  */

  if (optype0 == REGOP)
    latehalf[0] = gen_rtx (REG, SImode, REGNO (operands[0]) + 1);
  else if (optype0 == OFFSOP)
    latehalf[0] = adj_offsettable_operand (operands[0], 4);
  else
    latehalf[0] = operands[0];

  if (optype1 == REGOP)
    latehalf[1] = gen_rtx (REG, SImode, REGNO (operands[1]) + 1);
  else if (optype1 == OFFSOP)
    latehalf[1] = adj_offsettable_operand (operands[1], 4);
  else if (optype1 == CNSTOP)
    {
      if (CONSTANT_P (operands[1]))
	latehalf[1] = const0_rtx;
      else if (GET_CODE (operands[1]) == CONST_DOUBLE)
	{
#ifndef HOST_WORDS_BIG_ENDIAN
	  latehalf[1] = gen_rtx (CONST_INT, VOIDmode,
				 CONST_DOUBLE_LOW (operands[1]));
	  operands[1] = gen_rtx (CONST_INT, VOIDmode,
				 CONST_DOUBLE_HIGH (operands[1]));
#else /* HOST_WORDS_BIG_ENDIAN */
	  latehalf[1] = gen_rtx (CONST_INT, VOIDmode,
				 CONST_DOUBLE_HIGH (operands[1]));
	  operands[1] = gen_rtx (CONST_INT, VOIDmode,
				 CONST_DOUBLE_LOW (operands[1]));
#endif /* HOST_WORDS_BIG_ENDIAN */
	}
    }
  else
    latehalf[1] = operands[1];

  /* If insn is effectively movd N(sp),-(sp) then we will do the
     high word first.  We should use the adjusted operand 1 (which is N+4(sp))
     for the low word as well, to compensate for the first decrement of sp.  */
  if (optype0 == PUSHOP
      && REGNO (XEXP (XEXP (operands[0], 0), 0)) == STACK_POINTER_REGNUM
      && reg_overlap_mentioned_p (stack_pointer_rtx, operands[1]))
    operands[1] = latehalf[1];

  /* If one or both operands autodecrementing,
     do the two words, high-numbered first.  */

  /* Likewise,  the first move would clobber the source of the second one,
     do them in the other order.  This happens only for registers;
     such overlap can't happen in memory unless the user explicitly
     sets it up, and that is an undefined circumstance.  */

  if (optype0 == PUSHOP || optype1 == PUSHOP
      || (optype0 == REGOP && optype1 == REGOP
	  && REGNO (operands[0]) == REGNO (latehalf[1])))
    {
      /* Make any unoffsettable addresses point at high-numbered word.  */
      if (addreg0)
	output_asm_insn ("addq%.l %#4,%0", &addreg0);
      if (addreg1)
	output_asm_insn ("addq%.l %#4,%0", &addreg1);

      /* Do that word.  */
      output_asm_insn (singlemove_string (latehalf), latehalf);

      /* Undo the adds we just did.  */
      if (addreg0)
	output_asm_insn ("subq%.l %#4,%0", &addreg0);
      if (addreg1)
	output_asm_insn ("subq%.l %#4,%0", &addreg1);

      /* Do low-numbered word.  */
      return singlemove_string (operands);
    }

  /* Normal case: do the two words, low-numbered first.  */

  output_asm_insn (singlemove_string (operands), operands);

  /* Make any unoffsettable addresses point at high-numbered word.  */
  if (addreg0)
    output_asm_insn ("addq%.l %#4,%0", &addreg0);
  if (addreg1)
    output_asm_insn ("addq%.l %#4,%0", &addreg1);

  /* Do that word.  */
  output_asm_insn (singlemove_string (latehalf), latehalf);

  /* Undo the adds we just did.  */
  if (addreg0)
    output_asm_insn ("subq%.l %#4,%0", &addreg0);
  if (addreg1)
    output_asm_insn ("subq%.l %#4,%0", &addreg1);

  return "";
}

/* Return a REG that occurs in ADDR with coefficient 1.
   ADDR can be effectively incremented by incrementing REG.  */

static rtx
find_addr_reg (addr)
     rtx addr;
{
  while (GET_CODE (addr) == PLUS)
    {
      if (GET_CODE (XEXP (addr, 0)) == REG)
	addr = XEXP (addr, 0);
      else if (GET_CODE (XEXP (addr, 1)) == REG)
	addr = XEXP (addr, 1);
      else if (CONSTANT_P (XEXP (addr, 0)))
	addr = XEXP (addr, 1);
      else if (CONSTANT_P (XEXP (addr, 1)))
	addr = XEXP (addr, 0);
      else
	abort ();
    }
  if (GET_CODE (addr) == REG)
    return addr;
  abort ();
}

char *
output_move_const_double (operands)
     rtx *operands;
{
      int code = standard_68881_constant_p (operands[1]);

      if (code != 0)
	{
	  static char buf[40];

	  sprintf (buf, "fmovecr %%#$%x,%%0", code & 0xff);
	  return buf;
	}
      return "fmove%.d %1,%0";
}

char *
output_move_const_single (operands)
     rtx *operands;
{
      int code = standard_68881_constant_p (operands[1]);

      if (code != 0)
	{
	  static char buf[40];

	  sprintf (buf, "fmovecr %%#$%x,%%0", code & 0xff);
	  return buf;
	}
      return "fmove%.s %f1,%0";
}

/* Return nonzero if X, a CONST_DOUBLE, has a value that we can get
   from the "fmovecr" instruction.
   The value, anded with 0xff, gives the code to use in fmovecr
   to get the desired constant.  */

int
standard_68881_constant_p (x)
     rtx x;
{
  union {double d; int i[2];} u;
  register double d;
  u.i[0] = CONST_DOUBLE_LOW (x);
  u.i[1] = CONST_DOUBLE_HIGH (x);
  d = u.d;

  if (TARGET_68040)
    return 0;
  if (d == 0)
    return 0x0f;
  /* Note: there are various other constants available
     but it is a nuisance to put in their values here.  */
  if (d == 1)
    return 0x32;
  if (d == 10)
    return 0x33;
  if (d == 100)
    return 0x34;
  if (d == 10000)
    return 0x35;
  if (d == 1e8)
    return 0x36;
  if (GET_MODE (x) == SFmode)
    return 0;
  if (d == 1e16)
    return 0x37;
  /* larger powers of ten in the constants ram are not used
     because they are not equal to a `double' C constant.  */
  return 0;
}


void
print_operand_address (file, addr)
     FILE *file;
     rtx addr;
{
  register rtx reg1, reg2, breg, ireg;
  rtx offset;
  switch (GET_CODE (addr))
    {
    case REG:
      fprintf (file, "(%s)", reg_names[REGNO (addr)]);
      break;
    case PRE_DEC:
      fprintf (file, "-(%s)", reg_names[REGNO (XEXP (addr, 0))]);
      break;
    case POST_INC:
      fprintf (file, "(%s)+", reg_names[REGNO (XEXP (addr, 0))]);
      break;
    case MEM:
      print_mem_indirect_operand (file, addr);
      break;
    case PLUS:
      reg1 = 0;
      reg2 = 0;
      ireg = 0;
      breg = 0;
      offset = 0;
      if (GET_CODE (XEXP (addr, 0)) == MEM
          || GET_CODE (XEXP (addr, 1)) == MEM)
        {
          print_mem_indirect_operand (file, addr);
          break;
        }
      if (CONSTANT_ADDRESS_P (XEXP (addr, 0)))
	{
	  offset = XEXP (addr, 0);
	  addr = XEXP (addr, 1);
	}
      else if (CONSTANT_ADDRESS_P (XEXP (addr, 1)))
	{
	  offset = XEXP (addr, 1);
	  addr = XEXP (addr, 0);
	}
      if (GET_CODE (addr) != PLUS);
      else if (GET_CODE (XEXP (addr, 0)) == SIGN_EXTEND)
	{
	  reg1 = XEXP (addr, 0);
	  addr = XEXP (addr, 1);
	}
      else if (GET_CODE (XEXP (addr, 1)) == SIGN_EXTEND)
	{
	  reg1 = XEXP (addr, 1);
	  addr = XEXP (addr, 0);
	}
      else if (GET_CODE (XEXP (addr, 0)) == MULT)
	{
	  reg1 = XEXP (addr, 0);
	  addr = XEXP (addr, 1);
	}
      else if (GET_CODE (XEXP (addr, 1)) == MULT)
	{
	  reg1 = XEXP (addr, 1);
	  addr = XEXP (addr, 0);
	}
      else if (GET_CODE (XEXP (addr, 0)) == REG)
	{
	  reg1 = XEXP (addr, 0);
	  addr = XEXP (addr, 1);
	}
      else if (GET_CODE (XEXP (addr, 1)) == REG)
	{
	  reg1 = XEXP (addr, 1);
	  addr = XEXP (addr, 0);
	}
      if (GET_CODE (addr) == REG || GET_CODE (addr) == MULT
	  || GET_CODE (addr) == SIGN_EXTEND)
	{
	  if (reg1 == 0)
	    reg1 = addr;
	  else
	    reg2 = addr;
	  addr = 0;
	}
      if (offset != 0)
	{
	  if (addr != 0)
	    abort ();
	  addr = offset;
	}
      if ((reg1 && (GET_CODE (reg1) == SIGN_EXTEND
		    || GET_CODE (reg1) == MULT))
	  || (reg2 != 0 && REGNO_OK_FOR_BASE_P (REGNO (reg2))))
	{
	  breg = reg2;
	  ireg = reg1;
	}
      else if (reg1 != 0 && REGNO_OK_FOR_BASE_P (REGNO (reg1)))
	{
	  breg = reg1;
	  ireg = reg2;
	}
      if (ireg != 0 && breg == 0 && GET_CODE (addr) == LABEL_REF)
	{
	  int scale = 1;
	  if (GET_CODE (ireg) == MULT)
	    {
	      scale = INTVAL (XEXP (ireg, 1));
	      ireg = XEXP (ireg, 0);
	    }
	  if (GET_CODE (ireg) == SIGN_EXTEND)
	    fprintf (file, "?%d-?I%d-2(pc,%s.w",
		     CODE_LABEL_NUMBER (XEXP (addr, 0)),
		     CODE_LABEL_NUMBER (XEXP (addr, 0)),
		     reg_names[REGNO (XEXP (ireg, 0))]);
	  else
	    fprintf (file, "?%d-?I%d-2(pc,%s.l",
		     CODE_LABEL_NUMBER (XEXP (addr, 0)),
		     CODE_LABEL_NUMBER (XEXP (addr, 0)),
		     reg_names[REGNO (ireg)]);
	  if (scale != 1)
	    if (!TARGET_68020)
	      abort ();
	    else
	      fprintf (file, "*%d", scale);
	  putc (')', file);
	  break;
	}
      if (breg != 0 && ireg == 0 && GET_CODE (addr) == LABEL_REF)
	{
	  fprintf (file, "?%d-?I%d-2(pc,%s.l",
		   CODE_LABEL_NUMBER (XEXP (addr, 0)),
		   CODE_LABEL_NUMBER (XEXP (addr, 0)),
		   reg_names[REGNO (breg)]);
	  putc (')', file);
	  break;
	}
      if (ireg != 0 || breg != 0)
	{
	  int scale = 1;
	  if (breg == 0)
	    abort ();
	  if (addr && GET_CODE (addr) == LABEL_REF)
	    abort ();
	  if (TARGET_68020)
	    putc ('(', file);
	  if (addr != 0)
	    {
	      output_addr_const (file, addr);
	      if (plus_symbol_ref_p (addr) == 1)
	        fprintf (file, ".w");
	      if (TARGET_68020)
	        putc (',', file);
	    }
	  if (TARGET_68020)
	    fprintf (file, "%s", reg_names[REGNO (breg)]);
	  else
	    fprintf (file, "(%s", reg_names[REGNO (breg)]);
	  if (ireg != 0)
	    putc (',', file);
	  if (ireg != 0 && GET_CODE (ireg) == MULT)
	    {
	      scale = INTVAL (XEXP (ireg, 1));
	      ireg = XEXP (ireg, 0);
	    }
	  if (ireg != 0 && GET_CODE (ireg) == SIGN_EXTEND)
	    fprintf (file, "%s.w", reg_names[REGNO (XEXP (ireg, 0))]);
	  else if (ireg != 0)
	    fprintf (file, "%s.l", reg_names[REGNO (ireg)]);
	  if (scale != 1)
	    if (!TARGET_68020)
	      abort ();
	    else
	      fprintf (file, "*%d", scale);
	  putc (')', file);
	  break;
	}
      else if (reg1 != 0 && GET_CODE (addr) == LABEL_REF)
	{
	  fprintf (file, "?%d-?I%d-2(pc,%s.l)",
		   CODE_LABEL_NUMBER (XEXP (addr, 0)),
		   CODE_LABEL_NUMBER (XEXP (addr, 0)),
		   reg_names[REGNO (reg1)]);
	  break;
	}
    default:
      output_addr_const (file, addr);
    }
}

void
print_operand (file, x, code)
     FILE *file;
     rtx x;
     int code;
{
  int i;
  extern int flag_fppp;
  if (code == '.')
    fprintf (file, ".");
  else if (code == '#')
    fprintf (file, "#");
  else if (code == '-')
    fprintf (file, "-(sp)");
  else if (code == '+')
    fprintf (file, "(sp)+");
  else if (code == '@')
    fprintf (file, "(sp)");
  else if (code == '!')
    fprintf (file, "ccr");
  else if (GET_CODE (x) == REG)
    fprintf (file, "%s", reg_names[REGNO (x)]);
  else if (GET_CODE (x) == MEM)
    output_address (XEXP (x, 0));
  else if (GET_CODE (x) == CONST_DOUBLE && GET_MODE (x) == SFmode)
    {
      union
      {
	double d;
	int i[2];
      } u;
      union
      {
	float f;
	int i;
      } u1;
      u.i[0] = CONST_DOUBLE_LOW (x);
      u.i[1] = CONST_DOUBLE_HIGH (x);
      u1.f = u.d;
#if 0
      if (flag_fppp)
#endif
        fprintf (file, "#$%08x", u1.i);
#if 0
      else
        fprintf (file, "#0f%.9g",u.d);
#endif
    }
  else if (GET_CODE (x) == CONST_DOUBLE && GET_MODE (x) != DImode)
    {
      union
      {
	double d;
	int i[2];
      } u;
      u.i[0] = CONST_DOUBLE_LOW (x);
      u.i[1] = CONST_DOUBLE_HIGH (x);
      if (flag_fppp)
        fprintf (file, "#$%08x,#$%08x", u.i[0], u.i[1]);
      else
        fprintf (file, "#0f%.20g", u.d);
    }
  else
    {
      putc ('#', file);
      bsr_seen = 1;
      output_addr_const (file, x);
    }
}



/* Return nonzero if X, a CONST_DOUBLE, has a value that we can get
   from the Sun FPA's constant RAM.
   The value returned, anded with 0x1ff, gives the code to use in fpmove
   to get the desired constant. */
#define S_E (2.718281745910644531)
#define D_E (2.718281828459045091)
#define S_PI (3.141592741012573242)
#define D_PI (3.141592653589793116)
#define S_SQRT2 (1.414213538169860840)
#define D_SQRT2 (1.414213562373095145)
#define S_LOG2ofE (1.442695021629333496)
#define D_LOG2ofE (1.442695040888963387)
#define S_LOG2of10 (3.321928024291992188)
#define D_LOG2of10 (3.321928024887362182)
#define S_LOGEof2 (0.6931471824645996094)
#define D_LOGEof2 (0.6931471805599452862)
#define S_LOGEof10 (2.302585124969482442)
#define D_LOGEof10 (2.302585092994045901)
#define S_LOG10of2 (0.3010300099849700928)
#define D_LOG10of2 (0.3010299956639811980)
#define S_LOG10ofE (0.4342944920063018799)
#define D_LOG10ofE (0.4342944819032518167)

int
standard_sun_fpa_constant_p (x)
     rtx x;
{
	abort();
}

#undef S_E 
#undef D_E 
#undef S_PI 
#undef D_PI 
#undef S_SQRT2 
#undef D_SQRT2 
#undef S_LOG2ofE 
#undef D_LOG2ofE 
#undef S_LOG2of10 
#undef D_LOG2of10 
#undef S_LOGEof2 
#undef D_LOGEof2 
#undef S_LOGEof10 
#undef D_LOGEof10 
#undef S_LOG10of2 
#undef D_LOG10of2 
#undef S_LOG10ofE 
#undef D_LOG10ofE

