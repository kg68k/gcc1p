# Makefile for libgcc.a

DEFS	= -sUSE_FLOAT
LIBGCC	= libgcc.a

AS	= has060
ASFLAGS	= -1 -c3 $(DEFS)
AR_C	= oar -c

SRCS	= \
	_adddf3.s \
	_adddi3.s \
	_addsf3.s \
	_addxf3.s \
	_anddi3.s \
	_ashrdi3.s \
	_ashrsi3.s \
	_bb.s \
	_clear_cache.s \
	_cmpdf2.s \
	_cmpdi2.s \
	_cmpsf2.s \
	_cmpxf2.s \
	_divdf3.s \
	_divdi3.s \
	_divmodsi3.s \
	_divsf3.s \
	_divsi3.s \
	_divxf3.s \
	_eh.s \
	_eprintf.s \
	_eqdf2.s \
	_eqsf2.s \
	_eqxf2.s \
	_extenddfxf2.s \
	_extendsfdf2.s \
	_extendsfxf2.s \
	_ffsdi2.s \
	_fixdfdi.s \
	_fixdfsi.s \
	_fixsfdi.s \
	_fixsfsi.s \
	_fixtfdi.s \
	_fixunsdfdi.s \
	_fixunsdfsi.s \
	_fixunssfdi.s \
	_fixunssfsi.s \
	_fixunstfdi.s \
	_fixunsxfdi.s \
	_fixunsxfsi.s \
	_fixxfdi.s \
	_fixxfsi.s \
	_floatdidf.s \
	_floatdisf.s \
	_floatditf.s \
	_floatdixf.s \
	_floatsidf.s \
	_floatsisf.s \
	_floatsixf.s \
	_gedf2.s \
	_gesf2.s \
	_gexf2.s \
	_gtdf2.s \
	_gtsf2.s \
	_gtxf2.s \
	_iordi3.s \
	_ledf2.s \
	_lesf2.s \
	_lexf2.s \
	_lshldi3.s \
	_lshlsi3.s \
	_lshrdi3.s \
	_lshrsi3.s \
	_ltdf2.s \
	_ltsf2.s \
	_ltxf2.s \
	_moddi3.s \
	_modsi3.s \
	_muldf3.s \
	_muldi3.s \
	_mulsf3.s \
	_mulsi3.s \
	_mulxf3.s \
	_nedf2.s \
	_negdf2.s \
	_negdi2.s \
	_negsf2.s \
	_negxf2.s \
	_nesf2.s \
	_new_handler.s \
	_nexf2.s \
	_one_cmpldi2.s \
	_op_delete.s \
	_op_new.s \
	_pure.s \
	_shtab.s \
	_subdf3.s \
	_subdi3.s \
	_subsf3.s \
	_trampoline.s \
	_truncdfsf2.s \
	_truncxfdf2.s \
	_truncxfsf2.s \
	_ucmpdi2.s \
	_udiv_w_sdiv.s \
	_udivmoddi4.s \
	_udivsi3.s \
	_umodsi3.s \
	_varargs.s \
	_xordi3.s \
	__gcc_bcmp.s \
	__version.s

OBJS	= $(SRCS:.s=.o)

all: $(LIBGCC)

$(LIBGCC): $(OBJS)
	$(AR_C) $@ $(OBJS)

clean:
	rm -f *.a *.o

# EOF
