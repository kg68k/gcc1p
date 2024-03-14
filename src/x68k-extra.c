/* Special Optimizer for X68000
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

#include <stdio.h>
#include "config.h"
#include "tree.h"
#include "c-tree.h"
#include "rtl.h"
#include "regs.h"
#include "hard-reg-set.h"
#include "flags.h"

/* Vector mapping INSN_UIDs to luids.
   The luids are like uids but increase monononically always.
   We use them to see whether a jump comes from outside a given loop.  */

static int *uid_luid;

/* Get the luid of an insn.  */

#define INSN_LUID(INSN) (uid_luid[INSN_UID (INSN)])

/* 1 + largest uid of any insn.  */

static int max_uid;

/* 1 + luid of last insn.  */

static int max_luid;

/* Nonzero if there is a subroutine call in the current loop. */

static int loop_has_call;

char can_not_optimize_regs[16];

static void
peep (ins1)
     rtx ins1;
{
  rtx insn, x, pat;
  rtx cond;
  rtx operands[2];
  int i;

  if (NEXT_INSN (ins1)
      && GET_CODE (NEXT_INSN (ins1)) == BARRIER)
    return;

  insn = ins1;
  pat = PATTERN (insn);
  x = pat;
  if (GET_CODE (x) != SET)
    return;
  x = XEXP (pat, 0);
  if (GET_CODE (x) != CC0)
    return;
  x = XEXP (pat, 1);
  operands[0] = x;

  do
    {
      insn = NEXT_INSN (insn);
      if (insn == 0)
	return;
    }
  while (GET_CODE (insn) == NOTE);
  if (GET_CODE (insn) == CODE_LABEL
      || GET_CODE (insn) == BARRIER)
    return;
  pat = PATTERN (insn);
  x = pat;
  if (GET_CODE (x) != SET)
    return;
  x = XEXP (pat, 0);
  if (GET_CODE (x) != SUBREG)
    return;
  if (GET_MODE (x) != QImode)
    return;
  x = XEXP (XEXP (pat, 0), 0);
  operands[1] = x;
  if (!register_operand (x, SImode))
    return;
  x = XEXP (pat, 0);
  if (XINT (x, 1) != 0)
    return;

  x = XEXP (pat, 1);
  cond = x;

  x = XEXP (XEXP (pat, 1), 0);
  if (GET_CODE (x) != CC0)
    return;
  x = XEXP (XEXP (pat, 1), 1);
  if (GET_CODE (x) != CONST_INT)
    return;
  if (XINT (x, 0) != 0)
    return;
  do
    {
      insn = NEXT_INSN (insn);
      if (insn == 0)
	return;
    }
  while (GET_CODE (insn) == NOTE)
  ;
  if (GET_CODE (insn) == CODE_LABEL
      || GET_CODE (insn) == BARRIER)
    return;
  pat = PATTERN (insn);
  x = pat;
  if (GET_CODE (x) != SET)
    return;
  x = XEXP (pat, 0);
  if (GET_CODE (x) != CC0)
    return;
  x = XEXP (pat, 1);
  if (GET_CODE (x) != ZERO_EXTRACT)
    return;
  x = XEXP (XEXP (pat, 1), 0);
  if (!rtx_equal_p (operands[1], x))
    return;
  x = XEXP (XEXP (pat, 1), 1);
  if (GET_CODE (x) != CONST_INT)
    return;
  if (XINT (x, 0) != 1)
    return;
  x = XEXP (XEXP (pat, 1), 2);
  if (GET_CODE (x) != CONST_INT)
    return;
  if (XINT (x, 0) != 31)
    return;
  if (!(find_reg_note (insn, REG_DEAD, 0)))
    return;
  insn = NEXT_INSN (insn);
  if (insn
      && GET_CODE (insn) == JUMP_INSN
      && GET_CODE (PATTERN (insn)) == SET
      && SET_DEST (PATTERN (insn)) == pc_rtx
      && GET_CODE (SET_SRC (PATTERN (insn))) == IF_THEN_ELSE)
    {
      rtx temp = XEXP (SET_SRC (PATTERN (insn)), 0);
      x = NEXT_INSN (ins1);
      while (x != insn)
	{
	  delete_insn (x);
	  x = NEXT_INSN (ins1);
	}
      if (GET_CODE (temp) == EQ)
	{
	  switch (GET_CODE (cond))
	    {
	    case LE:
	      PUT_CODE (cond, GT);
	      break;
	    case GE:
	      PUT_CODE (cond, LT);
	      break;
	    case LT:
	      PUT_CODE (cond, GE);
	      break;
	    case GT:
	      PUT_CODE (cond, LE);
	      break;
	    case LEU:
	      PUT_CODE (cond, GTU);
	      break;
	    case GEU:
	      PUT_CODE (cond, LTU);
	      break;
	    case LTU:
	      PUT_CODE (cond, GEU);
	      break;
	    case GTU:
	      PUT_CODE (cond, LEU);
	      break;
	    case EQ:
	      PUT_CODE (cond, NE);
	      break;
	    case NE:
	      PUT_CODE (cond, EQ);
	      break;
	    }
	}
      PUT_CODE (temp, GET_CODE (cond));
    }
}

void
opt_peep (insn)
     rtx insn;
{
  for (; insn; insn = NEXT_INSN (insn))
    if (GET_CODE (insn) == INSN)
      peep (insn);
}

static void
fix_constant (insn)
     rtx insn;
{
  rtx start = insn;
  for (start = insn; start; start = NEXT_INSN (start))
    {
      if (GET_CODE (start) == INSN
	  && GET_CODE (PATTERN (start)) == SET
	  && GET_CODE (SET_SRC (PATTERN (start))) == CONST_INT
	  && GET_CODE (SET_DEST (PATTERN (start))) == REG
	  && GET_MODE (SET_DEST (PATTERN (start))) == SImode
	  && !REG_USERVAR_P (SET_DEST (PATTERN (start))))
	{
	  rtx st = NEXT_INSN (start);
	  rtx reg = SET_DEST (PATTERN (start));
	  int val = INTVAL (SET_SRC (PATTERN (start)));
	  for (; st; st = NEXT_INSN (st))
	    {
	      if (GET_CODE (st) == CALL_INSN
		  || GET_CODE (st) == JUMP_INSN
		  || GET_CODE (st) == CODE_LABEL)
		break;
	      if (GET_CODE (st) == INSN
		  && (GET_CODE (PATTERN (st)) == PARALLEL
		      || GET_CODE (PATTERN (st)) == ASM_OPERANDS))
		break;
	      if (GET_CODE (st) == INSN
		  && GET_CODE (PATTERN (st)) == SET
		  && reg_mentioned_p (reg, SET_DEST (PATTERN (st))))
		{
		  rtx dest = SET_DEST (PATTERN (st));
		  if (GET_CODE (dest) == REG && REGNO (reg) == REGNO (dest))
		    {
		      if (GET_CODE (SET_SRC (PATTERN (st))) == CONST_INT
			  && val == INTVAL (SET_SRC (PATTERN (st)))
			  && !REG_USERVAR_P (SET_DEST (PATTERN (st))))
			{
			  delete_insn (st);
			}
		      else
			break;
		    }
		  else
		    break;
		}
	      if (GET_CODE (st) == INSN
		  && GET_CODE (PATTERN (st)) == SET
		  && GET_CODE (SET_SRC (PATTERN (st))) == CONST_INT
		  && val == INTVAL (SET_SRC (PATTERN (st)))
		  && GET_CODE (SET_DEST (PATTERN (st))) == MEM
		  && (int) GET_MODE (SET_DEST (PATTERN (st))) < (int) SImode
		  && REGNO (reg) < 8)
		{
		  SET_SRC (PATTERN (st))
		    = gen_rtx (REG, GET_MODE (SET_DEST (PATTERN (st))), REGNO (reg));
		}
	    }
	}
    }
}


