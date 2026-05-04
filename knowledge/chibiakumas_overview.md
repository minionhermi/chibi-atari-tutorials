# ChibiAkumas - Vollstandige Ubersicht

> Erstellt: 04. Mai 2026
> Quellen: /opt/data/knowledge/ (12 Markdown-Dateien), /opt/data/chibi/ (6 HTMLs),
>           /opt/data/knowledge/chibi_code_images/ (319 Bilder + Manifest, 5.6MB)

---

## 1. WEBSITE-UBERBLICK

ChibiAkumas (chibiakumas.com) ist eine Tutorial-Plattform fur Retro-Assembler-
Programmierung. Der Fokus liegt auf **Multi-Plattform 6502 Assembly**, aber es
gibt auch Tutorials fur andere CPUs (Z80, 68000, ARM). Der Autor (Keith "Akuyou")
verwendet einen humorvollen, unkonventionellen Monster-/Chibi-Stil.

**Assembler**: VASM (unterstutzt 6502, Z80, 68000, ARM u.v.m.)
**Format**: Jede Lektion hat einen passenden YouTube-Video-Tutorial.

---

## 2. CPU-THEMENBEREICHE

Aus den Markdown-Dateien und URLs erschlossen:

| CPU | Abgedeckt? | Details |
|-----|-----------|---------|
| **6502** | **JA (Hauptfokus)** | Umfassend: Basics, Platform-Specific, Hello World, Simple Samples, Advanced, YQuest, Photon |
| **65816** | Erwahnt | 16-Bit-Variante des 6502, verwendet im SNES. Wird in SNES-Lektionen behandelt (P7, P15, P22, P27, P28, P35, H8, S8, YQuest10). |
| **65C02** | **JA** | Erweiterter Befehlssatz (INC/DEC A, PHX/PLX, PHY/PLY, STZ, BRA). Verwendet im SNES, Lynx & Apple II. |
| **HuC6280** | **JA** | Custom 65C02-Abkommling fur PC Engine. Extra-Befehle: TAM, TMA, ST0-2, SXY, SAX, SAY, CLX, CLY, SCL, CSH, SET/T-Flag, TII, TDD, TIN, TIA, RMB, SMB, TSB, TRB, TST, BBS, BBR. |
| **Z80** | Erwahnt (Vergleichsbasis) | Der Autor lernte zuerst Z80 auf dem Amstrad CPC. 6502-Tutorials sind aus Z80-Perspektive geschrieben. Z80-spezifische Lektionen: P22 (SN76489 Sound auf BBC), P23 (Beeper auf Apple II). |
| **68000** | Erwahnt | In Bild-URL-Referenzen gesehen (../68000/theme/...). Nicht in extrahierten Markdowns enthalten. |
| **6809** | Nicht in Dateien | Nicht in den extrahierten Inhalten gefunden. |
| **8086** | Nicht in Dateien | Nicht in den extrahierten Inhalten gefunden. |
| **ARM** | Erwahnt | VASM unterstutzt ARM, aber keine ARM-Tutorials in extrahierten Dateien. |
| **SPC700** | **JA** | Sound-Coprozessor des SNES. Lektionen P27, P28. |

---

## 3. ATARI-SPEZIFISCHE INHALTE (ATARI 800 & 5200)

### 3.1 Tutorial-Ubersicht

Alle Atari-Tutorials behandeln beide Systeme (Atari 800 und Atari 5200) parallel,
da sie hardware-technisch nahezu identisch sind (nur GTIA- und POKEY-Adressen
unterscheiden sich).

#### Hello World Serie
- **H4** - Hello World on the Atari 800 / 5200

#### Simple Samples Serie
- **S4** - Bitmap Drawing on the Atari 800 / 5200
- **S13** - Joystick Reading on the Atari 800 / 5200
- **S23** - Sprite Clipping on the Atari 800 / 5200

