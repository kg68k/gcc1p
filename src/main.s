
_STACK_MIN	equ	4096
_HEAP_MIN	equ	8*1024
LIB_STACK	equ	1024

	xdef	__main			. startup main
	xdef	__stack_over
	xdef	__fmode
	xdef	__liobuf
	xdef	__argbuffer
	xdef	__argvector
	xdef	__argc
	xdef	__argv
	xdef	__cmdline
	xdef	_environ
	xdef	__ENV0
	xdef	__ENV1
	xdef	__PSP
	xdef	__PSTA
	xdef	__PEND
	xdef	__DSTA
	xdef	__DEND
	xdef	__BSTA
	xdef	__BEND
	xdef	__SSTA
	xdef	__SEND
	xdef	__HSTA
	xdef	__HDEF
	xdef	__HEND
	xdef	_daylight
	xdef	_timezone
	xdef	_tzname
	xdef	_tzstn
	xdef	_tzdtn
	xdef	_errno
	xdef	__doserrno
	xdef	__iob
	xdef	__pback

	xref	_STACK_SIZE
	xref	_HEAP_SIZE
	xref	_main			. for user's main
	xref	_tzset
	xref	_malloc
	xref	__getiob		. for standard iob set
	xref	_exit
	xref	__exit
	xref	MALLOCP
	include	doscall.mac
	include	stdio.mac
	include	fcntl.mac

	.text
	dc.b	'g++ Only Start up',0
	.quad
__main:
	move.l	8(a0),sp		* 全メモリを専有する
	subq.l	#4,sp			* 念のため・・・・。
	move.l	sp,__SEND
	move.l	a2,__cmdline		* コマンド・ライン アドレス セット
	move.l	a3,__ENV0		* 環境アドレス セット
	bsr	_getarg			* stack:100k only
	lea	$100(a0),a5
	move.l	a5,__PSTA
	move.l	$34(a0),d0
	move.l	d0,__PEND
	move.l	d0,__DSTA
	move.l	$30(a0),d0
	move.l	d0,__DEND
	move.l	d0,__BSTA
	move.l	a1,__BEND
	lea	16(a0),a5
*
	move.l	a1,d1
*
	move.l	d1,_environ		*環境エリアセットアップ
	move.l	__ENV0,a0
	move.l	(a0),d0
	addq.l	#5,d0
	and.l	#$FFFFFE,d0
	add.l	d0,d1
	move.l	d1,__ENV1
	move.l	__ENV0,a0
	addq.l	#4,a0
	moveq.l	#0,d0
envlenc2:
	addq.l	#1,d0
	tst.b	(a0)+
	beq	envlenok
envlenck:
	addq.l	#1,d0
	tst.b	(a0)+
	bne	envlenck
	bra	envlenc2
	.quad
envlenok:
	addq.l	#1,d0
	and.l	#$fffffe,d0
	add.l	d0,d1
*
	move.l	d1,__HSTA
	move.l	__SEND,d0
	sub.l	__STACK,d0
	and.l	#$fffffe,d0
	move.l	d0,__SSTA		* スタック先頭設定
	sub.l	#32,d0			* 念のための隙間
*
	move.l	d0,__HDEF		* 残りは全部ヒープ
	move.l	d0,__HEND
*
*	ヒープ領域の初期化
*
	move.l	__HSTA,a0
	move.l	a0,MALLOCP
	lea	16(a0),a1
	clr.l	(a0)+
	move.l	a1,(a0)+
	clr.l	(a0)+
	move.l	#'HEAP',(a0)

*	env copy
	move.l	__ENV0,a0
	move.l	__ENV1,a1
	addq.l	#4,a0
envcpy:
	move.b	(a0)+,(a1)+
	beq	envcpe
envcp0:
	move.b	(a0)+,(a1)+
	bne	envcp0
	bra	envcpy
	.quad
envcpe:
	move.l	__ENV1,a0
	move.l	_environ,a1
envcp1:
	tst.b	(a0)
	beq	envend
	move.l	a0,(a1)+
envskp:
	tst.b	(a0)+
	bne	envskp
	bra	envcp1
	.quad
envend:
	clr.l	(a1)

envok:
*	グローバル領域の初期化
	clr.w	__pback
	clr.l	__fmode			. text mode
	lea	__liobuf,a0
	lea	liomod,a1
	clr.l	d1
lioinit:
	move.l	d1,-(sp)		. 0,d1.w
	DOS	_IOCTRL
	addq.l	#4,sp
	move.b	d1,(a0)+
	move.b	d0,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#1,d1
	cmp.w	#5,d1
	bne	lioinit

	move.l	#((__NFILE)*SIZE_IOBUF)-1,d0
	move.l	#__iob,a0