/* Return 1 if somewhere in X is a LABEL_REF to a label
   located between BEG and END.  */

static int
can_jump_into_range_p (x, beg, end)
     rtx x;
     int beg, end;
{
  register enum rtx_code code = GET_CODE (x);
  register int i;
  register char *fmt;

  if (code == LABEL_REF)
    {
      register int luid = INSN_LUID (XEXP (x, 0));
      return luid > beg && luid < end;
    }

  fmt = GET_RTX_FORMAT (code);
  for (i = GET_RTX_LENGTH (code) - 1; i >= 0; i--)
    {
      if (fmt[i] == 'e')
	{
	  if (can_jump_into_range_p (XEXP (x, i), beg, end))
	    return 1;
	}
      else if (fmt[i] == 'E')
	{
	  register int j;
	  for (j = 0; j < XVECLEN (x, i); j++)
	    if (can_jump_into_range_p (XVECEXP (x, i, j), beg, end))
	      return 1;
	}
    }

  return 0;
}


/* Verify that the ostensible loop starting at START
   really is a loop: nothing jumps into it from outside.
   Return the marker for the end of the loop, or zero if not a real loop.

   Also set the variables `loop_has_call' */

static rtx
verify_loop (f, start)
     rtx f, start;
{
  register int level = 1;
  register rtx insn, end;
  register rtx p;

  /* First find the LOOP_END that matches.
     Also check each insn for storing in memory and record where.  */

  for (insn = NEXT_INSN (start); level > 0; insn = NEXT_INSN (insn))
    {
      if (insn == 0)
	/* Parse errors can cause a loop-beg with no loop-end.  */
	return 0;
      if (GET_CODE (insn) == NOTE)
	{
	  if (NOTE_LINE_NUMBER (insn) == NOTE_INSN_LOOP_BEG)
	    {
	      ++level;
	    }
	  else if (NOTE_LINE_NUMBER (insn) == NOTE_INSN_LOOP_END)
	    {
	      --level;
	      if (level == 0)
		{
		  end = insn;
		  break;
		}
	    }
	  /* Don't optimize loops containing setjmps.
	     On some machines, longjmp does not restore the reg
	     values as of the time of the setjmp.  */
	  else if (NOTE_LINE_NUMBER (insn) == NOTE_INSN_SETJMP)
	    return 0;
	}
      else if (GET_CODE (insn) == CALL_INSN)
	{
	  loop_has_call = 1;
	}
    }

  /* Now scan all jumps in the function and see if any of them can
     reach a label within the range of the loop.  */

  for (insn = f; insn; insn = NEXT_INSN (insn))
    if (GET_CODE (insn) == JUMP_INSN
    /* Don't get fooled by jumps inserted by loop-optimize.
       They don't have valid LUIDs, and they never jump into loops.  */
	&& INSN_UID (insn) < max_uid
	&& (INSN_LUID (insn) < INSN_LUID (start)
	    || INSN_LUID (insn) > INSN_LUID (end))
    /* We have a jump that is outside the loop.
       Does it jump into the loop?  */
	&& can_jump_into_range_p (PATTERN (insn),
				  INSN_LUID (start), INSN_LUID (end)))
      return 0;

  /* Determine whether this loop starts with a jump down
     to a test at the end.  */
  p = NEXT_INSN (start);
  while (p != end
	 && GET_CODE (p) != CODE_LABEL && GET_CODE (p) != JUMP_INSN)
    p = NEXT_INSN (p);

  /* "Loop" contains neither jumps nor labels;
     it must have been a dummy.  Think no more about it.  */
  if (p == end)
    return 0;

  if (GET_CODE (p) == JUMP_INSN)
    {
      rtx loop_top = NEXT_INSN (p);
      /* Loop entry will never be a conditional jump.
	 If we see one, this must not be a real loop.
	 Also, a return-insn isn't a jump to enter the loop.  */
      if (GET_CODE (loop_top) != BARRIER
	  || GET_CODE (PATTERN (p)) != SET)
	return 0;
      /* Get the label at which the loop is entered.  */
      p = XEXP (SET_SRC (PATTERN (p)), 0);
      /* Check to see whether the jump actually
	 jumps out of the loop (meaning it's no loop).
	 This case can happen for things like
	 do {..} while (0).  */
      if (p == 0
	  || INSN_LUID (p) < INSN_LUID (start)
	  || INSN_LUID (p) >= INSN_LUID (end))
	return 0;
    }
  return end;
}

static int
check_reg_use (reg, start, end)
     rtx reg, start, end;
{
  rtx x;
  for (x = start; x != end; x = NEXT_INSN (x))
    if (GET_CODE (x) == INSN
	&& GET_CODE (PATTERN (x)) == SET)
      {
	rtx src = SET_SRC (PATTERN (x));
	rtx dest = SET_DEST (PATTERN (x));
	if (GET_CODE (src) == MEM
	    && (GET_CODE (XEXP (src, 0)) == PRE_DEC
		|| GET_CODE (XEXP (src, 0)) == POST_INC)
	    && (REGNO (XEXP (XEXP (src, 0), 0)) == REGNO (reg)))
	  return 1;
	if (GET_CODE (dest) == MEM
	    && (GET_CODE (XEXP (dest, 0)) == PRE_DEC
		|| GET_CODE (XEXP (dest, 0)) == POST_INC)
	    && (REGNO (XEXP (XEXP (dest, 0), 0)) == REGNO (reg)))
	  return 1;
	if (GET_MODE (dest) == DFmode
	    && GET_CODE (dest) == REG
	    && (REGNO (dest) == REGNO (reg)
		|| REGNO (dest) + 1 == REGNO (reg)))
	  return 1;
      }
  return 0;
}