#### Platform Specific Serie
- **P2** - Bitmap Functions on the Atari 800 / 5200
- **P11** - Joystick Reading on the Atari 800 / 5200
- **P18** - Palette Definitions on the Atari 800 / 5200
- **P23** - Sound on the Atari 800 / 5200 (POKEY)
- **P31** - Hardware Sprites on the Atari 800 / 5200
- **P51** - Sound on the Atari 800 / 5200 (ChibiSound Pro)
- **P56** - Multiplatform Software Tilemap on the Atari 800/5200 (Mintile)

#### Photon Serie (Tron-Clone)
- **Photon4** - Atari 800/5200: ASM PSET and POINT for Pixel Plotting

#### YQuest Serie (Xquest-Clone)
- **YQuest6** - Atari 800 / Atari 5200 Specific Code

### 3.2 Hardware-Referenz (in Markdowns enthalten)

- **GTIA** (Grafik): Adressen $D000 (A800) / $C000 (A5200)
  - Sprite-Register (HPOSP0-3, SIZEP0-3, GRAFP0-3, COLPM0-3, PRIOR, GRACTL)
  - Palette (COLPF0-3, COLBK)
- **ANTIC** (Display-Controller): $D400 (beide)
  - Display List System, Screen Modes (2-F), DMA Control (DMACTL), PMBASE
- **POKEY** (Sound/IO): $D200 (A800) / $E800 (A5200)
  - 4 Kanale (AUDF1-4, AUDC1-4), AUDCTL
- **PIA**: $D300 (nur Atari 800, nicht im 5200 vorhanden)

### 3.3 Vergleich Atari 800 vs 5200

| Merkmal | Atari 5200 | Atari 800 |
|---------|-----------|-----------|
| CPU | 1.79 MHz 6502 | 1 MHz 65C02 |
| RAM | 16K | 48K |
| Auflosung | 320x200@2 / 160x200@4 | 320x200@2 / 160x200@4 |
| Sprites | 5 (4x8px + Missiles) | 5 (4x8px + Missiles) |
| Sound | 4-Kanal POKEY | 4-Kanal POKEY |
| Cart ROM | $4000 | $A000 |
| GTIA | $C000 | $D000 |
| POKEY | $E800 | $D200 |
| PIA | Nicht vorhanden | $D300 |

### 3.4 Display List Command Reference

| Command | Function |
|---------|----------|
| $x0-$xF | Screen mode change |
| $70 | 8 Blank lines |
| $4x $BB $AA | Start Screen mode x at address $AABB |
| $41 $BB $AA | Wait for Vblank, restart display list at $AABB |

### 3.5 Antic Modetabelle (extrahiert)

| Antic Mode | Basic Mode | Colors | Lines | Width | Bytes/Line | Screen RAM |
|-----------|-----------|--------|-------|-------|-----------|-----------|
| 2 | 0 | 2 | 8 | 40 | 40 | 960 |
| 3 | N/A | 2 | 10 | 40 | 40 | 760 |
| 4 | N/A | 4 | 8 | 40 | 40 | 960 |
| 5 | N/A | 4 | 16 | 40 | 40 | 480 |
| 6 | 1 | 5 | 8 | 20 | 20 | 480 |
| 7 | 2 | 5 | 16 | 20 | 20 | 240 |
| 8 | 3 | 4 | 8 | 40 | 10 | 240 |
| 9 | 4 | 2 | 4 | 80 | 10 | 480 |
| A | 5 | 4 | 4 | 80 | 20 | 960 |
| B | 6 | 2 | 2 | 160 | 20 | 1920 |
| C | N/A | 2 | 1 | 160 | 20 | 3840 |
| D | 7 | 4 | 2 | 160 | 40 | 3840 |
| E | N/A | 4 | 1 | 160 | 40 | 7680 |
| F | 8 | 2 | 1 | 320 | 40 | 7680 |

---

