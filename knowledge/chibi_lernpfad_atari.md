# ChibiAkumas Atari 6502 Assembly - Kohärenter Lernpfad

## Übersicht: 3 Wissensquellen verbunden

Dieses Dokument verbindet:
1. **OCR-Ergebnisse** (293 txt-Dateien, ~80% Qualitaet)
2. **SrcA52-Quellcode** (12 fehlerfreie ASM-Dateien)
3. **Tutorial-Texte** (Markdown-Referenzen)

Ziel: Strukturierter Lernpfad von "Hello World" bis "Tilemap Engine" fuer Atari 5200/800.

---

## Lektion 1: Hello World & Grundlagen
**Thema:** Erste Schritte - Cartridge-Header, System-Init, Hello World Textausgabe

### Tutorial-Erklaerung (aus chibiakumas_atari_MAIN.md)
Der Atari 5200 und 800 sind hardware-maessig fast identisch. Die Unterschiede sind INTENTIONAL:
- GTIA (Grafik): $C000 (A52) vs. $D000 (A80)
- POKEY (Sound): $E800 (A52) vs. $D200 (A80)
- Cartridge-Start: $4000 (A52) vs. $A000 (A80)
- PIA: fehlt beim A52, bei $D300 (A80)

Das Tutorial empfiehlt, Symbole per Conditional Assembly zu definieren (BuildA52/BuildA80).

### Zugehoerige ASM-Quellen (SrcA52/)
- **V1_Header.asm** (78 Zeilen) - Der eigentliche "Lesson 1" Code:
  - Conditional Assembly: ifdef BuildA52 (GTIA=$C000, POKEY=$E800, org $4000)
  - ifdef BuildA80 (GTIA=$D000, POKEY=$D200, org $A000)
  - Interrupts deaktivieren (SEI, CLD)
  - Zero-Page, ANTIC, GTIA, POKEY loeschen
  - RAM von $0200-$3FFF loeschen
  - ScreenInit aufrufen

- **V1_Functions.asm** (260 Zeilen) - Textausgabe:
  - Cls - Bildschirm leeren
  - Locate, NewLine, PrintChar - Cursor-Steuerung
  - DoFontLine - Bitmap-Font rendern (8x8 Pixel, 4-Farb-Expansion)
  - Screen-Base: $2060, 40 Bytes pro Zeile

### OCR-Ergebnisse (res/)
- **Lesson1_1.txt** (18 Z.) - Build-Script (nicht Assembly!), Qualitaet: **20%** (1/5)
  - Inhalt: vasm-Aufruf und Emulator-Start - kaum lesbar, nicht Atari-Code
- **Lesson1_2.txt** (18 Z.) - Header/Include-Struktur, Qualitaet: **40%** (2/5)
  - "include \",.\\SrceaLL\\V1_ Header.asm\"" - erkennbar, aber stark verrauscht
  - "Bitmapfont" / "incbhin" erkennbar, Pfade verdreht
- **Lesson1_2_.txt** (18 Z.) - Gleicher Inhalt, leicht abweichend
- **Lesson1_3.txt** (8 Z.) - Einfache LDA/LDX/LDY Beispiele, Qualitaet: **60%** (3/5)
  - "lda #$69 ;Load & with Hex $69" - gut erkennbar
- **Lesson1_4.txt** (1 Z.) - Monitor-Ausgabe, Qualitaet: **30%** (1/5)
  - "a:69 *x:45 4:00 s:E" - stark verrauscht

### OCR-Qualitaet gesamt Lektion 1: **35%** - Schlecht, ASM-Quellen als Referenz nutzen

---

## Lektion 2: Bitmap-Speicher & ScreenInit
**Thema:** Bitmap-Speicherverwaltung, ScreenPos-Berechnung, Display-List Einrichtung

### Tutorial-Erklaerung (aus chibiakumas_atari_MAIN.md)
Zwei Screen-Modi:
- **ANTIC Mode F ($0F)** - 4 Farben, 160x192, rechteckige Pixel, 40 Bytes/Zeile
- **ANTIC Mode E ($0E)** - 2 Farben, 320x192, quadratische Pixel, 40 Bytes/Zeile