static void
move_simple (start, end, f)
     rtx start, end, f;
{
  rtx x;
  int i, ok;
#if 0
  extern char regs_ever_live[];
  ok = 0;
  for (i = 11; i < 14; i++)
    if (regs_ever_live[i] == 0)
      ok++;
  if (ok > 1 && loop_has_call)
    {
      int opt = 1;
      int count = 0;
      int call = 0;
      for (x = start; x != end; x = NEXT_INSN (x))
	{
	  if (GET_CODE (x) == NOTE &&
	      NOTE_LINE_NUMBER (x) == NOTE_INSN_LOOP_CONT)
	    break;
	  if (GET_CODE (x) == INSN)
	    count++;
	  if (GET_CODE (x) == CALL_INSN)
	    call++;
	  if (GET_CODE (x) == JUMP_INSN)
	    {
	      opt = 0;
	      break;
	    }
	}
      if (opt
	  && GET_CODE (x) == NOTE
	  && NOTE_LINE_NUMBER (x) == NOTE_INSN_LOOP_CONT
	  && count < 30
	  && call < 3)
	for (x = start; x != end; x = NEXT_INSN (x))
	  if (GET_CODE (x) == CALL_INSN)
	    {
	      rtx new_reg;
	      rtx mem =
	      GET_CODE (PATTERN (x)) == SET
	      ? XEXP (SET_SRC (PATTERN (x)), 0)
	      : XEXP (PATTERN (x), 0);
	      if (GET_CODE (XEXP (mem, 0)) != REG)
		{
		  for (i = 11; i < 14 && regs_ever_live[i]; i++)
		    ;
		  regs_ever_live[i] = 1;
		  new_reg = gen_rtx (REG, SImode, i);
		  emit_insn_before (gen_rtx (SET, VOIDmode, new_reg, XEXP (mem, 0)), x);
		  XEXP (mem, 0) = new_reg;
		}
	    }
    }
#endif
  for (x = start; x != end; x = NEXT_INSN (x))
    {
      if (GET_CODE (x) == INSN
	  && GET_CODE (PATTERN (x)) == SET
	  && CONSTANT_P (SET_SRC (PATTERN (x)))
	  && GET_CODE (SET_DEST (PATTERN (x))) == REG
	  && !REG_USERVAR_P (SET_DEST (PATTERN (x)))
	  && !REG_FUNCTION_VALUE_P (SET_DEST (PATTERN (x)))
       && !(loop_has_call && call_used_regs[REGNO (SET_DEST (PATTERN (x)))])
	  && !can_not_optimize_regs[REGNO (SET_DEST (PATTERN (x)))])
	{
	  rtx try_move_reg = SET_DEST (PATTERN (x));
	  rtx st;
	  int optimize;
	  int have_jump = 0;

	  /* This insn must use once more. */
	  for (optimize = 1, st = start; st != x; st = NEXT_INSN (st))
	    if (GET_CODE (st) == JUMP_INSN)
	      {
		optimize = 0;
		break;
	      }
	  if (!optimize)
	    {
	      /* All of JUMP in loop must jump into loop */
	      for (st = start; st != end; st = NEXT_INSN (st))
		if (GET_CODE (st) == JUMP_INSN
		    && !can_jump_into_range_p (PATTERN (st),
					INSN_LUID (start), INSN_LUID (end)))
		  break;

	      /* This insn must use once more. */
	      if (st == end)
		{
		  /* If form insn X to END in LABEL then X in conditional jump.
		     It can't optimize */
		  for (st = NEXT_INSN (x); st != end; st = NEXT_INSN (st))
		    if (GET_CODE (st) == CODE_LABEL)
		      break;
		  if (st == end)
		    optimize = 1;
		}
	    }
	  if (!optimize)
	    continue;

	  /* This reg def in loop is only one */
	  if (reg_used_between_p (try_move_reg, PREV_INSN (start), x))
	    continue;

	  /* X6_22,added.  must check DFmode set insn */
	  if (check_reg_use (try_move_reg, PREV_INSN (start), x))
	    continue;

	  if (reg_set_between_p (try_move_reg, x, NEXT_INSN (end)))
	    continue;

	  /* X6_07,added. MEM ref must check POST_INC or PRE_DEC */
	  if (check_reg_use (try_move_reg, x, NEXT_INSN (end)))
	    continue;

	  /* OK optimize it */
	  emit_insn_before (PATTERN (x), start);
	  delete_insn (x);
	}
    }
}


void
m68k_optimize (f)
     /* f is the first instruction of a chain of insns for one function */
     rtx f;
{
  register rtx insn;
  register int i;
  rtx end;
  rtx last_insn;

  /* X68k optimize */
  fix_constant (f);

  /* First find the last real insn, and count the number of insns,
     and assign insns their luids.  */

  for (insn = f, i = 0; insn; insn = NEXT_INSN (insn))
    if (INSN_UID (insn) > i)
      i = INSN_UID (insn);

  max_uid = i + 1;
  uid_luid = (int *) alloca ((i + 1) * sizeof (int));
  bzero (uid_luid, (i + 1) * sizeof (int));

  /* Compute the mapping from uids to luids.
     LUIDs are numbers assigned to insns, like uids,
     except that luids increase monotonically through the code.
     Don't assign luids to line-number NOTEs, so that the distance in luids
     between two insns is not affected by -g.  */

  for (insn = f, i = 0; insn; insn = NEXT_INSN (insn))
    {
      last_insn = insn;
      if (GET_CODE (insn) != NOTE
	  || NOTE_LINE_NUMBER (insn) < 0)
	INSN_LUID (insn) = ++i;
      else
	/* Give a line number note the same luid as preceding insn.  */
	INSN_LUID (insn) = i;
    }

  max_luid = i;

  /* Don't leave gaps in uid_luid for insns that have been
     deleted.  It is possible that the first or last insn
     using some register has been deleted by cross-jumping.
     Make sure that uid_luid for that former insn's uid
     points to the general area where that insn used to be.  */
  for (i = 0; i < max_uid; i++)
    {
      uid_luid[0] = uid_luid[i];
      if (uid_luid[0] != 0)
	break;
    }
  for (i = 0; i < max_uid; i++)
    if (uid_luid[i] == 0)
      uid_luid[i] = uid_luid[i - 1];

  /* Find and process each loop.
     We scan from the end, and process each loop when its start is seen,
     so we process innermost loops first.  */

  for (insn = last_insn; insn; insn = PREV_INSN (insn))
    if (GET_CODE (insn) == NOTE
	&& NOTE_LINE_NUMBER (insn) == NOTE_INSN_LOOP_BEG)
      {
	/* Make sure it really is a loop -- no jumps in from outside.  */
	end = verify_loop (f, insn);
	if (end != 0)
	  /* If so, optimize this loop.  */
	  move_simple (insn, end, f);
      }
  for (i = 0; i < 16; i++)
    can_not_optimize_regs[i] = 0;
}



#define INDEX_BASE_OK_REG(REG)	\
(strict ? REGNO_OK_FOR_BASE_P (REGNO ((REG)))	\
        : REG_OK_FOR_BASE_P ((REG)))

#define INDEX_INDEX_OK_REG(REG)	\
(strict ? REGNO_OK_FOR_INDEX_P (REGNO ((REG)))	\
        : REG_OK_FOR_INDEX_P ((REG)))

#define CONST_OK_INDEX(VAL) (INTVAL ((VAL)) < 32767 && INTVAL ((VAL)) > -32768)