## 4. CODE-BEISPIELE

### 4.1 Aus HTML-Seiten extrahierte Themen (Markdown-Text)

Code wurde als **Text/Beschreibung** extrahiert, aber **nicht als ausfuhrbare
ASM-Codeblocks**. Die Markdown-Datei `chibiakumas_code_examples.md` meldet
explizit: "0 code blocks extracted from tutorials".

Enthaltene Code-Beschreibungen in den Markdowns:

- **6502 Grundlagen**:
  - Register-Set (A, X, Y, SP, PC, Flags NV-BDIZC)
  - Adressierungsmodi (11 Modi: Implied, Relative, Immediate, Absolute,
    Absolute Indexed, Zero Page, Zero Page Indexed, Indirect, Indirect ZP,
    Pre-Indexed (Indirect,X), Post-Indexed (Indirect),Y)
  - Vergleichsbefehle (BCS, BCC, BEQ, BNE) + Z80/68000 Aquivalente
  - Fehlende Befehle und deren Ersatz (ADD, SUB, NEG, SWAP, RLCA, RRCA, BRA, PHX/PHY, HALT)

- **Atari-spezifisch**:
  - Display List Erstellung und Aktivierung
  - Sprite-Initialisierung (DMA Control, PMBASE, GRACTL, PRIOR)
  - GetScreenPos-Funktion (Berechnung $2060 + 40*Y + X)
  - Farbregister COLPF0-3, COLBK
  - POKEY Sound-Register

- **PC Engine (HuC6280)**:
  - Memory Mapping (TAM/TMA mit MPR-Registern)
  - VRAM-Zugriff (ST0, ST1, ST2)
  - Bulk-Copy (TII, TDD, TIN, TIA)
  - Bit-Operationen (RMB, SMB, TSB, TRB, TST, BBS, BBR)

- **BBC Micro**:
  - CRTC-Konfiguration ($FE00-$FE01)
  - ULA-Farbmodus ($FE20-$FE21)
  - Screen-Layout (8-pixel hohe Strips, Y-first)
  - GetScreenPos-Funktion

### 4.2 Code-Bild-Verzeichnis (chibi_code_images/)

**320 Dateien insgesamt (5.6MB)**, aufgeteilt in:

| Unterverzeichnis | Anzahl | Beschreibung |
|-----------------|--------|-------------|
| res/ | 297 | Code-Screenshots aus Lektionen |
| theme/ | 20 | Plattform-Icons (Atari, C64, NES, SNES, BBC, Lynx, etc.) |
| atari800/ | 5 | Atari-spezifische Bilder (DisplayList, Screenshots) |
| appleii/ | 3 | Apple II Grafiken (4color, 2color, SpriteEditor) |
| pcengine/ | 1 | MMU-Diagramm |

**Fehlende Bilder (404)**:
- Lynx/Vram.png
- vic20/CharMap.png

**Bild-Lesson-Bereiche** (aus Dateinamen ersichtlich):

| Prafix | Bereich | Anzahl Bilder |
|--------|---------|---------------|
| Lesson1_ | Basics Lesson 1 | ~11 |
| Lesson2_ | Addressing Modes | ~37 |
| Lesson3_ | Loops/Conditions | ~17 |
| Lesson4_ | Stacks/Math | ~20 |
| Lesson5_ | Bits/Shifts | ~17 |
| Lesson6_ | Data/Tables | ~13 |
| LessonP1_ | Platform: BBC | ~8 |
| LessonP2_ | Platform: Atari | ~7 |
| LessonP3_ | Platform: Apple II | ~4 |
| LessonP4_ | Platform: Lynx | ~5 |
| LessonP5_ | Platform: PC Engine | ~7 |
| LessonP6_ | Platform: NES | ~14 |
| LessonP7_ | Platform: SNES | ~14 |
| LessonP8_ | Platform: VIC-20 | ~7 |
| LessonP9_ | Platform: C64 | ~7 |
| LessonP10_ | Joystick BBC | ~6 |
| LessonA1_ | Advanced 65c02/6280 | ~16 |
| (Plus viele mit _ underline Suffix fur alternative Views) |

