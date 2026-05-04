
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Safe to assume X,Y=0
;X+Y must =0 at end of this routine!


DrawTile:	
	bit LookupBits+0
	ifndef TileTest_BasicOnly		;For Minimal Testing
		bne DrawTileAdvanced
	endif
	asl
	sta (z_bcs),y		;%NNBBXYP0 ... Update flag cleared (bit 0)
	iny
DrawTileBasicOnly:

	and #%11110000		;%nnnn----
	sta z_ls
	lda (z_bcs),y		;%NNNNNNNN
	
	lsr 
	ror z_ls			;8 Bytes per pattern
	sta z_hs
	
	lda z_ls
	clc
	adc z_es			;DEs = Tile pattern base address 
	sta z_ls
	lda z_hs
	adc z_ds
	sta z_hs
		
		
	dey ;ldy #0
		
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	ldy #40*1			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	ldy #40*2			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	ldy #40*3			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	ldy #40*4			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	ldy #40*5			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	ldy #40*6			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	
	inc z_h				;Down a line 	+280
	ldy #24
		
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen

	dec z_h				;Reset Y position
	
	ldy #0
	jmp TileDoneBCs_Plus2



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DrawTileAdvanced:	
	and #%00000110		;YX flip
	bne NotDrawTileCustom
		jmp DrawTileCustom
		
NotDrawTileCustom:		;X/Y/XY Flip
	lda (z_bcs),y
	and #%11111110		;Clear Update Flag
	sta (z_bcs),y
	iny

	ifdef TileTest_NoFlip	;For Minimal Testing
		jmp DrawTileBasicOnly
	endif

	and #%11110000		;%nnnn---
	sta z_ls

	lda (z_bcs),y		;%NNNNNNNN
	
	lsr 
	ror z_ls			;8 Bytes per pattern
	sta z_hs
	
	lda z_ls
	clc
	adc z_es			;DEs = Tile pattern base address 
	sta z_ls
	
	lda z_hs
	adc z_ds
	sta z_hs
	
	dey		
	lda (z_bcs),y
	
	bit LookupBits+2	;%----XYPU
	beq NotDrawTileYFlip
		jmp DrawTileYFlip
NotDrawTileYFlip:


;DrawTileXflip:	
	lda #>FlipLUT
	sta z_b				;BC= Xflip LUT
		
	lda (z_HLs,x)		;Get source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	sta (z_HL),y		;Write to screen
	ldy #40*1			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Get source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	sta (z_HL),y		;Write to screen
	ldy #40*2			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Get source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	sta (z_HL),y		;Write to screen
	ldy #40*3			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Get source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	sta (z_HL),y		;Write to screen
	ldy #40*4			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Get source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	sta (z_HL),y		;Write to screen
	ldy #40*5			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Get source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	sta (z_HL),y		;Write to screen
	ldy #40*6			;Down a line 	+40
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Get source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	sta (z_HL),y		;Write to screen
	
	inc z_h				;Down a line 	+240
	ldy #24
	
	inc z_Ls			;Inc source data
	
	lda (z_HLs,x)		;Get source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	sta (z_HL),y		;Write to screen
	
	dec z_h				;Reset Vram dest
		
	ldy #0
	jmp TileDoneBCs_Plus2
	
	
	
DrawTileEmpty:
	iny 
	lda (z_bcs),y
	cmp #255
	bne DrawTileTransp
	dey ;ldy #0
	jmp TileDoneBCs_Plus2
	
	
DrawTileTransp:;;;;;;;;;;;;;;;;;;Transparent
	asl 
	rol z_hs
	asl 
	rol z_hs
	asl 
	rol z_hs			;8 Bytes per pattern
	
	clc
	adc z_es			;DEs = Tile pattern base address 
	sta z_ls
	
	lda z_hs
	adc z_ds
	sta z_hs
	
	dey ;ldy #0
	
	lda (z_HLs,x)		;Read a source byte
	beq TileTransp1
	sta (z_HL),y		;Write to screen