_loop:
	clr.b	(a0)+
	dbra	d0,_loop

	lea	__iob,a0
	lea	liomod,a1
	clr.l	d1
fioinit:
	move.l	d1,-(sp)		. 0,d1.w
	DOS	_IOCTRL
	addq.l	#4,sp
	btst.l	#OS_ISDEV,d0
	beq	blkdev
	move.l	#_IOCHARA+_IONBF,d0
	bra	fiook
	.quad
blkdev:
	move.l	#_IOBDEV,d0
	movem.l	d0-d1/a1,-(sp)
	move.l	a0,-(sp)
	move.l	#_BUFSIZ,-(sp)
	jsr	_malloc
	addq.l	#4,sp
	tst.l	d0
	beq	_memerr
	move.l	(sp)+,a0
	move.l	d0,_PTR(a0)
	move.l	d0,_BASE(a0)
	move.l	#_BUFSIZ,_BSIZE(a0)
	movem.l	(sp)+,d0-d1/a1
fiook:
	or.w	(a1)+,d0
	clr.l	_CNT(a0)
	move.l	d0,_FLAG(a0)
	move.b	d1,_FILE(a0)
	lea	SIZE_IOBUF(a0),a0
	addq.w	#1,d1
	cmp.w	#5,d1
	bne	fioinit
	jsr	_tzset
	pea	ctrlca
	move.w	#_CTRLVC,-(sp)
	DOS	_INTVCS
	addq.l	#6,sp
	move.l	_environ,-(sp)
	move.l	__argv,-(sp)
	move.l	__argc,-(sp)
	jsr	_main
	lea	12(sp),sp
	move.l	d0,-(sp)
	jsr	_exit

ctrlca:
	DOS	_GETPDB
	move.l	#$200,d1
	cmp.l	__PSP,d0
	beq	mainex
	move.w	d1,-(sp)
	DOS	_EXIT2

__stack_over:
	pea	stkmsg
	DOS	_PRINT
	moveq.l	#127,d1
mainex:
	move.l	d1,-(sp)
	jsr	_exit

_memerr:
	pea	errmsg
	DOS	_PRINT
	addq.l	#4,sp
	move.l	#127,-(sp)
	jsr	__exit

*	argment list make
_getarg:
	movem.l	a0-a2,-(sp)
	lea	__argbuffer,a2		. argument buffer
	lea	__argvector,a1		. argv buffer
	move.l	a2,(a1)+		. argv[0] = 'C'
	movem.l	a0,-(sp)
	lea	$80(a0),a0

pthset:
	move.b	(a0)+,(a2)+		. ＥＸＥＣファイルのコマンド名 セット
	bne	pthset
	move.l	(sp)+,a0
	tst.b	-(a2)
	lea	$c4(a0),a0
cmdset:
	move.b	(a0)+,(a2)+		. ＥＸＥＣファイルのコマンド名 セット
	bne	cmdset

	clr.l	d0			. ａｒｇｃ ＝ ０
	move.l	__cmdline,a0		. _Base Get
	move.b	(a0)+,d1		. d1 = cmd line length get
	beq	ArgExit			. No argument

ArgLp0:
	move.b	(a0)+,d1
	beq	ArgEx			. パラメータ終了コード検出
	cmpi.b	#$09,d1			. ＴＡＢ ？
	beq	ArgLp0
	cmpi.b	#$20,d1			. ＳＰＡＣＥ ？
	beq	ArgLp0
	addq.l	#1,d0			. ａｒｇｃ＋＋
	move.l	a2,(a1)+		. argv[1]= address
	cmp.b	#$27,d1			. '
	beq	ArgLp27
	cmp.b	#$22,d1			. "
	bne	ArgLoop
ArgLp22:
	move.b	(a0)+,d1
	beq	ArgEx
	cmp.b	#$22,d1			. "
	beq	ArgEx
	move.b	d1,(a2)+
	bra	ArgLp22
	.quad
ArgLp27:
	move.b	(a0)+,d1
	beq	ArgEx
	cmp.b	#$27,d1			. "
	beq	ArgEx
	move.b	d1,(a2)+
	bra	ArgLp27
	.quad
ArgLoop:
	move.b	d1,(a2)+		. パラメータセット（＊ａｒｇｖ［ｄ０］＋＋）
	move.b	(a0),d1
	beq	ArgEx
	cmp.b	#$22,d1
	beq	ArgEx
	cmp.b	#$27,d1
	beq	ArgEx
	addq.l	#1,a0
	cmpi.b	#$09,d1			. ＴＡＢ ？
	beq	ArgEx
	cmpi.b	#$20,d1			. ＳＰＡＣＥ ？
	bne	ArgLoop