---

## 5. TOOLS & DOWNLOADS

Aus den Markdowns und Bildern identifizierte Downloads:

| Datei | Beschreibung |
|-------|-------------|
| **6502DevTools.7z** | 6502 Development Tools (aus theme/DevTools.png) |
| **sources.7z** | Quellcode-Beispiele (aus theme/File.png) |
| **grime6502.7z** | Grime6502 - vermutlich ein Game-Engine-Framework (erwahnt in Atari-Kontext) |
| **CheatSheet.pdf** | 6502/65c02/HuC6280 Befehlsubersicht (aus theme/Cheatsheet.png) |

Externe Ressourcen (empfohlen in den Tutorials):
- **VASM** Assembler (offizielle Website)
- **Altirra Hardware Reference Manual** (Atari)
- **Atari System Reference Manual**
- **AtariOSSrc** (Disassemblierter OS Quellcode)
- **Mkatr** (Disk-Tool)

---

## 6. PLATTFORMVERGLEICH IM 6502-BEREICH

### 6.1 Vollstandige Liste der verglichenen Plattformen

| Plattform | CPU-Variante | Tutorial-Umfang |
|-----------|-------------|-----------------|
| **Atari 800** | 65C02 @ 1MHz | Umfassend (H,S,P,Photon,YQuest) |
| **Atari 5200** | 6502 @ 1.79MHz | Umfassend (H,S,P,Photon,YQuest) |
| **Commodore 64** | 6510 | P9, P30, P36, H2, S2, S11, YQuest4, YQuest14 |
| **Commodore VIC-20** | 6502 | P8, P16, P29, H3, S3, S12, YQuest8 |
| **Commodore PET** | 6502 | P38, P39, P40, H10, S19 |
| **NES / Famicom** | 6502 (Ricoh 2A03) | P6, P15, P21, P26, P34, P43, P44, H7, S7, S16, YQuest9, YQuest12 |
| **SNES / Super Famicom** | 65816 @ 3.58MHz | P7, P15, P22, P27, P28, P35, P41, P42, H8, S8, S17, YQuest10, YQuest13 |
| **BBC Micro** | 6502 | P1, P10, P17, P37, H1, S1, S10, YQuest2 |
| **Apple II** | 65C02 | P3, P12, P19, H5, S5, S14, YQuest5 |
| **Atari Lynx** | 65C02 | P4, P13, P19, P24, P32, H6, S6, S15, YQuest3 |
| **PC Engine / TurboGrafx-16** | HuC6280 (65C02+) | P5, P14, P20, P25, P33, H9, S9, S18, YQuest7, YQuest11 |

### 6.2 Themen-Platform-Matrix

| Thema | BBC | A800/5200 | Apple II | Lynx | PCE | NES | SNES | VIC20 | C64 | PET |
|-------|-----|-----------|----------|------|-----|-----|------|-------|-----|-----|
| Bitmap Functions | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 | P9 | - |
| Joystick Reading | P10 | P11 | P12 | P13 | P14 | P15 | P15 | P16 | - | - |
| Palette | P17 | P18 | P19 | P19 | P20 | P21 | P22 | - | - | - |
| Sound | P22(Z80) | P23 | P23(Z80) | P24 | P25 | P26 | P27/P28 | P29 | P30 | P40 |
| Hardware Sprites | - | P31 | - | P32 | P33 | P34 | P35 | - | P36 | - |
| Hello World | H1 | H4 | H5 | H6 | H9 | H7 | H8 | H3 | H2 | H10 |
| Simple Sample Bitmap | S1 | S4 | S5 | S6 | S9 | S7 | S8 | S3 | S2 | - |
| Simple Sample Joy | S10 | S13 | S14 | S15 | S18 | S16 | S17 | S12 | S11 | S19 |
| YQuest (Platform Code) | YQ2 | YQ6 | YQ5 | YQ3 | YQ7 | YQ9 | YQ10 | YQ8 | YQ4 | - |
| Photon (PSET/POINT) | P2 | P4 | P3 | P6 | P8 | P10 | P9 | P7 | P5 | - |