TileTransp1:
	inc z_Ls
	ldy #40*1			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	beq TileTransp2
	sta (z_HL),y		;Write to screen
TileTransp2:
	inc z_Ls
	ldy #40*2			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	beq TileTransp3
	sta (z_HL),y		;Write to screen
TileTransp3:
	inc z_Ls
	ldy #40*3			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	beq TileTransp4
	sta (z_HL),y		;Write to screen
TileTransp4:
	inc z_Ls
	ldy #40*4			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	beq TileTransp5
	sta (z_HL),y		;Write to screen
TileTransp5:
	inc z_Ls
	ldy #40*5			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	beq TileTransp6
	sta (z_HL),y		;Write to screen
TileTransp6:
	inc z_Ls
	ldy #40*6			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	beq TileTransp7
	sta (z_HL),y		;Write to screen
TileTransp7:
	inc z_Ls
	ldy #24
	inc z_H				;Down a line +280
	
	lda (z_HLs,x)		;Read a source byte
	beq TileTransp8
	sta (z_HL),y		;Write to screen
TileTransp8:
	
	dec z_H				;Reset Vram dest
	ldy #0
	jmp TileDoneBCs_Plus2
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawTileCustom:
	lda (z_bcs),y 		;NN------ - top bits of tilenum
	and #%11111110
	sta (z_bcs),y 
	rol
	rol
	rol
	and #%00000011		;------NN
	sta z_hs
	
	lda (z_bcs),y 
	and #%00110000		;Cmd Bits ;NNCC001-
	bne NotDrawTileFill
		jmp DrawTileFill ;--00----
NotDrawTileFill:
	cmp #%00110000		 ;--11----
	bne NotDrawTileEmpty	
		jmp DrawTileEmpty
NotDrawTileEmpty:
	
	
DrawTileDouble:	
	iny 
	lda (z_bcs),y		;%NNNNNNNN
	asl 
	rol z_hs
	asl 
	rol z_hs		;*4

	clc
	adc z_es			;Add Pattern base DE
	sta z_ls
	
	lda z_hs
	adc z_ds
	sta z_hs
	
	dey ;ldy #0

	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	inc z_Ls
	ldy #40*1			;Down a line 	+40
	
	sta (z_HL),y		;Write to screen
	ldy #40*2			;Down a line 	+40
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	inc z_Ls
	ldy #40*3			;Down a line 	+40
	
	sta (z_HL),y		;Write to screen
	ldy #40*4			;Down a line 	+40
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	inc z_Ls
	ldy #40*5			;Down a line 	+40
	
	sta (z_HL),y		;Write to screen
	ldy #40*6			;Down a line 	+40
	
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	ldy #24
	inc z_H				;Down a line +280
	
	sta (z_HL),y		;Write to screen
	
	dec z_H				;Reset Vram dest
	ldy #0
	jmp TileDoneBCs_Plus2
	
		
		
DrawTileFill:
	iny
	lda (z_bcs),y
	adc z_es			;Add Pattern base
	sta z_ls

	lda z_hs
	adc z_ds
	sta z_hs
		
	dey ;ldy #0
	lda (z_HLs),y		;Read a source byte
	sta z_d
	iny					;Down a line 	+40
	lda (z_HLs),y		;Read a source byte
	
	ldy #40*1			;Down a line 	+40
	sta (z_HL),y		;Write to screen
		
	ldy #40*3			;Down a line 	+40
	sta (z_HL),y		;Write to screen
		
	ldy #40*5			;Down a line 	+40
	sta (z_HL),y		;Write to screen
		
	inc z_h				;Down a line 	+240
	ldy #24
	sta (z_HL),y		;Write to screen
	
	dec z_h				;Reset Vram dest
	
	lda z_d
	ldy #40*2			;Down a line 	+40
	sta (z_HL),y		;Write to screen
	ldy #40*4			;Down a line 	+40
	sta (z_HL),y		;Write to screen
	ldy #40*6			;Down a line 	+40
	sta (z_HL),y		;Write to screen
	ldy #0
	sta (z_HL),y		;Write to screen
	

	
	jmp TileDoneBCs_Plus2