Screen-Speicher beginnt bei $2000. Wegen 4k-Grenze bei $3000 muss ein Trick angewendet werden:
Ein $40+Smode-Befehl in der Display-List springt ueber die Grenze.

Display-List-Befehle:
- $x0-$xF: Screen-Mode wechseln
- $70: 8 Leerzeilen
- $4x $BB $AA: Mode x bei Adresse $AABB starten
- $41 $BB $AA: Auf Vblank warten, bei $AABB neu starten

### Zugehoerige ASM-Quellen (SrcA52/)
- **A52_V1_BitmapMemory.asm** (91 Zeilen):
  - GetScreenPos: X/Y-Position in Screen-Offset umrechnen (40 Bytes/Zeile)
    - Y * 40 = (Y*32) + (Y*8) - clever mit RORs optimiert
    - Screen-Base $2060 (2-Farb) oder $2064 (256-Breit)
  - GetNextLine: Offset += $0028 (40)
  - ScreenInit: Display-List-Pointer setzen (DLISTL=$D402, DLISTH=$D403)
    - DMA einschalten (DMACTL=$D400, #%00100010)
    - Mode $0F (F) oder $0E (E) via Smode
    - Farben setzen: COLPF0/1/2, COLBK

- **V1_Footer.asm** (43 Zeilen) - Display-List Daten:
  - org $bf20: Display-List
  - 3 Blank-Lines ($70,$70,$70)
  - $40+Smode,$60,$20: Screen-Start bei $2060
  - 192 Zeilen Smode (Mode F oder E)
  - $40+Smode,$00,$30: Sprung ueber $3000-Grenze
  - $41 + dw dlist: Loop zurueck zum Anfang
  - org $bffd: ROM-Header ($FF = kein Logo, $00,$40 = Start bei $4000)

### OCR-Ergebnisse (res/) - **DIES IST DIE WICHTIGSTE OCR-GRUPPE FUER ATARI!**
- **LessonP2_1.txt** (30 Z.) - Display-List Daten, Qualitaet: **65%** (3/5)
  - "org $bf20" - korrekt
  - "db $70,$70,$70" - korrekt
  - "db $40+Smode,$60,$20" - korrekt (vs. $404+S5mode in OCR-Variante)
  - Display-List-Daten weitgehend korrekt, aber "Smode" stattdessen
- **LessonP2_1_.txt** (30 Z.) - Abweichende OCR, "org $bhf20", "$404+Smode" - Fehler
- **LessonP2_2.txt** (10 Z.) - DMA/DLIST-Setup, Qualitaet: **70%** (3/5)
  - "lda #<dlist" / "sta DLISTL" - sauber
  - "lda #%00100010 ;Enable DMA" - korrekt
- **LessonP2_3.txt** (15 Z.) - Palette/COLPF, Qualitaet: **65%** (3/5)
  - "lda #$EF ;Set color PF1" / "sta COLPF1" - erkennbar
  - Mode2Color Conditional - erkennbar
  - "$73" und "$AF" Farbwerte - korrekt
- **LessonP2_3_.txt** (15 Z.) - Gleicher Inhalt, noch mehr OCR-Artefakte
- **LessonP2_4_.txt** (37 Z.) - GetScreenPos, Qualitaet: **55%** (3/5)
  - ROR-Shift-Logik teilweise erkennbar
  - "AddPair 2_de, $2060" statt "AddPair z_de,$2060"
- **LessonP2_5.txt** (3 Z.) - GetNextLine, Qualitaet: **70%** (3/5)
  - "AddPair z_de, $0028" - fast korrekt
- **LessonP2_7.txt** (27 Z.) + **LessonP2_7_.txt** (27 Z.) - Bitmap-Kopier-Loop
  - BitmapNextLine/NextByte Schleife erkennbar
  - "lda (z_hl),Y" / "sta (z_de),Y" - erkennbar
  - "bmpwidth" und "8*6" - Variablen erkennbar

### OCR-Qualitaet gesamt Lektion 2: **60%** - Mittel, als Ergaenzung zu echten Quellen nutzbar

---

## Lektion 3: Joystick lesen
**Thema:** Player-Controls, Analog-zu-Digital-Konvertierung, Unterschied A80 vs. A52

### Tutorial-Erklaerung (aus chibiakumas_atari_MAIN.md)
Der Atari 5200 hat keine PIA, sondern liest den Joystick ueber analoge Pots (POKEY POT0-POT3).
Der Atari 800 nutzt die PIA ($D300) fuer digitale Joystick-Eingaenge.
Fire-Button: TRIG0 ($D010/$C010) und TRIG1 ($D011/$C011).

### Zugehoerige ASM-Quellen (SrcA52/)
- **A52_V1_ReadJoystick.asm** (102 Zeilen):
  - BuildA80-Pfad: PIA+$0 (Bits RLDU), TRIG0/TRIG1 fuer Feuer
  - BuildA52-Pfad: POKEY+0/1/2/3 (POT0-3), TRIG0/TRIG1
  - Player_ReadControlsProcessAnalog: Analogwert in Digital umrechnen
    - cmp #255-64 / cmp #64 - Schwellwerte
    - High=U/R, Low=D/L, Mitte=neutral
  - Ergebnis in z_h (Player 0) und z_l (Player 1), Format: ---FRLDU

### OCR-Ergebnisse (res/)
- **LessonP10_2_.txt, LessonP10_3*.txt, LessonP10_4*.txt, LessonP10_5_.txt, LessonP10_6_.txt**
  - Enthalten Joystick-Code, aber von **BBC Micro / anderer Plattform** ($FE40, $FECO, SN76489)
  - **NICHT Atari 5200/800 relevant** - komplett falsche Hardware-Adressen
- **LessonA1_1.txt** (25 Z.) - 65C02-Befehle (DEC/INC/PHX/PHY/PLX/PLY/STZ/BRA)
  - Allgemeine 6502-Beispiele, nicht Atari-spezifisch

### OCR-Qualitaet gesamt Lektion 3: **N/A** - Keine Atari-spezifischen OCR-Ergebnisse vorhanden
  **WARNUNG:** Die LessonP10-OCR-Dateien sind von einer anderen Plattform!
  Nutze A52_V1_ReadJoystick.asm als alleinige Referenz.

---

## Lektion 4: Palette definieren
**Thema:** Farbpaletten, GTIA-Farbregister, RGB-zu-Atari-Farbkonvertierung

### Tutorial-Erklaerung (aus chibiakumas_atari_MAIN.md)
Atari-Palette: 3 Bits pro Farbe (R, G, B je 0-2 = 27 Farben).
Format: $x0-$xF (Helligkeit/Luminance).
Register: COLPF0 ($D016), COLPF1 ($D017), COLPF2 ($D018), COLBK ($D01A).

### Zugehoerige ASM-Quellen (SrcA52/)
- **A52_V1_Palette.asm** (89 Zeilen):
  - SetPalette: Eingabe (Index, R, G, B) -GRB Format
  - Palcolconv: RGB-Wert (0-255) auf 0/1/2 reduzieren
  - PalcolconvR: Nibbles tauschen fuer Rot-Verschiebung
  - Berechnung: Green*9 + Red*3 + Blue = Lookup-Index
  - PalPalette_Map: 27 Eintraege (3x3x3) mit Atari-Hardware-Farbwerten
  - GTIA-Palette-Register: GTIA+$16 (COLPF0) ff.

### OCR-Ergebnisse (res/)
- **LessonP2_3.txt / LessonP2_3_.txt** - Enthalten Farb-Setup-Code
  - Ueberlappung mit Lektion 2 (ScreenInit setzt auch Farben)

### OCR-Qualitaet gesamt Lektion 4: **40%** - Farb-Logik in OCR kaum erfasst,
  PalPalette_Map fehlt komplett in OCR. ASM-Quelle als alleinige Referenz.

---

## Lektion 5: Sound mit ChibiSound
**Thema:** POKEY-Sound, einfacher Sound (ChibiSound), fortgeschrittener Sound (ChibiSound Pro)

### Tutorial-Erklaerung (aus chibiakumas_atari_MAIN.md)
POKEY-Register (Atari 5200: $E800-$E808):
- AUDF1-4: Frequenz (0=hoechster Ton)
- AUDC1-4: Rauschen (NNNN) + Lautstaerke (VVVV)
- AUDCTL ($D208/$E808): Globale Sound-Steuerung

### Zugehoerige ASM-Quellen (SrcA52/)
- **A52_V1_ChibiSound.asm** (40 Zeilen):
  - ChibiSound: %NVPPPPPP (N=Noise, V=Volume, P=Pitch)
  - Noise-Bit -> Distortion (%00000111) oder Square Wave (%10100111)
  - Pitch *4 -> POKEY+0 (AUDF1)
  - Volume+Noise -> POKEY+1 (AUDC1)
  - Silent wenn A=0

- **A52_V1_ChibiSoundPro.asm** (69 Zeilen):
  - ChibiOctave: Frequenz-Tabelle (Noten E-G-A-B-C-D, 7 Oktaven)
  - ChibiSoundPro_Set: 4 Kanaele (POKEY+0/2/4/6 fuer Frequenz, +1/3/5/7 fuer Control)
  - H=Volume(0-255), L=Channel+Noise-Bit, DE=Pitch
  - ChibiSoundPro_Init: AUDCTL+$08 zuruecksetzen

### OCR-Ergebnisse (res/)
- **LessonP10_* - NICHT Atari** (siehe Lektion 3)
- Keine spezifischen OCR-Dateien fuer POKEY-Sound bei Atari 5200 identifiziert

### OCR-Qualitaet gesamt Lektion 5: **N/A** - Keine Atari-spezifischen OCR-Ergebnisse
  Nutze A52_V1_ChibiSound.asm und A52_V1_ChibiSoundPro.asm als alleinige Referenz.

---

## Lektion 6: Hardware-Sprites (Player/Missile)
**Thema:** Atari PMG (Player/Missile Graphics), 8-Pixel-Sprites, 128 Zeilen Hoehe

### Tutorial-Erklaerung (aus chibiakumas_atari_MAIN.md)
Atari-Sprites sind "seltsam":
- 4 Player (8 Pixel breit) + 4 Missiles (2 Pixel breit) = 5 Sprites
- Bis zu 128 Pixel hoch (oder 256 in Hires)
- Daten aus einem Speicherbereich (PMBASE $D407, z.B. $1800)
- Vertikale Position = Offset im Sprite-Speicher (fest, nicht setzbar)
- Register: HPOSP0-3 ($D000-$D003), SIZEP0-3 ($D008-$D00B)
- COLPM0-3 ($D012-$D015), PRIOR ($D01B), GRACTL ($D01D)

### Zugehoerige ASM-Quellen (SrcA52/)
- **A52_V1_NativeSprite.asm** (437 Zeilen):
  - Native Sprite Implementation (Software-Sprites, nicht Hardware-PMG!)
  - 6x6 Block-Sprites, XOR-basiertes Rendering
  - nativespr_draw: BC=XY, HL=Sprite-Objekt
  - nativespr_drawarray: Array von Sprites zeichnen
  - nativespr_drawone_testone: Hat sich Sprite geaendert? (fuer XODER-Redraw)
  - nativespr_init: Pattern-Daten-Adresse setzen
  - nativespr_hidearray: Alle Sprites verstecken

**HINWEIS:** Der tatsaechliche Hardware-Sprite-Code (PMG) ist in den SrcA52-Dateien
NICHT enthalten. A52_V1_NativeSprite.asm implementiert Software-Sprites.

### OCR-Ergebnisse (res/)
- Keine spezifischen OCR-Dateien fuer NativeSprite identifiziert

### OCR-Qualitaet gesamt Lektion 6: **N/A**

---

## Lektion 7: Multiplattform-Bitmap
**Thema:** Tile-basiertes Bitmap, plattformunabhaengige Implementierung

### Zugehoerige ASM-Quellen (SrcA52/)
- **A52_V1_MultiplatformBitmap.asm** (218 Zeilen):
  - mpbitmap_getscreenposTile: Tile->Pixel-Koordinaten
  - mpbitmap_GetScreenPos: Pixel->Screen-Offset (X/8, Y*40)
  - 2-Farb-Modus (Standard)

- **A52_V1_MultiplatformBitmap_4Color.asm** (318 Zeilen):
  - 4-Farb-Version mit Halb-Res-Option
  - A52_FourColor_HalfRes: 4 Pixel pro Byte statt 8
  - Offscreen-Erkennung (cmp #32)

### OCR-Ergebnisse (res/)
- Keine zugeordneten OCR-Dateien gefunden

### OCR-Qualitaet gesamt Lektion 7: **N/A**

---

## Lektion 8: MaxTile Engine
**Thema:** Fortgeschrittene Tilemap-Engine mit Flip/Fill/Transparent-Details

### Zugehoerige ASM-Quellen (SrcA52/)
- **A52_V1_MaxTile_Normal.asm** (572 Zeilen):
  - DrawTile: Haupfunktion, 8x8-Tiles rendern
  - DrawTileBasicOnly: Einfaches Rendern (kein Flip)
  - DrawTileAdvanced: Flip (X/Y/XY), Fill, Transparent, Custom
  - DrawTileXflip: Bit-weise X-Spiegelung via Lookup-Table
  - DrawTileYFlip: Y-Spiegelung (Bytes rueckwaerts)
  - DrawTileTransp: Nur Nicht-Null-Bytes schreiben
  - DrawTileFill: Fill-Modus (2 Bytes wiederholt)
  - DrawTileDouble: 4x8 (Double-Width) Tiles
  - FlipLUT: Lookup-Table fuer Bit-Spiegelung

### OCR-Ergebnisse (res/)
- Keine zugeordneten OCR-Dateien gefunden

### OCR-Qualitaet gesamt Lektion 8: **N/A**

---

## Zusammenfassung: OCR-Qualitaet pro Lektion

| Lektion | Thema | OCR-Qualitaet | ASM-Quelle |
|---------|-------|---------------|------------|
| 1 | Hello World & Header | 35% (schlecht) | V1_Header.asm, V1_Functions.asm |
| 2 | Bitmap-Speicher & ScreenInit | 60% (mittel) | A52_V1_BitmapMemory.asm, V1_Footer.asm |
| 3 | Joystick lesen | N/A (andere Plattform) | A52_V1_ReadJoystick.asm |
| 4 | Palette | 40% (schlecht) | A52_V1_Palette.asm |
| 5 | Sound (ChibiSound/Pro) | N/A | A52_V1_ChibiSound.asm, A52_V1_ChibiSoundPro.asm |
| 6 | Hardware-Sprites / Native Sprite | N/A | A52_V1_NativeSprite.asm |
| 7 | Multiplattform-Bitmap | N/A | A52_V1_MultiplatformBitmap.asm (+4Color) |
| 8 | MaxTile Engine | N/A | A52_V1_MaxTile_Normal.asm |

**Gesamturteil OCR:** Von 293 txt-Dateien sind nur ~20-30 tatsaechlich Atari 5200/800-relevant.
Die uebrigen enthalten Code von CPC, C64, VIC-20, NES, SNES, BBC Micro, MSX, Lynx, etc.
Selbst die Atari-relevanten OCRs haben starke Artefakte (falsche Zeichen, verdrehte Pfade).

**Empfehlung:** Die SrcA52/*.asm-Dateien sind die alleinige verlaessliche Quelle.
OCR-Ergebnisse koennen als Hinweis auf Code-Struktur dienen, aber nicht als ausfuerbare Referenz.

---

## Empfohlener Lernpfad (chronologisch)

### Phase 1: Grundlagen
1. **V1_Header.asm** lesen - Conditional Assembly verstehen (BuildA52 vs. BuildA80)
2. **V1_Functions.asm** studieren - Cls, PrintChar, Cursor-Steuerung
3. **V1_Footer.asm** ansehen - Display-List-Struktur, ROM-Header

### Phase 2: Bitmap & Grafik
4. **A52_V1_BitmapMemory.asm** - ScreenInit, GetScreenPos, Screen-Positionierung
5. **A52_V1_Palette.asm** - Farbkonvertierung RGB->Atari-Palette

### Phase 3: Interaktion
6. **A52_V1_ReadJoystick.asm** - Joystick lesen (A80 PIA vs. A52 analog)
7. **A52_V1_ChibiSound.asm** - Einfacher Sound via POKEY

### Phase 4: Fortgeschritten
8. **A52_V1_ChibiSoundPro.asm** - Multi-Channel Sound, Frequenztabellen
9. **A52_V1_MultiplatformBitmap.asm** - Plattformunabhaengige Bitmap-Routinen

### Phase 5: Sprites & Tilemap
10. **A52_V1_NativeSprite.asm** - Software-Sprites (XOR-Methode, 6x6 Bloecke)
11. **A52_V1_MaxTile_Normal.asm** - Tilemap-Engine (Flip, Fill, Transparent)

---

## Atari 5200 vs. 800: Wichtige Unterschiede

| Merkmal | Atari 5200 | Atari 800 |
|---------|-----------|-----------|
| CPU | 1.79 MHz 6502 | 1 MHz 65C02 |
| RAM | 16 KB | 48 KB |
| Cartridge-Start | $4000 (32 KB) | $A000 (8 KB) |
| GTIA (Grafik) | $C000 | $D000 |
| POKEY (Sound) | $E800 | $D200 |
| PIA | Nicht vorhanden | $D300 |
| ANTIC | $D400 | $D400 |
| Joystick | Analog (POTs) | Digital (PIA) |

Der Code in SrcA52/*.asm verwendet `ifdef BuildA52` / `ifdef BuildA80`, um beide
Plattformen mit einer Source zu unterstuetzen.

---

## Hardware-Register Kurzreferenz (aus atari_hardware_reference.md)

### GTIA (A52: $C000, A80: $D000)
- +$00-$03: HPOSP0-3 (Player X-Position)
- +$04-$07: HPOSM0-3 (Missile X-Position)
- +$08-$0B: SIZEP0-3 (Player Grosse)
- +$0C: SIZEM (Missile Grosse)
- +$0D-$10: GRAFP0-3 (Player Grafik)
- +$11: GRAFM (Missile Grafik)
- +$12-$15: COLPM0-3 (Player-Farben)
- +$16-$19: COLPF0-3 (Playfield-Farben)
- +$1A: COLBK (Hintergrund)
- +$1B: PRIOR (Prioritaet/Mode)
- +$1D: GRACTL (Grafik-Control)
- +$10: TRIG0 (Feuerknopf 0)
- +$11: TRIG1 (Feuerknopf 1)

### ANTIC ($D400)
- $D400: DMACTL (DMA-Control)
- $D401: CHACTL (Zeichen-Control)
- $D402-3: DLISTL/H (Display-List-Pointer)
- $D407: PMBASE (Sprite-Base-Adresse / 256)
- $D409: CHBASE (Zeichensatz-Base)
- $D40E: NMIEN (NMI-Enable)

### POKEY (A52: $E800, A80: $D200)
- +$00/$02/$04/$06: AUDF1-4 (Frequenz)
- +$01/$03/$05/$07: AUDC1-4 (Noise+Volume)
- +$08: AUDCTL (Control)

---

## Dateien in diesem Pfad

| Datei | Groesse | Beschreibung |
|-------|---------|-------------|
| `/opt/data/knowledge/chibi_lernpfad_atari.md` | ~20 KB | Dieses Dokument |
| `/opt/data/knowledge/chibi_sources/SrcA52/*.asm` | 12 Dateien | Massgebliche ASM-Quellen |
| `/opt/data/knowledge/chibiakumas_atari_MAIN.md` | 49 KB | Vollstaendiges Tutorial |
| `/opt/data/knowledge/atari_hardware_reference.md` | 49 KB | Hardware-Referenz |
| `/opt/data/knowledge/chibi_ocr_results/res/Lesson*.txt` | 293 Dateien | OCR-Ergebnisse (mit Vorsicht) |

Erstellt am: 2026-05-04 durch Hermes Agent
Quellen: ChibiAkumas.com Tutorials (Keith "ChibiAkumas" Highman)
