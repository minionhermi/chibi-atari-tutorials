
NativeSpriteAddr  equ ramarea+128-16

nativespriteactivebuffer equ ramarea+128
    
	
;This version of nativesprite uses 6x6 blocks, to match PrintChar and MaxTile

	; ifndef z_ix

; z_ixl equ z_Regs+8
; z_ixh equ z_Regs+9
; z_ix equ z_Regs+8

; z_iyl equ z_Regs+10
; z_iyh equ z_Regs+11
; z_iy  equ z_Regs+10
	; endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
nativespr_drawone:
	pushpair z_de
	pushpair z_hl

		ldy #0
		lda (z_hl),y		;Ypos (Pairs of pixels)
		sta z_c

		iny
		lda (z_hl),y		;Xpos (Pairs of pixels)
		sta z_b

		iny
		lda (z_hl),y		;SpriteDef-L
		tax

		iny
		lda (z_hl),y		;SpriteDef-H
		sta z_h
		stx z_l

		lda z_b				;Zero pos?
		ora z_c
		beq nativespr_drawone_EmptySprite
		jsr nativespr_drawextra
nativespr_drawone_EmptySprite

	pullpair z_hl
	pullpair z_de
	rts
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
nativespr_drawextra:
nativespr_hide:
nativespr_draw:  ;bc=xy in pairs of pixels hl=spriteobject a=hspritenum    
	ldx #0
	lda (z_hl,x)
	bne lbl_8B4DxB0B8	;W=0?
	rts
lbl_8B4DxB0B8
	sta z_d			;Width
	jsr inchl

	lda (z_hl,x)
	sta z_e			;Height
	jsr inchl

	lda z_h
	sta z_iyh
	lda z_l
	sta z_iyl

drawnativespry:
	pushpair z_de
	pushpair z_bc
		lda z_d			;Width
		sta z_ixl
drawnativesprx:
		ldx #0
		lda (z_iy,x)    ;0=empty sprite
		bne notdrawnativeskipx1
			jmp drawnativeskipx
notdrawnativeskipx1
		lda z_b

		sec
		sbc #vscreenminx
		cmp #vscreenwid
		bcc notdrawnativeskipx2
			jmp drawnativeskipx
notdrawnativeskipx2	
		clc
		adc #2
		lsr
		lsr
		sta z_b

drawnativeokx:
		lda z_c
		sec
		sbc #vscreenminy
		cmp #vscreenhei-2
		bcc notdrawnativeskipx3
			jmp drawnativeskipx
notdrawnativeskipx3
drawnativeoky:
		;clc
		;adc #2
		;and #%11111100		;Round to a whole tile
		sta z_c
		
		
		txa ;lda #0		;40 bytes per Y Line (40=32+8)
		lsr z_c
		ror 			;%00YYYYYY YY000000
		lsr z_c
		ror 			;%000YYYYY YYY00000 = Y*32
		tay	
			clc
			adc z_b		;Update Low Byte (Add X-pos)
			sta z_e
			
			txa ;lda #0	;Update High Byte
			adc z_c
			sta z_d
		tya
		lsr z_c			;Shift 2 bits
		ror 			;%0000YYYY YYYY0000
		lsr z_c
		ror 			;%00000YYY YYYYY000 = Y*8 
				
		adc z_e			;Add to Update Low Byte
		sta z_e
			
		lda z_c			;Add to Update High Byte
		adc z_d
		sta z_d	

		clc
		lda z_e
		adc #$60+4
		sta z_e
		lda z_d			;Add Screen Base ($2060)
		adc #$20
		sta z_d		
							
drawnativesprxfast:
		stx z_h		;X=0
		
		lda (z_iy,x)      ;spritenum
		bne NOTdrawnativeskipf
			jmp drawnativeskipf
NOTdrawnativeskipf:
		ifdef A52_NativeSprite_PatternOffset
			clc
			adc #A52_NativeSprite_PatternOffset ;first sprite num
		endif
					;z_h=0
		asl 		;*2
		rol z_h
		asl 		;*4
		rol z_h
		asl 		;*8
		rol z_h
		
		clc
		adc nativespriteaddr
		sta z_l
		
		lda z_h
		adc nativespriteaddr+1
		sta z_h
			
			
		ldy #0
		lda (z_HL,x)		;Read a source byte
		eor (z_de),y
		sta (z_de),y		;Write to screen
		ldy #40*1			;Down a line 	+40
		inc z_L				;Inc source data
		
		lda (z_HL,x)		;Read a source byte
		eor (z_de),y
		sta (z_de),y		;Write to screen
		ldy #40*2			;Down a line 	+40
		inc z_L				;Inc source data
		
		lda (z_HL,x)		;Read a source byte
		eor (z_de),y
		sta (z_de),y		;Write to screen
		ldy #40*3			;Down a line 	+40
		inc z_L				;Inc source data
		
		lda (z_HL,x)		;Read a source byte
		eor (z_de),y
		sta (z_de),y		;Write to screen
		ldy #40*4			;Down a line 	+40
		inc z_L				;Inc source data
		
		lda (z_HL,x)		;Read a source byte
		eor (z_de),y
		sta (z_de),y		;Write to screen
		ldy #40*5			;Down a line 	+40
		inc z_L				;Inc source data
		
		lda (z_HL,x)		;Read a source byte
		eor (z_de),y
		sta (z_de),y		;Write to screen
		ldy #40*6			;Down a line 	+40
		inc z_L				;Inc source data
		
		lda (z_HL,x)		;Read a source byte
		eor (z_de),y
		sta (z_de),y		;Write to screen
		
		inc z_d				;Down a line 	+280
		ldy #24
			
		lda (z_HL,x)		;Read a source byte
		eor (z_de),y
		sta (z_de),y		;Write to screen

		dec z_d				;Reset Y position
		
		
	