---

## 7. QUALITAT DER MARKDOWN-EXTRAKTION

### 7.1 Bewertung

| Aspekt | Qualitat | Anmerkungen |
|--------|---------|-------------|
| **Hardware-Referenzen** | **GUT** | Die Atari-Hardware-Referenz (GTIA, ANTIC, POKEY Registertabellen) ist vollstandig extrahiert und gut strukturiert. |
| **Display-List & Screen-Modes** | **GUT** | Komplette Modetabelle (Antic 2-F), Display-List-Befehle, Screen-Layout. |
| **Sprite-System** | **GUT** | Player/Missile-System mit voller Registerliste und Adressen fur A800 und A5200. |
| **POKEY-Sound** | **GUT** | Alle 4 Kanale + AUDCTL Register vollstandig dokumentiert. |
| **6502 CPU Reference** | **GUT** | Vollstandige Befehlsreferenz in Tabellenform mit Z80/68000-Aquivalenten. |
| **Code-Beispiele (Text)** | **SCHLECHT** | Code wurde als lesbarer Text/Beschreibung extrahiert, aber nicht als ausfuhrbare ASM-Codeblocks. Datei `chibiakumas_code_examples.md` meldet "0 code blocks". |
| **Code-Beispiele (Bilder)** | **BEFRIEDIGEND** | 297 Code-Screenshot-Bilder vorhanden (Lesson1-LessonA1), aber nicht maschinenlesbar/ausfuhrbar. Man muss die Bilder manuell anschauen. |
| **Tabellen** | **MITTEL** | Viele Tabellen aus HTML wurden als Pseudo-Text-Tabellen exportiert (mit Pipe-Zeichen). Lesbar, aber formatiert. |
| **Navigation/ToC** | **GUT** | Vollstandiges Inhaltsverzeichnis in 6502_index.md (alle Lektionen mit Nummern). |
| **Plattform-Vergleiche** | **EXZELLENT** | Detaillierte CPU-Vergleiche (6502 vs Z80 vs 68000), Befehl-fur-Befehl. |
| **Bild-Referenzen** | **FEHLERHAFT** | Bild-URLs aus HTML als Plain-Text erhalten, z.B. `[Image: chibiakumas.com]`. Keine Einbettung funktioniert. |
| **OCR von Code-Bildern** | **NICHT DURCHGEFUHRT** | Die 297 Code-Screenshot-Bilder wurden nicht via OCR in Text/Code umgewandelt. |

### 7.2 Haufige Extraktionsprobleme

1. **Umbruche in Tabellen**: Viele Register-Tabellen haben Zeilenumbrruche innerhalb
   der Zellen.
2. **HTML-Icons**: `[Image: ...]` Platzhalter statt tatsachlicher Bild-Integration.
3. **Fehlende Syntax-Highlighting**: ASM-Code wird als Klartext mit Pipe-Zeichen
   formatiert.
4. **Abgeschnittene Dateien**: `6502_index.md` ist 2768 Zeilen lang und wurde
   nicht vollstandig gelesen (ab Zeile 801 abgeschnitten).
5. **Duplikate**: `atari_hardware_reference.md` und `chibiakumas_atari_MAIN.md`
   enthalten weitgehend identischen Content.

### 7.3 Empfehlungen zur Verbesserung