int
memory_indirect_address_p (addr, strict)
     rtx addr;
     int strict;
{
  /* only 68020 */
  if (!TARGET_68020)
    return 0;

  if (GET_CODE (addr) == MEM)
    {
      addr = XEXP (addr, 0);
      /* ([a0.l]) */
      if (GET_CODE (addr) == REG)
	return 0;
      else if (GET_CODE (addr) == PLUS)
	{
	  rtx base_reg;
	  rtx index;
	  if (GET_CODE (XEXP (addr, 0)) == REG
	      && INDEX_BASE_OK_REG (XEXP (addr, 0)))
	    {
	      base_reg = XEXP (addr, 0);
	      index = XEXP (addr, 1);
	    }
	  else if (GET_CODE (XEXP (addr, 1)) == REG
		   && INDEX_BASE_OK_REG (XEXP (addr, 1)))
	    {
	      base_reg = XEXP (addr, 1);
	      index = XEXP (addr, 0);
	    }
	  else
	    return 0;

	  switch (GET_CODE (index))
	    {
	    case SIGN_EXTEND:
	      if (GET_CODE (XEXP (index, 0)) == REG
		  && GET_MODE (XEXP (index, 0)) == HImode
		  && INDEX_INDEX_OK_REG (XEXP (index, 0)))
		/* ([a0,d0.w]) */
		return 1;
	      else
		return 0;
	      break;
	    case MULT:
	      {
		int scale;
		if (GET_CODE (XEXP (index, 1)) != CONST_INT)
		  return 0;
		scale = INTVAL (XEXP (index, 1));
		if (scale != 2
		    && scale != 4
		    && scale != 8)
		  return 0;
		if (GET_CODE (XEXP (index, 0)) == REG
		    && INDEX_INDEX_OK_REG (XEXP (index, 0)))
		  /* ([a0,d0.l* 2]) */
		  return 1;
		else if (GET_CODE (XEXP (index, 0)) == SIGN_EXTEND
			 && GET_CODE (XEXP (XEXP (index, 0), 0)) == REG
			 && GET_MODE (XEXP (XEXP (index, 0), 0)) == HImode
			 && INDEX_INDEX_OK_REG (XEXP (XEXP (index, 0), 0)))
		  /* ([a0,d0.w* 2]) */
		  return 1;
		else
		  return 0;
	      }
	      break;
	    case REG:
	      if (INDEX_INDEX_OK_REG (index))
		/* ([a0,d0.l]) */
		return 1;
	      else
		return 0;
	      break;
	    case PLUS:
	      {
		if (GET_CODE (XEXP (index, 0)) == REG
		    && GET_CODE (XEXP (index, 1)) == CONST_INT
		    && CONST_OK_INDEX (XEXP (index, 1))
		    && INDEX_INDEX_OK_REG (XEXP (index, 0)))
		  /* ([10,a0,d0.l]) */
		  return 1;
		else if (GET_CODE (XEXP (index, 1)) == REG
			 && GET_CODE (XEXP (index, 0)) == CONST_INT
			 && CONST_OK_INDEX (XEXP (index, 0))
			 && INDEX_INDEX_OK_REG (XEXP (index, 1)))
		  /* ([10,a0,d0.l]) */
		  return 1;
		else
		  return 0;
	      }
	      break;
	    case CONST_INT:
	      if (CONST_OK_INDEX (index))
		/* ([10,a0]) */
		return 1;
	      else
		return 0;
	      break;
	    default:
	      return 0;
	    }
	}
    }
  else if (GET_CODE (addr) == PLUS)
    {
      rtx mem_part;
      rtx index;
      if (GET_CODE (XEXP (addr, 0)) == MEM)
	{
	  mem_part = XEXP (addr, 0);
	  index = XEXP (addr, 1);
	}
      else if (GET_CODE (XEXP (addr, 1)) == MEM)
	{
	  mem_part = XEXP (addr, 1);
	  index = XEXP (addr, 0);
	}
      else
	return 0;

      if (GET_CODE (mem_part) == MEM && GET_CODE (index) == MEM)
	return 0;

      mem_part = XEXP (mem_part, 0);

      if (GET_CODE (mem_part) == REG
	  && INDEX_BASE_OK_REG (mem_part))
	switch (GET_CODE (index))
	  {
	  case PLUS:
	    {
	      rtx const_p;
	      rtx reg_p;
	      if (GET_CODE (XEXP (index, 0)) == CONST_INT)
		{
		  const_p = XEXP (index, 0);
		  reg_p = XEXP (index, 1);
		}
	      else if (GET_CODE (XEXP (index, 1)) == CONST_INT)
		{
		  const_p = XEXP (index, 1);
		  reg_p = XEXP (index, 0);
		}
	      else
		return 0;

	      if (!CONST_OK_INDEX (const_p))
		return 0;

	      if (GET_CODE (reg_p) == REG
		  && INDEX_INDEX_OK_REG (reg_p))
		/* ([a0],d0.l,10) */
		return 1;
	      else if (GET_CODE (reg_p) == SIGN_EXTEND
		       && GET_CODE (XEXP (reg_p, 0)) == REG
		       && GET_MODE (XEXP (reg_p, 0)) == HImode
		       && INDEX_INDEX_OK_REG (XEXP (reg_p, 0)))
		/* ([a0],d0.w,10) */
		return 1;
	      else if (GET_CODE (reg_p) == MULT)
		{
		  int scale = INTVAL (XEXP (reg_p, 1));
		  reg_p = XEXP (reg_p, 0);
		  if (GET_CODE (reg_p) == REG
		      && INDEX_INDEX_OK_REG (reg_p)
		      && (scale == 2 || scale == 4 || scale == 8))
		    /* ([a0],d0.l*4,10) */
		    return 1;
		  else if (GET_CODE (reg_p) == SIGN_EXTEND
			   && GET_CODE (XEXP (reg_p, 0)) == REG
			   && GET_MODE (XEXP (reg_p, 0)) == HImode
			   && INDEX_INDEX_OK_REG (XEXP (reg_p, 0))
			   && (scale == 2 || scale == 4 || scale == 8))
		    /* ([a0],d0.w*4,10) */
		    return 1;
		  else
		    return 0;
		}
	    }
	    break;
	  case REG:
	    if (INDEX_INDEX_OK_REG (index))
	      /* ([a0],d0.l) */
	      return 1;
	    else
	      return 0;
	    break;
	  case SIGN_EXTEND:
	    if (GET_CODE (XEXP (index, 0)) == REG
		&& GET_MODE (XEXP (index, 0)) == HImode
		&& INDEX_INDEX_OK_REG (XEXP (index, 0)))
	      /* ([a0],d0.w) */
	      return 1;
	    else
	      return 0;
	    break;
	  case MULT:
	    {
	      rtx scale = XEXP (index, 1);
	      rtx reg = XEXP (index, 0);
	      if (GET_CODE (scale) != CONST_INT
		  || (!(INTVAL (scale) == 2
			|| INTVAL (scale) == 4
			|| INTVAL (scale) == 8)))
		return 0;

	      if (GET_CODE (reg) == REG
		  && INDEX_INDEX_OK_REG (reg))
		/* ([a0],d0.l*4) */
		return 1;
	      else if (GET_CODE (reg) == SIGN_EXTEND
		       && GET_CODE (XEXP (reg, 0)) == REG
		       && GET_MODE (XEXP (reg, 0)) == HImode
		       && INDEX_INDEX_OK_REG (reg))
		/* ([a0],d0.w*4,10) */
		return 1;
	      else
		return 0;
	    }
	    break;
	  case CONST_INT:
	    if (CONST_OK_INDEX (index))
	      /* ([a0],10) */
	      return 1;
	    else
	      return 0;
	    break;
	  default:
	    return 0;
	    break;
	  }
      else if (GET_CODE (mem_part) == PLUS)
	{
	  rtx mem_base;
	  rtx mem_index;
	  if (GET_CODE (XEXP (mem_part, 0)) == REG
	      && INDEX_BASE_OK_REG (XEXP (mem_part, 0)))
	    {
	      mem_base = XEXP (mem_part, 0);
	      mem_index = XEXP (mem_part, 1);
	    }
	  else if (GET_CODE (XEXP (mem_part, 1)) == REG
	           && INDEX_BASE_OK_REG (XEXP (mem_part, 1)))
	    {
	      mem_base = XEXP (mem_part, 1);
	      mem_index = XEXP (mem_part, 0);
	    }
	  else
	    return 0;

	  if (GET_CODE (index) == CONST_INT
	      && CONST_OK_INDEX (index))
	    {
	      if (GET_CODE (mem_index) == CONST_INT
		  && CONST_OK_INDEX (mem_index))
		/* ([10,a0],20) */
		return 1;
	      else if (GET_CODE (mem_index) == REG
		       && INDEX_INDEX_OK_REG (mem_index))
		/* ([a0,d0.l],20) */
		return 1;
	      else if (GET_CODE (mem_index) == SIGN_EXTEND
		       && GET_CODE (XEXP (mem_index, 0)) == REG
		       && GET_MODE (XEXP (mem_index, 0)) == HImode
		       && INDEX_INDEX_OK_REG (XEXP (mem_index, 0)))
		/* ([a0,d0.w],20) */
		return 1;
	      else if (GET_CODE (mem_index) == MULT)
		{
		  rtx scale = XEXP (mem_index, 1);
		  rtx reg = XEXP (mem_index, 0);
		  if (GET_CODE (scale) != CONST_INT
		      || (!(INTVAL (scale) == 2
			    || INTVAL (scale) == 4
			    || INTVAL (scale) == 8)))
		    return 0;
		  if (GET_CODE (reg) == REG
		      && INDEX_INDEX_OK_REG (reg))
		    /* ([a0,d0.l*4],20) */
		    return 1;
		  else if (GET_CODE (reg) == SIGN_EXTEND
			   && GET_CODE (XEXP (reg, 0)) == REG
			   && GET_MODE (XEXP (reg, 0)) == HImode
			   && INDEX_INDEX_OK_REG (XEXP (reg, 0)))
		    /* ([a0,d0.w*4],20) */
		    return 1;
		  return 0;
		}
	      else if (GET_CODE (mem_index) == PLUS)
		{
		  rtx const_p;
		  rtx reg_p;
		  if (GET_CODE (XEXP (mem_index, 0)) == CONST_INT)
		    {
		      const_p = XEXP (mem_index, 0);
		      reg_p = XEXP (mem_index, 1);
		    }
		  else if (GET_CODE (XEXP (mem_index, 1)) == CONST_INT)
		    {
		      const_p = XEXP (mem_index, 1);
		      reg_p = XEXP (mem_index, 0);
		    }
		  else
		    return 0;

		  if (!CONST_OK_INDEX (const_p))
		    return 0;

		  if (GET_CODE (reg_p) == REG
		      && INDEX_INDEX_OK_REG (reg_p))
		    /* ([10,a0,d0.l],20) */
		    return 1;
		  else if (GET_CODE (reg_p) == SIGN_EXTEND
			   && GET_CODE (XEXP (reg_p, 0)) == REG
			   && GET_MODE (XEXP (reg_p, 0)) == HImode
			   && INDEX_INDEX_OK_REG (XEXP (reg_p, 0)))
		    /* ([5,a0,d0.w],20) */
		    return 1;
		  else if (GET_CODE (reg_p) == MULT)
		    {
		      rtx scale = XEXP (reg_p, 1);
		      reg_p = XEXP (reg_p, 0);

		      if (GET_CODE (scale) != CONST_INT
			  || (!(INTVAL (scale) == 2
				|| INTVAL (scale) == 4
				|| INTVAL (scale) == 8)))
			return 0;

		      if (GET_CODE (reg_p) == REG
			  && INDEX_INDEX_OK_REG (reg_p))
			/* ([10,a0,d0.l*4],20) */
			return 1;
		      else if (GET_CODE (reg_p) == SIGN_EXTEND
			       && GET_CODE (XEXP (reg_p, 0)) == REG
			       && GET_MODE (XEXP (reg_p, 0)) == HImode
			       && INDEX_INDEX_OK_REG (XEXP (reg_p, 0)))
			/* ([10,a0,d0.w*4],20) */
			return 1;
		      else
			return 0;
		    }
		  else
		    return 0;
		}
	      else
		return 0;
	    }
	  else if (GET_CODE (index) == REG
		   && INDEX_INDEX_OK_REG (index))
	    if (GET_CODE (mem_index) == CONST_INT
		&& CONST_OK_INDEX (mem_index))
	      /* ([10,a0],d0.l) */
	      return 1;
	    else
	      return 0;
	  else if (GET_CODE (index) == MULT
		   && GET_CODE (mem_index) == CONST_INT
		   && CONST_OK_INDEX (mem_index))
	    {
	      rtx scale = XEXP (index, 1);
	      rtx reg_p = XEXP (index, 0);
	      if (GET_CODE (scale) != CONST_INT
		  || (!(INTVAL (scale) == 2
			|| INTVAL (scale) == 4
			|| INTVAL (scale) == 8)))
		return 0;
	      if (GET_CODE (reg_p) == REG
		  && INDEX_INDEX_OK_REG (reg_p))
	        /* ([10,a0],d0.l*4) */
		return 1;
	      else if (GET_CODE (reg_p) == SIGN_EXTEND
		       && GET_CODE (XEXP (reg_p, 0)) == REG
		       && GET_MODE (XEXP (reg_p, 0)) == HImode
		       && INDEX_INDEX_OK_REG (XEXP (reg_p, 0)))
		/* ([10,a0],d0.w*4) */
		return 1;
	      else
		return 0;
	    }
	  else if (GET_CODE (index) == SIGN_EXTEND
		   && GET_CODE (XEXP (index, 0)) == REG
		   && GET_CODE (XEXP (index, 0)) == HImode
		   && INDEX_INDEX_OK_REG (XEXP (index, 0)))
	    if (GET_CODE (mem_index) == CONST_INT
		&& CONST_OK_INDEX (mem_index))
	      /* ([10,a0],d0.w) */
	      return 1;
	    else
	      return 0;
	  else if (GET_CODE (index) == PLUS)
	    {
	      rtx const_p;
	      rtx reg_p;
	      if (GET_CODE (XEXP (index, 0)) == CONST_INT)
		{
		  const_p = XEXP (index, 0);
		  reg_p = XEXP (index, 1);
		}
	      else if (GET_CODE (XEXP (index, 1)) == CONST_INT)
		{
		  const_p = XEXP (index, 1);
		  reg_p = XEXP (index, 0);
		}
	      else
		return 0;

	      if (!CONST_OK_INDEX (const_p))
		return 0;

	      if (GET_CODE (reg_p) == REG
		  && INDEX_INDEX_OK_REG (reg_p))
		/* ([10,a0],d0.l,10) */
		return 1;
	      else if (GET_CODE (reg_p) == SIGN_EXTEND
		       && GET_CODE (XEXP (reg_p, 0)) == REG
		       && GET_MODE (XEXP (reg_p, 0)) == HImode
		       && INDEX_INDEX_OK_REG (XEXP (reg_p, 0)))
	      /* ([10,a0],d0.w,5) */
		return 1;
	      else if (GET_CODE (reg_p) == MULT)
		{
		  rtx scale = XEXP (reg_p, 1);
		  reg_p = XEXP (reg_p, 0);

		  if (GET_CODE (scale) != CONST_INT
		      || (!(INTVAL (scale) == 2
			    || INTVAL (scale) == 4
			    || INTVAL (scale) == 8)))
		    return 0;

		  if (GET_CODE (reg_p) == REG
		      && INDEX_INDEX_OK_REG (reg_p))
		    /* ([10,a0],d0.l*4,5) */
		    return 1;
		  else if (GET_CODE (reg_p) == SIGN_EXTEND
			   && GET_CODE (XEXP (reg_p, 0)) == REG
			   && GET_MODE (XEXP (reg_p, 0)) == HImode
			   && INDEX_INDEX_OK_REG (XEXP (reg_p, 0)))
		    /* ([10,a0],d0.w*4,5) */
		    return 1;
		  else
		    return 0;
		}
	      else
		return 0;
	    }
	  else
	    return 0;
	}
      else
	return 0;
    }
  return 0;
}