drawnativeskipf:
		inc z_e				;Across one byte
		bne drawnative_Dok
		inc z_d
drawnative_Dok:		

		inc z_b				;Across one tile

		;cmp #4/4
		;bcc drawnative_overrow
		lda z_b
		cmp #124/4
		bcs drawnative_overrow

		jsr inciy

		dec z_ixl
		beq Notdrawnativesprxfast
			jmp drawnativesprxfast
Notdrawnativesprxfast:	
drawnative_overrowb:
drawnativeskip:
	pullpair z_bc
	pullpair z_de

	lda z_c
	clc
	adc #4     		  ;Down 8 pixels
	sta z_c

	dec z_e
	beq NOTdrawnativespry
	jmp drawnativespry
NOTdrawnativespry
	rts


drawnative_overrow:
drawnativeskipfb:
    jsr inciy		;We're offscreen so Skip a tile 
    dec z_ixl
	bne drawnativeskipfb
	jmp drawnative_overrowb
	
drawnativeskipx:
    jsr inciy
	
	lda z_b
	clc
	adc #4			;Across 8 pixels
	sta z_b

    dec z_ixl		;At end of line?
	beq NOTdrawnativesprx
	jmp drawnativesprx
NOTdrawnativesprx:
	jmp drawnativeskip


	

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
;Draw Sprite Object Array (HL)

NativeSpr_DrawArrayReiKou:	
	jsr AddressRemapViaTableHL		;Used by ChibiVM for address remapping
	
nativespr_drawarray:
	loadpair z_de,nativespriteactivebuffer

nativespr_drawarrayalt:

	ldx #0
	lda (z_hl,x)      ;count
	sta (z_de,x)      ;Store in cache
	pha
		jsr incde
		jsr inchl	
	pla
nativespr_drawarrayb:
	beq nativespr_clearunused
	pha
		jsr nativespr_drawone_testone ;See if sprite needs redrawing
		bcc nativespr_nochange

		pushpair z_hl
			lda z_e
			sta z_l
			lda z_d
			sta z_h
			jsr nativespr_drawone	;Remove old sprite
		pullpair z_hl	
		jsr nativespr_drawone		;Draw New sprite

nativespr_nochange:
		ldy #4
		ldx #0
nativespr_nochangeAgain:	
		lda (z_hl,x)				;Copy New data into cache
		sta (z_de,x)
		jsr incHl
		jsr incde
		dey 
		bne nativespr_nochangeAgain
	pla
	sec
	sbc #1
	jmp nativespr_drawarrayb

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Compare sprite DE to HL, C=Different
; Used to decide if an XOR sprite needs redrawing

nativespr_drawone_testone:
	ldy #4-1			;We test 4 bytes total
	
nativespr_drawone_testoneb:
	
	lda (z_de),y		;Test this byte
	cmp (z_hl),y
	bne nativespr_drawone_fail	;Abort if mismatched
	
	dey
	bpl nativespr_drawone_testoneb
	
	clc					;CC=No Difference
	rts

nativespr_drawone_fail:
    sec					;CS=Difference 
	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
NativeSpr_InitReiKou:
	jsr AddressRemapViaTableHL	;Used by ChibiVM for address remapping

nativespr_init:
	lda z_l
	sta nativespriteaddr		;Store the address of the pattern data
	lda z_h
	sta nativespriteaddr+1

nativespr_clearunused:
	rts
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
		
nativespr_hideAll_Reikou:	
	
nativespr_hidearray:        ;for tilemap redraw
	loadpair z_hl,nativespriteactivebuffer	;Cache of what's onscreen

	ldx #0
	lda (z_hl,x)     	   ;count
	pha
		txa
		sta (z_hl,x)      ;Zero count (all sprites gone)
		jsr inchl
	pla
nativespr_drawarrayb2:
	beq nativespr_clearunused
	pha

		jsr nativespr_drawone	;Hide this sprite

nativespr_nochange2:
		ldy #4
		ldx #0
nativespr_nochangeAgain2:	
		txa
		sta (z_hl,x)			;Clear the 4 bytes in the cache
		jsr incHl
		dey 
		bne nativespr_nochangeAgain2
	pla
	sec
	sbc #1
	jmp nativespr_drawarrayb2 ;Repeat for the next sprite
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
; AddHL_DE:				;Add DE to HL
	; clc
; AdcHL_DE				;Add DE to HL
	; lda z_e			;Add E to L
	; adc z_l
	; sta z_l
	; lda z_d			;Add D to H (with any carry)
	; adc z_h
	; sta z_h
	; jmp *
	; rts

	; ifndef IncIY
; IncIY:
	; INC z_IYL
	; BNE	IncIY_Done
	; INC	z_IYH
; IncIY_Done:
	; rts	
	; endif