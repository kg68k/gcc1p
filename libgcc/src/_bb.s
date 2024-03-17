	.title	libgcc.a(_bb.o)

* static int num_digits (long value, int base);
*	指定した値を表示するのに必要な桁数を返す.

* void __bb_exit_func (void);

* void __bb_init_func (struct bb*);

* 1997/10/24 立花.
*	省サイズ、高速化.

* 1997/11/12 立花.
*	ショートアドレッシングの修正.

* 1998/11/13 立花.
*	USE_FLOAT 定義時は __udivsi3() ではなく FLOAT を呼び出すようにし
*	た. strlen() の呼び出しをマクロ展開した.

	.xref	_fopen,_fclose,_fflush,_fprintf
	.xref	_time,_ctime
	.xref	_perror

	.include	fefunc.mac

	.cpu	68000

	.data

_bb_head:
	.dc.l	0

STRLEN:		.macro	areg,dreg
		.local	loop
		move.l	areg,dreg
loop:		tst.b	(areg)+
		bne	loop
		subq.l	#1,areg
		exg	dreg,areg
		sub.l	areg,dreg
		.endm

	.text

num_digits:
	movem.l	d3-d5,-(sp)
	move.l	($14,sp),d4
	moveq	#0,d1
	move.l	($10,sp),d2
	bge	L000020
	moveq	#16,d5
	cmp.l	d4,d5
	sne	d0
	ext	d0
	ext.l	d0
	move.l	d0,d1
	neg.l	d1		;int minus = (value < 0 && base != 16);
L000020:
	move.l	d2,d0
	tst.l	d1
	beq	L000028
	neg.l	d0		;unsigned long v = (minus) ? -value : value;
L000028:
	move.l	d1,d3		;int ret = minus;
L00002a:
.ifdef	USE_FLOAT
	move.l	d4,d1
	FPACK	__UDIV
.else
	move.l	d4,-(sp)	;do {
	move.l	d0,-(sp)
	.xref	 ___udivsi3
	jsr	(___udivsi3)	;v /= base;
	addq.l	#8,sp
.endif	/* USE_FLOAT */
	addq.l	#1,d3		;ret++
	tst.l	d0
	bne	L00002a		;} while (v);
	move.l	d3,d0
	movem.l	(sp)+,d3-d5
	rts

L000044:
	.dc.b	'a',0
L000046:
	.dc.b	'bb.out',0
L00004d:
	.dc.b	'Basic block profiling finished on %s',$0a,0
L000073:
	.dc.b	'File %s, %ld basic blocks ',$0a,$0a,0
L000090:
	.dc.b	'<none>',0
L000097:
	.dc.b	'    Block #%*d: executed %*ld time(s) address= 0x%.*lx',0
L0000ce:
	.dc.b	' function= %-*s',0
L0000de:
	.dc.b	' line= %*ld',0
L0000ea:
	.dc.b	' file= %s',0
L0000f4:
	.dc.b	$0a,0
L0000f6:
	.dc.b	$0a,$0a,0
	.even

___bb_exit_func::
	lea	(-28,sp),sp
	movem.l	d3-d7/a3-a6,-(sp)
	pea	(L000044,pc)
	pea	(L000046,pc)
	move.l	(sp),d3
	jsr	(_fopen)
	move.l	d0,d4
	addq.l	#8,sp
	bne	L000128

	move.l	d3,-(sp)
	jsr	(_perror)
	addq.l	#4,sp
	bra	L00039e
L000128:
	lea	($38,sp),a3
	move.l	a3,-(sp)
	jsr	(_time)
	move.l	a3,-(sp)
	jsr	(_ctime)
	move.l	d0,-(sp)
	pea	(L00004d,pc)
	move.l	d4,-(sp)
	lea	(_fprintf),a3
	jsr	(a3)
	movea.l	(_bb_head),a4
	lea	($14,sp),sp
	bra	L00037e

L00015a:
	suba.l	a6,a6
	move.l	($18,a4),d0
	moveq	#$27,d1
	cmp.l	d0,d1
	bcc	L000176

	cmp.l	#1000,d0
	sle	d0
	ext	d0
	ext.l	d0
	neg.l	d0
	movea.l	d0,a6
L000176:
	clr.l	($34,sp)
	move.l	a6,d0
	beq	@f
	tst.l	($20,a4)
	sne	d0
	ext	d0
	ext.l	d0
	neg.l	d0
	move.l	d0,($34,sp)
@@:
	clr.l	($30,sp)
	move.l	a6,d0
	beq	@f
	tst.l	($24,a4)
	sne	d0
	ext	d0
	ext.l	d0
	neg.l	d0
	move.l	d0,($30,sp)
@@:
	move.l	($c,a4),($2c,sp)
	moveq	#0,d6
	moveq	#0,d7
	moveq	#0,d5
	suba.l	a5,a5
	clr.l	($28,sp)
	pea	($a)
	move.l	($30,sp),-(sp)
	bsr	num_digits
	move.l	d0,($2c,sp)
	move.l	($34,sp),-(sp)
	move.l	(4,a4),-(sp)
	pea	(L000073,pc)
	move.l	d4,-(sp)
	jsr	(_fprintf)
	suba.l	a3,a3
	lea	($18,sp),sp
	moveq	#0,d3
	bra	L000270