void
print_mem_indirect_operand (file, addr)
     FILE *file;
     rtx addr;
{
  if (!TARGET_68020)
    abort ();
  if (GET_CODE (addr) == MEM)
    {
      addr = XEXP (addr, 0);
      if (GET_CODE (addr) == REG)
	{
#if 1
	  abort ();
#else
	  fprintf (file, "([%s])", reg_names[REGNO (addr)]);
#endif
	  return;
	}
      else if (GET_CODE (addr) == PLUS)
	{
	  rtx base_reg;
	  rtx index;
	  if (GET_CODE (XEXP (addr, 0)) == REG
	      && REGNO_OK_FOR_BASE_P (REGNO (XEXP (addr, 0))))
	    {
	      base_reg = XEXP (addr, 0);
	      index = XEXP (addr, 1);
	    }
	  else if (GET_CODE (XEXP (addr, 1)) == REG
		   && REGNO_OK_FOR_BASE_P (REGNO (XEXP (addr, 1))))
	    {
	      base_reg = XEXP (addr, 1);
	      index = XEXP (addr, 0);
	    }
	  else
	    abort ();

	  switch (GET_CODE (index))
	    {
	    case SIGN_EXTEND:
	      fprintf (file,
		       "([%s,%s.w])",
		       reg_names[REGNO (base_reg)],
		       reg_names[REGNO (XEXP (index, 0))]);
	      break;
	    case MULT:
	      {
		int scale;
		if (GET_CODE (XEXP (index, 1)) != CONST_INT)
		  abort ();
		scale = INTVAL (XEXP (index, 1));
		if (GET_CODE (XEXP (index, 0)) == REG)
		  fprintf (file,
			   "([%s,%s.l*%d])",
			   reg_names[REGNO (base_reg)],
			   reg_names[REGNO (XEXP (index, 0))],
			   scale);
		else if (GET_CODE (XEXP (index, 0)) == SIGN_EXTEND)
		  fprintf (file,
			   "([%s,%s.w*%d])",
			   reg_names[REGNO (base_reg)],
			   reg_names[REGNO (XEXP (XEXP (index, 0), 0))],
			   scale);
		else
		  abort ();
	      }
	      break;
	    case REG:
	      fprintf (file,
		       "([%s,%s.l])",
		       reg_names[REGNO (base_reg)],
		       reg_names[REGNO (index)]);
	      break;
	    case PLUS:
	      {
		if (GET_CODE (XEXP (index, 0)) == REG
		    && GET_CODE (XEXP (index, 1)) == CONST_INT)
		  fprintf (file,
			   "([%d,%s,%s.l])",
			   INTVAL (XEXP (index, 1)),
			   reg_names[REGNO (base_reg)],
			   reg_names[REGNO (XEXP (index, 0))]);
		else if (GET_CODE (XEXP (index, 1)) == REG
			 && GET_CODE (XEXP (index, 0)) == CONST_INT)
		  fprintf (file,
			   "([%d,%s,%s.l])",
			   INTVAL (XEXP (index, 0)),
			   reg_names[REGNO (base_reg)],
			   reg_names[REGNO (XEXP (index, 1))]);
	      }
	      break;
	    case CONST_INT:
	      fprintf (file,
		       "([%d,%s])",
		       INTVAL (index),
		       reg_names[REGNO (base_reg)]);
	      break;
	    default:
	      abort ();
	    }
	}
    }
  else if (GET_CODE (addr) == PLUS)
    {
      rtx mem_part;
      rtx index;
      if (GET_CODE (XEXP (addr, 0)) == MEM)
	{
	  mem_part = XEXP (addr, 0);
	  index = XEXP (addr, 1);
	}
      else if (GET_CODE (XEXP (addr, 1)) == MEM)
	{
	  mem_part = XEXP (addr, 1);
	  index = XEXP (addr, 0);
	}
      else
	abort ();

      if (GET_CODE (mem_part) == MEM && GET_CODE (index) == MEM)
	abort ();

      mem_part = XEXP (mem_part, 0);

      if (GET_CODE (mem_part) == REG)
	switch (GET_CODE (index))
	  {
	  case PLUS:
	    {
	      rtx const_p;
	      rtx reg_p;
	      if (GET_CODE (XEXP (index, 0)) == CONST_INT)
		{
		  const_p = XEXP (index, 0);
		  reg_p = XEXP (index, 1);
		}
	      else if (GET_CODE (XEXP (index, 1)) == CONST_INT)
		{
		  const_p = XEXP (index, 1);
		  reg_p = XEXP (index, 0);
		}
	      else
		abort ();
	      if (GET_CODE (reg_p) == REG)
		fprintf (file,
			 "([%s],%s.l,%d)",
			 reg_names[REGNO (mem_part)],
			 reg_names[REGNO (reg_p)],
			 INTVAL (const_p));
	      else if (GET_CODE (reg_p) == SIGN_EXTEND)
		fprintf (file,
			 "([%s],%s.w,%d)",
			 reg_names[REGNO (mem_part)],
			 reg_names[REGNO (XEXP (reg_p, 0))],
			 INTVAL (const_p));
	      else if (GET_CODE (reg_p) == MULT)
		{
		  int scale = INTVAL (XEXP (reg_p, 1));
		  reg_p = XEXP (reg_p, 0);
		  if (GET_CODE (reg_p) == REG)
		    fprintf (file,
			     "([%s],%s.l*%d,%d)",
			     reg_names[REGNO (mem_part)],
			     reg_names[REGNO (reg_p)],
			     scale,
			     INTVAL (const_p));
		  else if (GET_CODE (reg_p) == SIGN_EXTEND)
		    fprintf (file,
			     "([%s],%s.w*%d,%d)",
			     reg_names[REGNO (mem_part)],
			     reg_names[REGNO (XEXP (reg_p, 0))],
			     scale,
			     INTVAL (const_p));
		  else
		    abort ();
		}
	    }
	    break;
	  case REG:
	    fprintf (file,
		     "([%s],%s.l)",
		     reg_names[REGNO (mem_part)],
		     reg_names[REGNO (index)]);
	    break;
	  case SIGN_EXTEND:
	    fprintf (file,
		     "([%s],%s.w)",
		     reg_names[REGNO (mem_part)],
		     reg_names[REGNO (XEXP (index, 0))]);
	    break;
	  case MULT:
	    {
	      rtx scale = XEXP (index, 1);
	      rtx reg = XEXP (index, 0);
	      if (GET_CODE (reg) == REG)
		fprintf (file,
			 "([%s],%s.l*%d)",
			 reg_names[REGNO (mem_part)],
			 reg_names[REGNO (reg)],
			 INTVAL (scale));
	      else if (GET_CODE (reg) == SIGN_EXTEND)
		fprintf (file,
			 "([%s],%s.w*%d)",
			 reg_names[REGNO (mem_part)],
			 reg_names[REGNO (XEXP (reg, 0))],
			 INTVAL (scale));
	      else
		abort ();
	    }
	    break;
	  case CONST_INT:
	    fprintf (file,
		     "([%s],%d)",
		     reg_names[REGNO (mem_part)],
		     INTVAL (index));
	    break;
	  default:
	    abort ();
	    break;
	  }
      else if (GET_CODE (mem_part) == PLUS)
	{
	  rtx mem_base;
	  rtx mem_index;
	  if (GET_CODE (XEXP (mem_part, 0)) == REG
	      && REGNO_OK_FOR_BASE_P (REGNO (XEXP (mem_part, 0))))
	    {
	      mem_base = XEXP (mem_part, 0);
	      mem_index = XEXP (mem_part, 1);
	    }
	  else if (GET_CODE (XEXP (mem_part, 1)) == REG
	           && REGNO_OK_FOR_BASE_P (REGNO (XEXP (mem_part, 1))))
	    {
	      mem_base = XEXP (mem_part, 1);
	      mem_index = XEXP (mem_part, 0);
	    }
	  else
	    abort ();

	  if (GET_CODE (index) == CONST_INT)
	    {
	      if (GET_CODE (mem_index) == CONST_INT)
		fprintf (file,
			 "([%d,%s],%d)",
			 INTVAL (mem_index),
			 reg_names[REGNO (mem_base)],
			 INTVAL (index));
	      else if (GET_CODE (mem_index) == REG)
		fprintf (file,
			 "([%s,%s.l],%d)",
			 reg_names[REGNO (mem_base)],
			 reg_names[REGNO (mem_index)],
			 INTVAL (index));
	      else if (GET_CODE (mem_index) == SIGN_EXTEND)
		fprintf (file,
			 "([%s,%s.w],%d)",
			 reg_names[REGNO (mem_base)],
			 reg_names[REGNO (XEXP (mem_index, 0))],
			 INTVAL (index));
	      else if (GET_CODE (mem_index) == MULT)
		{
		  rtx scale = XEXP (mem_index, 1);
		  rtx reg = XEXP (mem_index, 0);
		  if (GET_CODE (reg) == REG)
		    fprintf (file,
			     "([%s,%s.l*%d],%d)",
			     reg_names[REGNO (mem_base)],
			     reg_names[REGNO (reg)],
			     INTVAL (scale),
			     INTVAL (index));
		  else if (GET_CODE (reg) == SIGN_EXTEND)
		    fprintf (file,
			     "([%s,%s.w*%d],%d)",
			     reg_names[REGNO (mem_base)],
			     reg_names[REGNO (XEXP (reg, 0))],
			     INTVAL (scale),
			     INTVAL (index));
		}
	      else if (GET_CODE (mem_index) == PLUS)
		{
		  rtx const_p;
		  rtx reg_p;
		  if (GET_CODE (XEXP (mem_index, 0)) == CONST_INT)
		    {
		      const_p = XEXP (mem_index, 0);
		      reg_p = XEXP (mem_index, 1);
		    }
		  else if (GET_CODE (XEXP (mem_index, 1)) == CONST_INT)
		    {
		      const_p = XEXP (mem_index, 1);
		      reg_p = XEXP (mem_index, 0);
		    }
		  else
		    abort ();

		  if (GET_CODE (reg_p) == REG)
		    fprintf (file,
			     "([%d,%s,%s.l],%d)",
			     INTVAL (const_p),
			     reg_names[REGNO (mem_base)],
			     reg_names[REGNO (reg_p)],
			     INTVAL (index));
		  else if (GET_CODE (reg_p) == SIGN_EXTEND)
		    fprintf (file,
			     "([%d,%s,%s.w],%d)",
			     INTVAL (const_p),
			     reg_names[REGNO (mem_base)],
			     reg_names[REGNO (XEXP (reg_p, 0))],
			     INTVAL (index));
		  else if (GET_CODE (reg_p) == MULT)
		    {
		      rtx scale = XEXP (reg_p, 1);
		      reg_p = XEXP (reg_p, 0);
		      if (GET_CODE (reg_p) == REG)
			fprintf (file,
				 "([%d,%s,%s.l*%d],%d)",
				 INTVAL (const_p),
				 reg_names[REGNO (mem_base)],
				 reg_names[REGNO (reg_p)],
				 INTVAL (scale),
				 INTVAL (index));
		      else if (GET_CODE (reg_p) == SIGN_EXTEND)
			fprintf (file,
				 "([%d,%s,%s.w*%d],%d)",
				 INTVAL (const_p),
				 reg_names[REGNO (mem_base)],
				 reg_names[REGNO (XEXP (reg_p, 0))],
				 INTVAL (scale),
				 INTVAL (index));
		    }
		}
	    }
	  else if (GET_CODE (index) == REG)
	    if (GET_CODE (mem_index) == CONST_INT)
	      fprintf (file,
		       "([%d,%s],%s.l)",
		       INTVAL (mem_index),
		       reg_names[REGNO (mem_base)],
		       reg_names[REGNO (index)]);
	    else
	      abort ();
	  else if (GET_CODE (index) == MULT)
	    {
	      rtx scale = XEXP (index, 1);
	      rtx reg_p = XEXP (index, 0);
	      if (GET_CODE (reg_p) == REG)
		fprintf (file,
			 "([%d,%s],%s.l*%d)",
			 INTVAL (mem_index),
			 reg_names[REGNO (mem_base)],
			 reg_names[REGNO (reg_p)],
			 INTVAL (scale));
	      else if (GET_CODE (reg_p) == SIGN_EXTEND)
		fprintf (file,
			 "([%d,%s],%s.w*%d)",
			 INTVAL (mem_index),
			 reg_names[REGNO (mem_base)],
			 reg_names[REGNO (XEXP (reg_p, 0))],
			 INTVAL (scale));
	      else
		abort ();
	    }
	  else if (GET_CODE (index) == SIGN_EXTEND)
	    if (GET_CODE (mem_index) == CONST_INT)
	      fprintf (file,
		       "([%d,%s],%s.w)",
		       INTVAL (mem_index),
		       reg_names[REGNO (mem_base)],
		       reg_names[REGNO (XEXP (index, 0))]);
	    else
	      abort ();
	  else if (GET_CODE (index) == PLUS)
	    {
	      rtx const_p;
	      rtx reg_p;
	      if (GET_CODE (XEXP (index, 0)) == CONST_INT)
		{
		  const_p = XEXP (index, 0);
		  reg_p = XEXP (index, 1);
		}
	      else if (GET_CODE (XEXP (index, 1)) == CONST_INT)
		{
		  const_p = XEXP (index, 1);
		  reg_p = XEXP (index, 0);
		}
	      else
		abort ();

	      if (GET_CODE (reg_p) == REG)
		fprintf (file,
			 "([%d,%s],%s.l,%d)",
			 INTVAL (mem_index),
			 reg_names[REGNO (mem_base)],
			 reg_names[REGNO (reg_p)],
			 INTVAL (const_p));
	      else if (GET_CODE (reg_p) == SIGN_EXTEND)
		fprintf (file,
			 "([%d,%s],%s.w,%d)",
			 INTVAL (mem_index),
			 reg_names[REGNO (mem_base)],
			 reg_names[REGNO (XEXP (reg_p, 0))],
			 INTVAL (const_p));
	      else if (GET_CODE (reg_p) == MULT)
		{
		  rtx scale = XEXP (reg_p, 1);
		  reg_p = XEXP (reg_p, 0);
		  if (GET_CODE (reg_p) == REG)
		    fprintf (file,
			     "([%d,%s],%s.l*%d,%d)",
			     INTVAL (mem_index),
			     reg_names[REGNO (mem_base)],
			     reg_names[REGNO (reg_p)],
			     INTVAL (scale),
			     INTVAL (const_p));
		  else if (GET_CODE (reg_p) == SIGN_EXTEND)
		    fprintf (file,
			     "([%d,%s],%s.w*%d,%d)",
			     INTVAL (mem_index),
			     reg_names[REGNO (mem_base)],
			     reg_names[REGNO (XEXP (reg_p, 0))],
			     INTVAL (scale),
			     INTVAL (const_p));
		  else
		    abort ();
		}
	    }
	}
    }
  else
    abort ();
}

