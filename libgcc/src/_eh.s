	.title	libgcc.a(_eh.o)

* static exception_table* find_exception_table (void*);

* void* __find_first_exception_table_match (void*);

* int __throw_type_match (const char*, const char*);

* void __register_exceptions (exception_table*);

* 1997/10/24 立花.
*	省サイズ、高速化. 変数をtextセクションに移動.

* 1997/11/12 立花.
*	ショートアドレッシングの修正.


	.xref	_strcmp
	.xref	_malloc

	.cpu	68000

	.text

find_exception_table:
	move.l	(4,sp),d0
	movea.l	(exception_table_list,pc),a0
	bra	L000020
L00000c:
	cmp.l	(4,a0),d0
	bcs	L00001c
	cmp.l	(8,a0),d0
	bcc	L00001c
	move.l	(a0),d0		;return table->table;
	rts
L00001c:
	movea.l	($c,a0),a0
L000020:
	move.l	a0,d0
	bne	L00000c
**	moveq	#0,d0
	rts

___find_first_exception_table_match::
	movem.l	d3-d5/a3,-(sp)
	move.l	($14,sp),d3
	move.l	d3,-(sp)
	bsr	find_exception_table
	movea.l	d0,a3
	moveq	#0,d4
	moveq	#0,d2
	move.l	d0,(sp)+	;if (table == 0)
	beq	L00009c		;  return (void*)0;

	lea	(except_pc,pc),a0
	move.l	d3,(a0)
	movea.l	a3,a2
	moveq	#-1,d5
	bra	L00007c

L000050:
	move.l	(a2),d3
	move.l	(a0),d0
	cmp.l	d3,d0
	bcs	L00007c
	move.l	(4,a2),d1
	cmp.l	d1,d0
	bcc	L00007c
	tst.l	d2
	beq	L00007a
	move.l	d2,d0
	add.l	d0,d0
	add.l	d2,d0
	asl.l	#2,d0
	movea.l	d0,a1
	adda.l	a3,a1
	cmp.l	(4,a1),d1
	bhi	L00007c
	cmp.l	(a1),d3
	bcs	L00007c
L00007a:
	move.l	d4,d2
L00007c:
	lea	($c,a2),a2
	addq.l	#1,d4
	cmp.l	(8,a2),d5
	bne	L000050
	move.l	d2,d0
	beq	L00009c

	move.l	d2,d0
	add.l	d0,d0
	add.l	d2,d0
	asl.l	#2,d0
	move.l	(8,a3,d0.l),d0
L00009c:
	movem.l	(sp)+,d3-d5/a3
	rts

___throw_type_match::
	move.l	(8,sp),-(sp)
	move.l	(8,sp),-(sp)
	jsr	(_strcmp)
	addq.l	#8,sp
	rts

___register_exceptions::
	move.l	a4,-(sp)
	move.l	a3,-(sp)

	movea.l	($c,sp),a3
	pea	(16)		;sizeof (struct exception_table_node)
	jsr	(_malloc)
	movea.l	d0,a4
	addq.l	#4,sp
	movea.l	a4,a0
	move.l	a3,(a0)+	;node->table = table;

	move.l	($c,a3),(a0)	;node->start = range->start;
	lea	(8,a4),a1
	move.l	($10,a3),(a1)	;node->end = range->end;
	lea	($18,a3),a2
	lea	($1c,a3),a3
	moveq	#-1,d1
	bra	L0000fc

L0000e6:
	cmp.l	(a0),d0
	bcc	L0000ec
	move.l	d0,(a0)
L0000ec:
	move.l	(a3),d0
	cmp.l	(a1),d0
	bcc	L0000f4
	move.l	d0,(a1)
L0000f4:
	lea	($c,a3),a3
	lea	($c,a2),a2
L0000fc:
	move.l	(a2),d0
	cmp.l	d0,d1
	bne	L0000e6

	lea	(exception_table_list,pc),a0
	move.l	(a0),($c,a4)	;node->next = exception_table_list;
	move.l	a4,(a0)		;exception_table_list = node;
	movea.l	(sp)+,a3
	movea.l	(sp)+,a4
	rts

**except_table_pos:
**	.dc.l	0		;未使用
except_pc:
	.dc.l	0
exception_table_list:
	.dc.l	0

	.end
