;mpbitmap_setpixel_Reikou:
;mpbitmap_getpixel_Reikou:

;mpbitmap_gettile_Reikou:
;	rts
	
	
	
MPB_Pen0 equ 0
MPB_Pen1 equ 1
MPB_Pen2 equ 2
MPB_Pen3 equ 3
MPB_Pen4 equ 4
MPB_Pen5 equ 5
MPB_Pen6 equ 6
MPB_Pen7 equ 7
MPB_Pen8 equ 8
MPB_Pen9 equ 9
MPB_PenA equ 10
MPB_PenB equ 11
MPB_PenC equ 12
MPB_PenD equ 13
MPB_PenE equ 14
MPB_PenF equ 15

mpbitmap_tiletints:
	db 255

	
mpbitmap_getscreenposTile:
	sta z_As	;Bitplanes
	ldy #8		;Lines
	
	ldx #3
mpbitmap_getscreenposShift:	
	asl z_e		;Shift Tiles->Lines
	dex
	bne mpbitmap_getscreenposShift
	
	lda z_d		;Xpos in bytes
	ifndef A52_FourColor_HalfRes	
		asl
	endif
	jmp mpbitmap_GetScreenPosB
				
mpbitmap_GetScreenPos:	;LD=Xpos E=ypos
		
	ldx #0			
	ifdef A52_FourColor_HalfRes
		lsr z_l
		ror z_d
	endif 
	
	lda z_d			;Xpos
	lsr				;4 pixels per byte
	lsr
	
mpbitmap_GetScreenPosB:	
	cmp #32			;Xpos offscreen?
	bcs mpbitmap_GetScreenPos_Offscreen
		
	pha 	
		stx z_b
		lda z_e			;Need to multiply by 40 (8+32)
		
		asl 
		rol z_b
		asl 
		rol z_b
		asl 
		rol z_b			;*8
		
		sta z_c
		sta z_ls
		lda z_b
		sta z_hs
		
		lda z_c
		
		asl 
		rol z_b
		asl 
		rol z_b			;*32
		
		clc
		adc z_ls
		sta z_ls
		
		lda z_hs
		adc z_b
		sta z_hs	
	pla 
	adc z_ls		;Update Low Byte (Xpos)
	sta z_ls
	
	txa
	adc z_hs
	sta z_hs	

	clc
	lda z_ls
	adc #$60+4		;+4 to center virtual screen
	sta z_ls
	lda z_hs		;Add Screen Base ($2060)
	adc #$20
	sta z_hs		
	
	clc				;Clear Carry if draw OK
	rts
	
mpbitmap_GetScreenPos_Offscreen:	
	sec				;Set Carry if draw impossible
	rts
		
	
mpbitmap_NextLine:	;Move down one line
	ifdef A52_FourColor_HalfRes	
		lda #39
	else
		lda #38
	endif
	clc
	adc z_ls		;VRAM = VRAM + 40 (- aready done)
	sta z_ls
	bcc mpbitmap_NextLineDone
	inc z_hs
mpbitmap_NextLineDone:	
	rts
	

;HL = Destination Pattern D=Xpos (tiles) E=Ypos (Tiles) A=Bitplane count
mpbitmap_gettile:
	jsr mpbitmap_getscreenposTile
		
mpbitmap_gettile_nextline:
	lda z_As
	sta z_b				;Bitplane count
			
	ifndef A52_FourColor_HalfRes	
		lda #2
		sta z_c
	endif 	
mpbitmap_gettile_nextByte:		
	lda (z_hls,x)		;Get screen byte
	
	ldx #4
mpbitmap_gettile_nextpixel1:	
	rol 
	rol z_d				;Bitplane 1
	rol 
	rol z_e				;Bitplane 0
	
	ifdef A52_FourColor_HalfRes	
		asl z_d			;Skip every other destination pixel
		asl z_e
	endif	
	dex 
	bne mpbitmap_gettile_nextpixel1
	
	jsr inchls
		
	ifndef A52_FourColor_HalfRes	
		dec z_c
		bne mpbitmap_gettile_nextByte
	endif 
	
	lda z_e				;Bitplane 0
	sta (z_hl,x)	
	jsr inchl
	dec z_b
	beq mpbitmap_gettile_loaddone
	
	lda z_d				;Bitplane 1
	sta (z_hl,x)	
	jsr inchl
	dec z_b
	beq mpbitmap_gettile_loaddone