DrawTileXYflip:
	lda #>FlipLUT
	sta z_b				;BC= Xflip LUT
	
	lda z_ls
	adc #7				;Move to last byte
	sta z_ls
		
	lda (z_HLs,x)		;Read a source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*1			;Down a line 	+40
		
	lda (z_HLs,x)		;Read a source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*2			;Down a line 	+40

	lda (z_HLs,x)		;Read a source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*3			;Down a line 	+40
	
	lda (z_HLs,x)		;Read a source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*4			;Down a line 	+40
	
	lda (z_HLs,x)		;Read a source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*5			;Down a line 	+40
	
	lda (z_HLs,x)		;Read a source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*6			;Down a line 	+40
	
	lda (z_HLs,x)		;Read a source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	dec z_Ls
	sta (z_HL),y		;Write to screen
	inc z_h				;Down a line 	+240
	ldy #24
	
	lda (z_HLs,x)		;Read a source byte
	sta z_c				;Set LUT pointer
	lda (z_bc,x)		;Get byte from Xflip LUT
	dec z_Ls
	sta (z_HL),y		;Write to screen
	
	dec z_h				;Reset Vram dest
	ldy #0
	jmp TileDoneBCs_Plus2
	
	
DrawTileYflip:
	bit LookupBits+3
	beq NotDrawTileXYFlip
		jmp DrawTileXYFlip
NotDrawTileXYFlip:

	ldy #0
	lda z_ls
	adc #7				;Move to last source byte
	sta z_ls
			
	lda (z_HLs,x)		;Read a source byte
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*1			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*2			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*3			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*4			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*5			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	dec z_Ls
	sta (z_HL),y		;Write to screen
	ldy #40*6			;Down a line 	+40
	lda (z_HLs,x)		;Read a source byte
	dec z_Ls
	sta (z_HL),y		;Write to screen
	inc z_h				;Down a line 	+240
	ldy #24
	lda (z_HLs,x)		;Read a source byte
	sta (z_HL),y		;Write to screen
	
	dec z_h				;Reset Vram dest
	ldy #0
	jmp TileDoneBCs_Plus2
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
	;40 bytes per line = * %00000000 00101000
	;We shift our Ypos 3 to the right, add it, then another 2, eg
	
	;%00000000 00101000	=40 (32+8)
	;%YYYYYYYY 00000000
	;%000YYYYY YYY00000	= Y*32
	;%00000YYY YYYYY000 = Y*8
	
;(tiles are 4x8 in 4 color mode)
;(tiles are 8x8 in 2 color mode)
	
GetScreenPos:	
	lsr z_b
	lsr z_b			;4 LU per H-tile 
	
	;asl z_c		;1 LU = 2lines
	lda #0
	;lsr z_c		;Shift 3 Bits
	;ror 			;%0YYYYYYY Y0000000
	lsr z_c
	ror 			;%00YYYYYY YY000000
	lsr z_c
	ror 			;%000YYYYY YYY00000 = Y*32
	tax	
		clc
		adc z_b		;Update Low Byte
		sta z_l
		
		lda #0 		;Update High Byte
		adc z_c
		sta z_h
	txa
	lsr z_c			;Shift 2 bits
	ror 			;%0000YYYY YYYY0000
	lsr z_c
	ror 			;%00000YYY YYYYY000 = Y*8 
		
	adc z_l			;Add to Update Low Byte
	sta z_l
		
	lda z_c			;Add to Update High Byte
	adc z_h
	sta z_h	

	clc
	lda z_l
	adc #$60+4
	sta z_l
	lda z_h			;Add Screen Base ($2060)
	adc #$20
	sta z_h		
	rts	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