ArgEx:
	clr.b	(a2)+			. ｓｔｏｐ ｃｏｄｅ セット
	movem.l	d1/a0/a2,-(sp)
	move.l	-4(a1),a2
	move.b	(a2)+,d1
	cmp.b	#'-',d1
	beq	chklbl
	bne	nochk
chklbl:
	lea	stackms,a0
	bsr	a0a2ck
	beq	stkset
	bra	nochk
	.quad
a1a2bk:
	movem.l	(sp)+,d1/a0/a2
	move.l	-(a1),a2
	subq.l	#1,d0
	bra	argexc
	.quad
stkset:
	bsr	numget
	move.l	d1,__STACK
	bra	a1a2bk
	.quad
nochk:
	movem.l	(sp)+,d1/a0/a2
argexc:
	tst.b	d1
	bne	ArgLp0
ArgExit:
	move.b	d1,(a2)+		. ｓｔｏｐ ｃｏｄｅ セット
	lea	__argvector,a0
	addq.l	#1,d0			. ａｒｇｃ＋＋
	move.l	d0,__argc
	move.l	a0,__argv
	movem.l	(sp)+,a0-a2
	rts

a0a2ck:
	movem.l	a2,-(sp)
a0a2cl:
	move.b	(a0)+,d1
	beq	a0a2ok
	move.b	(a2)+,d2
	beq	a0a2ng
	or.b	#$20,d2
	cmp.b	d2,d1
	beq	a0a2cl
a0a2ng:
	tst.b	d1
	movem.l	(sp)+,a2
	rts
a0a2ok:
	addq.l	#4,sp
	rts

numget:
	clr.l	d1
	clr.l	d2
numgl:
	move.b	(a2)+,d2
	sub.b	#'0',d2
	cmp.b	#10,d2
	bcc	numgte
	add.l	d1,d1
	move.l	d1,d3
	add.l	d1,d1
	add.l	d1,d1
	add.l	d3,d1
	add.l	d2,d1
	bra	numgl
	.quad
numgte:
	add.b	#'0',d2
	or.b	#$20,d2
	cmp.b	#'k',d2
	bne	numnok
	asl.l	#8,d1
	asl.l	#2,d1
numnok:
	bclr.l	#0,d1
	rts

*****************************************
*	コンスタント領域定義		*
*****************************************

liomod:
		dc.w	O_RDONLY+O_TEXT	. con in
		dc.w	O_WRONLY+O_TEXT	. con out
		dc.w	O_RDWR+O_TEXT	. con err
		dc.w	O_RDWR+O_TEXT	. aux
		dc.w	O_WRONLY+O_TEXT	. prn
_tzname:	dc.l	_tzstn
		dc.l	_tzdtn
_tzstn:		dc.b	'JST',0		. パシフィック・タイムゾーン
_tzdtn:		dc.b	0,0,0,0		. 夏時間調整を行う
_daylight:	dc.l	0		. 夏時間採用の有無
_timezone:	dc.l	-9*60*60	. グリニッジ時間との誤差
	.even
__STACK:	dc.l	_STACK_SIZE
errmsg:		dc.b	'主記憶が不足しています！！！',$0D,$0A,0
stkmsg:		dc.b	'スタックが不足しています！！！',$0D,$0A,0
stackms:	dc.b	'+-s:',0
		.quad
*	ストレージ領域定義

	.data
__PSP:		dc.l	0
__PSTA:		dc.l	0
__PEND:		dc.l	0
__DSTA:		dc.l	0
__DEND:		dc.l	0
__BSTA:		dc.l	0
__BEND:		dc.l	0
__SSTA:		dc.l	0
__SEND:		dc.l	0
__HSTA:		dc.l	0
__HDEF:		dc.l	0
__HEND:		dc.l	0
DUMMYMALLOCP:	dc.l	0
__ENV0:		dc.l	0		. 親の環境
__ENV1:		dc.l	0		. 自分の環境
_environ:	dc.l	0		. 自分の環境のポインタ配列
__cmdline:	dc.l	0
__argc:		dc.l	0
__argv:		dc.l	0
__liobuf:	ds.l	96
__fmode:	ds.l	1
__argbuffer:	ds.b	512
__argvector:	ds.b	20*4
		ds.l	20
_errno:
		ds.b	4
__doserrno:
		ds.b 	4
__iob:
		ds.b	(SIZE_IOBUF*__NFILE)
__pback:	
		ds.b	2
	.quad
	.end	__main