int
x68k_test_operand (x, mode)
     rtx x;
     enum machine_mode mode;
{
  if (TARGET_68020)
    return general_operand (x, mode);
  else
    return register_operand (x, mode);
}

int
plus_symbol_ref_p (x)
     rtx x;
{
  if (GET_CODE (x) == CONST)
    x = XEXP (x, 0);
  if (GET_CODE (x) == SYMBOL_REF
      && !MEM_IN_PCR (x)
      && !MEM_IN_REMOTE (x))
    return 1;
  else if (GET_CODE (x) == PLUS)
    {
      if (memory_indirect_address_p (x, 0))
	return 2;
      if ((GET_CODE (XEXP (x, 0)) == REG
	   && REGNO (XEXP (x, 0)) == 13
	   && plus_symbol_ref_p (XEXP (x, 1)))
	  || (GET_CODE (XEXP (x, 1)) == REG
	      && REGNO (XEXP (x, 1)) == 13
	      && plus_symbol_ref_p (XEXP (x, 0))))
	return 2;

      if ((GET_CODE (XEXP (x, 0)) == SYMBOL_REF
	   && !MEM_IN_REMOTE (XEXP (x, 0))
	   && GET_CODE (XEXP (x, 1)) == CONST_INT
	   && INTVAL (XEXP (x, 1)) > 0
	   && INTVAL (XEXP (x, 1)) < 0x10000)
	  || (GET_CODE (XEXP (x, 1)) == SYMBOL_REF
	      && !MEM_IN_REMOTE (XEXP (x, 1))
	      && GET_CODE (XEXP (x, 0)) == CONST_INT
	      && INTVAL (XEXP (x, 0)) > 0
	      && INTVAL (XEXP (x, 0)) < 0x10000))
	return 1;
    }
  return 0;
}


