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
	db 255,0,0

	
mpbitmap_getscreenposTile:	;D=Xpos E=Ypos (tiles)
	sta z_As		;Bitplanes
	ldy #8			;Linecount
		
	ldx #3
mpbitmap_getscreenposShift:	
	asl z_e			;Shift Tiles->Lines
	dex
	bne mpbitmap_getscreenposShift
		
	lda z_d			;Xpos in bytes
	jmp mpbitmap_GetScreenPosB
	
				
mpbitmap_GetScreenPos:	;LD=Xpos E=ypos (pixels)
	lda z_d			;Divide X by 8
	ldx #3			;8 pixels per byte
mpbitmap_GetScreenPos_ShiftX:	
	lsr z_l			;Xpos LD /8
	ror
	dex	
	bne mpbitmap_GetScreenPos_ShiftX

mpbitmap_GetScreenPosB:	
	pha 
		stx z_b
		lda z_e			;Need to multiply Ypos by 40 (8+32)
		
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
	adc z_ls		;Update Low Byte (Add Xpos)
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
	rts
	

mpbitmap_NextLine:	; HLs down one VRAM line (+40)
	lda #40
	clc
	adc z_ls
	sta z_ls
	bcc mpbitmap_NextLineDone
	inc z_hs
mpbitmap_NextLineDone:	
	rts
	
	
	
;HL = Source Pattern D=Xpos (tiles) E=Ypos (Tiles) A=Bitplane count
mpbitmap_gettile:
	jsr mpbitmap_getscreenposTile
		
mpbitmap_gettile_nextline:
	lda z_As
	sta z_b			;Bitplane count
		
	lda (z_hls,x)	;Bitplane 0
		
	sta (z_hl,x)	;Store to destination
	jsr inchl
	dec z_b
	beq mpbitmap_gettile_loaddone	;More bitplanes?

mpbitmap_gettile_loadagain:	
	txa	;x=0
	sta (z_hl,x)	;Zero bitplane 1-3
	jsr inchl
	dec z_b
	bne mpbitmap_gettile_loadagain

mpbitmap_gettile_loaddone:
	jsr mpbitmap_NextLine
	dey				;Repeat for next line
	bne mpbitmap_gettile_nextline
	rts



;HL = Source Pattern D=Xpos (tiles) E=Ypos (Tiles) A=Bitplane count
mpbitmap_settile:
	jsr mpbitmap_getscreenposTile
	
mpbitmap_settile_yline:	
	lda z_As		;Bitplane count
	sta z_b
		
	lda (z_hl,x)	;Bitplane 0
	sta (z_hls,x)	;Store the bitplane to the screen
		
mpbitmap_settile_skipbitplane:	
	jsr IncHL	;Skip bitplanes 1-3
	dec z_b
	bne mpbitmap_settile_skipbitplane
	
	jsr mpbitmap_NextLine
	
	dey
	bne mpbitmap_settile_yline
	rts
	
	
	
	
mpbitmap_setpixel:	;LD=Xpos E=Ypos A=Color
	and #%00000001
	sta z_iyh		;Color number / Pixel set mask

	jsr mpbitmap_getscreenpos
	
	lda #%11111110	;Mask for pixels to keep
	sta z_c
	
	lda z_d
	and #%00000111	;X pixel pos
	eor #%00000111
	beq mpbitmap_setpixel_shiftdone
	tax				;Shift Left
mpbitmap_setpixel_shiftagain:
	sec
	rol z_c
	asl z_iyh
	dex 
	bne mpbitmap_setpixel_shiftagain
	
mpbitmap_setpixel_shiftdone:
	ldx #0
	lda (z_hls,x)
	and z_c
	ora z_iyh
	sta (z_hls,x)
	rts


mpbitmap_getpixel:	;LD=Xpos E=Ypos A=Color
	jsr mpbitmap_getscreenpos
	
	lda (z_hls,x)	;Get screen byte
	sta z_c
	
	lda z_d
	and #%00000111	;X pixel pos
	eor #%00000111
	beq mpbitmap_getpixel_shiftdone
	tax				
mpbitmap_getpixel_shiftagain:
	lsr z_c			;Shift screen byte
	dex
	bne mpbitmap_getpixel_shiftagain
mpbitmap_getpixel_shiftdone:
	lda z_c
	and #%00000001	;Return pixel / color
	rts
	
	