- OCR auf die 297 Code-Screenshot-Bilder anwenden, um ausfuhrbaren ASM-Code zu gewinnen
- Die Code-Beispiele aus dem HTML direkt parsen (statt aus den Markdowns)
- Tabellen-Nachbearbeitung fur saubere Markdown-Formatierung
- Duplikatbereinigung (atari_hardware_reference.md vs chibiakumas_atari_MAIN.md)

---

## 8. DATEIEN & QUELLEN

### 8.1 Markdown-Dateien (/opt/data/knowledge/)

| Datei | Grobe (ca.) | Inhalt |
|-------|------------|--------|
| 6502_index.md | 79 KB | Hauptindex mit ToC, CPU-Basics, Addressierungsmodi |
| chibiakumas_atari_MAIN.md | 49 KB | Atari-spezifische Hardware-Referenz + Tutorial-Liste |
| atari_hardware_reference.md | 49 KB | Duplikat von chibiakumas_atari_MAIN.md |
| atari800atari5200.md | ~47 KB | Atari 800/5200 Seite 1 |
| atari800atari5200_php-1.md | ~12 KB | Atari 800/5200 Unterseite 1 |
| atari800atari5200_php-2.md | ~12 KB | Atari 800/5200 Unterseite 2 |
| atari800atari5200_php-3.md | ~12 KB | Atari 800/5200 Unterseite 3 |
| platform.md | 75 KB | Platform-Specific Series (BBC, Atari) |
| advanced.md | 11 KB | Advanced Series (65c02, HuC6280) |
| chibiakumas_code_examples.md | <1 KB | Leer (0 Codeblocks) |
| chibi_code_images/CHIBI_IMAGE_MANIFEST.md | 1 KB | Image-Download-Log |
| medien_ebooks_overview.md | 30 KB | E-Book-Ubersicht (andere Sammlung) |

### 8.2 Original-HTMLs (/opt/data/chibi/)

| Datei | Beschreibung |
|-------|-------------|
| Atari800Atari5200.php.html | Hauptseite Atari 6502 Tutorial |
| Atari800Atari5200.php-1.html | Subseite 1 |
| Atari800Atari5200.php-2.html | Subseite 2 |
| Atari800Atari5200.php-3.html | Subseite 3 |
| advanced.php.html | Advanced Series Seite |
| platform.php.html | Platform Specific Series Seite |

### 8.3 Code-Bilder (/opt/data/knowledge/chibi_code_images/)

- 297 Code-Screenshot-Bilder in `res/` (Lektionen 1-A1)
- 20 Themen-Icons in `theme/`
- 5 Atari-Bilder in `atari800/`
- 3 Apple-II-Bilder in `appleii/`
- 1 PC-Engine-Bild in `pcengine/`

---

## 9. ZUSAMMENFASSUNG

Die ChibiAkumas-Inhalte sind eine **umfassende, multi-plattform 6502 Assembly Tutorial-Sammlung** mit:

- **44+ Platform-Specific Lektionen** (P1-P44)
- **10 Hello World Lektionen** (H1-H10)
- **19 Simple Sample Lektionen** (S1-S19)
- **14 YQuest Lektionen** (YQuest1-YQuest14)
- **10 Photon Lektionen** (Photon1-Photon10)
- **1 Advanced Lektion** (A1: 65c02/HuC6280)
- **11 Absolute Beginner Lektionen** (Basics 1-11)
- **6 Basic 6502 Lektionen** (Lesson 1-6)

**10 Plattformen** werden abgedeckt: Atari 800, Atari 5200, C64, VIC-20, PET,
NES, SNES, BBC Micro, Apple II, Atari Lynx, PC Engine/TurboGrafx-16.

Die **Extraktionsqualitat** ist gemischt: Hardware-Referenzen und
Beschreibungen sind gut extrahiert, aber **Code-Beispiele liegen nur als
Bilder vor (297 Stuck)** und wurden nicht in ausfuhrbaren ASM-Text
umgewandelt. Der nachste Schritt ware OCR auf die Code-Bilder.