mpbitmap_gettile_loadagain:	
	txa	
	sta (z_hl,x)		;Store Zero for Bitplane 2/3
	jsr inchl
	dec z_b
	bne mpbitmap_gettile_loadagain

mpbitmap_gettile_loaddone:
	jsr mpbitmap_NextLine	;Move down a VRAM line

	dey
	bne mpbitmap_gettile_nextline
	rts



;HL = Source Pattern D=Xpos (tiles) E=Ypos (Tiles) A=Bitplane count
mpbitmap_settile:
	jsr mpbitmap_getscreenposTile
	bcs mpbitmap_setpixelabort
mpbitmap_settile_yline:	
	
	ifdef mpbitmap_tiletints
		lda mpbitmap_tiletints
		sta z_ds
	endif 
	
	lda z_As		;Bitplane count
	sta z_b
		
	lda (z_hl,x)	;Bitplane 0
	jsr IncHL
	sta z_es

	dec z_b
	beq mpbitmap_settile_bitplanesdone
	
	lda (z_hl,x)	;Bitplane 1
	sta z_ds
	
mpbitmap_settile_skipbitplane:	
	jsr IncHL
	dec z_b
	bne mpbitmap_settile_skipbitplane		
mpbitmap_settile_bitplanesdone:

	ifndef A52_FourColor_HalfRes	
		lda #2
		sta z_c		;Byte count
	endif 	
mpbitmap_settile_NextByte:

	ldx #4			;Pixels per source byte
	
mpbitmap_settile_NextPixel:		
	rol z_ds
	rol
	rol z_es
	rol
	ifdef A52_FourColor_HalfRes	
		rol z_ds	;Skip 2 pixels
		rol z_es
	endif 
	
	dex 
	bne mpbitmap_settile_NextPixel

	sta (z_hls,x)	;Store the byte (4 pixels)
	jsr IncHLs
	
	ifndef A52_FourColor_HalfRes	
		dec z_c
		bne mpbitmap_settile_NextByte
	endif 
	jsr mpbitmap_NextLine
	
	dey
	bne mpbitmap_settile_yline
	rts

	
	
mpbitmap_setpixel:	;D=Xpos E=Ypos A=Color
	and #%00000011
	sta z_iyh			;Color number

	jsr mpbitmap_getscreenpos	;Get Screen VRAM
	bcs mpbitmap_setpixelabort	;Offscreen?
	
	lda #%11111100		;Pixel keep mask
	sta z_c
	
	lda z_d
	and #%00000011		;Xpos 0-3
	eor #%00000011
	beq mpbitmap_setpixel_shiftdone
	asl					;2 shifts per pixel
	tax
mpbitmap_setpixel_shiftagain:
	sec
	rol z_c				;Shift mask
	asl z_iyh			;Shift color
	dex 
	bne mpbitmap_setpixel_shiftagain
	
mpbitmap_setpixel_shiftdone:
	ldx #0
	lda (z_hls,x)		;Get screen byte
	and z_c				;Keep unchanged pixels
	ora z_iyh			;Set new pixel
	sta (z_hls,x)		;Save result
mpbitmap_setpixelabort:
	rts

	

mpbitmap_getpixel:	;D=Xpos E=Ypos A=Color
	jsr mpbitmap_getscreenpos	;Get Screen VRAM
	bcs mpbitmap_getpixeldone	;Offscreen?
	
	lda (z_hls,x)		;Get screen byte
	sta z_c				
	
	lda z_d
	and #%00000011		;Xpos 0-3
	eor #%00000011
	beq mpbitmap_getpixel_shiftdone
	asl					;Shift source data twice per pixel
	tax
mpbitmap_getpixel_shiftagain:
	lsr z_c				;Shift source data
	dex
	bne mpbitmap_getpixel_shiftagain
	
mpbitmap_getpixel_shiftdone:
	lda z_c			
	and #%00000011		;Return color 0-3
mpbitmap_getpixeldone:
	rts
	
	