/* Throughout the rtx X, replace many registers according to REG_MAP.
   Return the replacement for X (which may be X with altered contents).
   REG_MAP[R] is the replacement for register R, or 0 for don't replace.
   NREGS is the length of REG_MAP; regs >= NREGS are not mapped.  

   We only support REG_MAP entries of REG or SUBREG.  Also, hard registers
   should not be mapped to pseudos or vice versa since validate_change
   is not called.

   If REPLACE_DEST is 1, replacements are also done in destinations;
   otherwise, only sources are replaced.  */

rtx
replace_regs (x, reg_map, nregs, replace_dest)
     rtx x;
     rtx *reg_map;
     int nregs;
     int replace_dest;
{
  register enum rtx_code code;
  register int i;
  register char *fmt;

  if (x == 0)
    return x;

  code = GET_CODE (x);
  switch (code)
    {
#if 0
    case SCRATCH:
#endif
    case PC:
    case CC0:
    case CONST_INT:
    case CONST_DOUBLE:
    case CONST:
    case SYMBOL_REF:
    case LABEL_REF:
      return x;

    case REG:
      /* Verify that the register has an entry before trying to access it.  */
      if (REGNO (x) < nregs && reg_map[REGNO (x)] != 0)
	return reg_map[REGNO (x)];
      return x;

    case SUBREG:
      /* Prevent making nested SUBREGs.  */
      if (GET_CODE (SUBREG_REG (x)) == REG && REGNO (SUBREG_REG (x)) < nregs
	  && reg_map[REGNO (SUBREG_REG (x))] != 0
	  && GET_CODE (reg_map[REGNO (SUBREG_REG (x))]) == SUBREG)
	{
	  rtx map_val = reg_map[REGNO (SUBREG_REG (x))];
	  rtx map_inner = SUBREG_REG (map_val);

	  if (GET_MODE (x) == GET_MODE (map_inner))
	    return map_inner;
	  else
	    {
	      /* We cannot call gen_rtx here since we may be linked with
		 genattrtab.c.  */
	      /* Let's try clobbering the incoming SUBREG and see
		 if this is really safe.  */
	      SUBREG_REG (x) = map_inner;
	      SUBREG_WORD (x) += SUBREG_WORD (map_val);
	      return x;
#if 0
	      rtx new = rtx_alloc (SUBREG);
	      PUT_MODE (new, GET_MODE (x));
	      SUBREG_REG (new) = map_inner;
	      SUBREG_WORD (new) = SUBREG_WORD (x) + SUBREG_WORD (map_val);
#endif
	    }
	}
      break;

    case SET:
      if (replace_dest)
	SET_DEST (x) = replace_regs (SET_DEST (x), reg_map, nregs, 0);

      else if (GET_CODE (SET_DEST (x)) == MEM
	       || GET_CODE (SET_DEST (x)) == STRICT_LOW_PART)
	/* Even if we are not to replace destinations, replace register if it
	   is CONTAINED in destination (destination is memory or
	   STRICT_LOW_PART).  */
	XEXP (SET_DEST (x), 0) = replace_regs (XEXP (SET_DEST (x), 0),
					       reg_map, nregs, 0);
      else if (GET_CODE (SET_DEST (x)) == ZERO_EXTRACT)
	/* Similarly, for ZERO_EXTRACT we replace all operands.  */
	break;

      SET_SRC (x) = replace_regs (SET_SRC (x), reg_map, nregs, 0);
      return x;
    }

  fmt = GET_RTX_FORMAT (code);
  for (i = GET_RTX_LENGTH (code) - 1; i >= 0; i--)
    {
      if (fmt[i] == 'e')
	XEXP (x, i) = replace_regs (XEXP (x, i), reg_map, nregs, replace_dest);
      if (fmt[i] == 'E')
	{
	  register int j;
	  for (j = 0; j < XVECLEN (x, i); j++)
	    XVECEXP (x, i, j) = replace_regs (XVECEXP (x, i, j), reg_map,
					      nregs, replace_dest);
	}
    }
  return x;
}