L0001ec:
	movea.l	d3,a0
	adda.l	(8,a4),a0
	move.l	(a0),d0
	cmp.l	d6,d0
	ble	L0001fa
	move.l	d0,d6
L0001fa:
	movea.l	d3,a0
	adda.l	($14,a4),a0
	move.l	(a0),d0
	cmp.l	d5,d0
	bls	L000208
	move.l	d0,d5
L000208:
	tst.l	($34,sp)
	beq	L00021c
	movea.l	d3,a0
	adda.l	($20,a4),a0
	move.l	(a0),d0
	cmp.l	d7,d0
	ble	L00021c
	move.l	d0,d7
L00021c:
	move.l	a6,d0
	beq	L000246
	movea.l	d3,a0
	adda.l	($1c,a4),a0
	movea.l	(a0),a0
	move.l	a0,d0
	bne	@f
	lea	(L000090,pc),a0
@@:	STRLEN	a0,d0
	cmp.l	($28,sp),d0
	ble	L000246
	move.l	d0,($28,sp)
L000246:
	tst.l	($30,sp)
	beq	L00026c
	movea.l	d3,a0
	adda.l	($24,a4),a0
	move.l	(a0),a0
	move.l	a0,d0
	bne	@f
	lea	(L000090,pc),a0
@@:	STRLEN	a0,d0
	cmp.l	a5,d0
	ble	L00026c
	movea.l	d0,a5
L00026c:
	addq.l	#4,d3
	addq.l	#1,a3
L000270:
	cmpa.l	($2c,sp),a3
	blt	L0001ec
	pea	($10)
	move.l	d5,-(sp)
	bsr	num_digits
	movea.l	d0,a5
	pea	($a)
	move.l	d6,-(sp)
	bsr	num_digits
	move.l	d0,d6
	pea	($a)
	move.l	d7,-(sp)
	bsr	num_digits
	move.l	d0,d5
	suba.l	a3,a3
	lea	($18,sp),sp
	moveq	#0,d3
	bra	L00035a

L0002a8:
	movea.l	d3,a0
	adda.l	($14,a4),a0
	move.l	(a0),-(sp)
	move.l	a5,-(sp)
	movea.l	d3,a0
	adda.l	(8,a4),a0
	move.l	(a0),-(sp)
	move.l	d6,-(sp)
	pea	(1,a3)
	move.l	($38,sp),-(sp)
	pea	(L000097,pc)
	move.l	d4,-(sp)
	jsr	(_fprintf)
	lea	($20,sp),sp
	move.l	a6,d0
	beq	L000300

	movea.l	d3,a0
	adda.l	($1c,a4),a0
	move.l	(a0),-(sp)
	bne	@f
	addq.l	#4,sp
	pea	(L000090,pc)
@@:
	move.l	($2c,sp),-(sp)
	pea	(L0000ce,pc)
	move.l	d4,-(sp)
	jsr	(_fprintf)
	lea	($10,sp),sp
L000300:
	tst.l	($34,sp)
	beq	L000320
	movea.l	d3,a0
	adda.l	($20,a4),a0
	move.l	(a0),-(sp)
	move.l	d5,-(sp)
	pea	(L0000de,pc)
	move.l	d4,-(sp)
	jsr	(_fprintf)
	lea	($10,sp),sp
L000320:
	tst.l	($30,sp)
	beq	L000348

	movea.l	d3,a0
	adda.l	($24,a4),a0
	move.l	(a0),-(sp)
	bne	@f
	addq.l	#4,sp
	pea	(L000090,pc)
@@:
	pea	(L0000ea,pc)
	move.l	d4,-(sp)
	jsr	(_fprintf)
	lea	($c,sp),sp
L000348:
	pea	(L0000f4,pc)
	move.l	d4,-(sp)
	jsr	(_fprintf)
	addq.l	#8,sp
	addq.l	#4,d3
	addq.l	#1,a3
L00035a:
	cmpa.l	($2c,sp),a3
	blt	L0002a8

	pea	(L0000f4,pc)
	move.l	d4,-(sp)
	jsr	(_fprintf)
	move.l	d4,(sp)
	jsr	(_fflush)
	addq.l	#8,sp
	movea.l	($10,a4),a4
L00037e:
	move.l	a4,d0
	bne	L00015a

	pea	(L0000f6,pc)
	move.l	d4,-(sp)
	jsr	(_fprintf)
	move.l	d4,(sp)
	jsr	(_fclose)
	addq.l	#8,sp
L00039e:
	movem.l	(sp)+,d3-d7/a3-a6
	adda	#$1c,sp
	rts

___bb_init_func::
	movea.l	(4,sp),a1
	tst.l	(a1)
	bne	L0003c0

	moveq	#1,d0
	move.l	d0,(a1)
	lea	(_bb_head),a0
	move.l	(a0),($10,a1)
	move.l	a1,(a0)
L0003c0:
	rts

	.end