void
target_cpu (file)
    FILE *file;
{
  extern tree current_function_decl;
  extern int  cpu_no_check;
  if (!cpu_no_check
       && TARGET_68020
       && !strcmp("main",DECL_PRINT_NAME (current_function_decl)))
    {
      if (!flag_no_sx)
        message ("CPU typeチェックコードが必要です\n""\x1b""1");
      else
        fprintf (file,
                 "\t.dc.l $41FA0019,$303C0001,$10300200,$4A00661E\n"
	         "\t.dc.l $487A000B,$FF093F3C,$0255FF00,$00435055\n"
                 "\t.dc.l $82AA88E1,$82A282DC,$82B70A0D\n"
	         "\t.dc.w $0000\n");
    }
}

int
expand_pcr_operands (dest, src)
    rtx dest;
    rtx src;
{
   if (GET_CODE (src) == SYMBOL_REF && MEM_IN_PCR (src))
     {
       rtx reg = gen_reg_rtx (Pmode);
       emit_move_insn (reg,
                       gen_rtx (PLUS,
                                SImode,
                                pc_rtx,
                                src));
       emit_insn (gen_rtx (SET, VOIDmode, dest, reg));
       return 1;
     }
   return 0;
}

int
expand_pcr_add (dest, src0, src1)
    rtx dest;
    rtx src0;
    rtx src1;
{
   rtx reg0,reg1;
   reg0 = src0;
   reg1 = src1;
   if (GET_CODE (src0) == SYMBOL_REF && MEM_IN_PCR (src0))
     {
       reg0 = gen_reg_rtx (Pmode);
       emit_move_insn (reg0,
                       gen_rtx (PLUS,
                                SImode,
                                pc_rtx,
                                src0));
      
     }
   if (GET_CODE (src1) == SYMBOL_REF && MEM_IN_PCR (src1))
     {
       reg1 = gen_reg_rtx (Pmode);
       emit_move_insn (reg1,
                       gen_rtx (PLUS,
                                SImode,
                                pc_rtx,
                                src1));
     }
   if (src0 != reg0 || src1 != reg1)
     {
       emit_insn (gen_rtx (SET, VOIDmode, dest, gen_rtx (PLUS, SImode, reg0, reg1)));
       return 1;
     }
   return 0;
}


int
check_pcr_addr (rtx x)
{
  if (GET_CODE (x) ==  SYMBOL_REF && MEM_IN_PCR (x) && !MEM_MAY_IN_PCR (x))
    return 0;
  if (GET_CODE (x) == PLUS)
    {
      rtx op0 = XEXP (x, 0);
      rtx op1 = XEXP (x, 1);
      if (!check_pcr_addr (op0) || !check_pcr_addr (op1))
        return 0;
      return 1;
    }
  return 1;
}
