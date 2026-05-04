# ChibiAkumas Atari 5200/800 Tutorials

Nachprogrammierte und getestete Tutorials von www.chibiakumas.com/6502/

## Aufbau

```
roms/         - Fertig gebaute ROM-Dateien (.rom, 32KB Cartridge)
sources/      - Original-Assembler-Quellen von ChibiAkumas
  SrcA52/       - Atari 5200 Lektionen (13 Dateien)
  SimpleHelloWorld/ - Hello World für 11 Plattformen
  SimpleSamples/   - Bitmap + Joystick Samples
knowledge/    - Extrahierte Tutorial-Texte + OCR-Ergebnisse
```

## Build-System

**Vasm 2.0e** (vasm6502_oldstyle) wird benötigt.

```bash
./build_all.sh          # Alle Tutorials bauen
```

## Testen mit atari800

```bash
atari800 -5200 -cart roms/hello52.rom
atari800 -5200 -cart roms/simple_bitmap.rom
atari800 -5200 -cart roms/simple_joy.rom
```

## Atari 800 vs 5200

Die Quellen verwenden conditional assembly:
- `-DBuildA52=1` → Atari 5200 (GTIA=$C000, POKEY=$E800, ORG=$4000)
- `-DBuildA80=1` → Atari 800 (GTIA=$D000, POKEY=$D200, ORG=$A000)

## Quellen

- ChibiAkumas 6502 Tutorials: https://www.chibiakumas.com/6502/
- Alle Quellen von der lokalen SMB-Kopie (\\ORANGE\hermiwrite\www.chibiakumas.com)

## Testergebnisse (04.05.2026)

| Tutorial | ROM | Status |
|----------|-----|--------|
| Hello World | `roms/hello52.rom` | ✅ Läuft, zeigt Text + Farben |
| Bitmap | `roms/simple_bitmap.rom` | ✅ Läuft, rendert Grafik |
| Joystick | `roms/simple_joy.rom` | ✅ Läuft, braucht Tastatureingabe |

**Joystick-Test:** Das Gesicht bewegt sich nur mit Tastatureingabe (Pfeiltasten).
Im Headless-Modus (Xvfb) ohne echten Input bleibt es statisch. Auf einem
echten Desktop mit `-kbdjoy0` bewegt es sich.

### Referenz-Screenshots
`/opt/data/chibi-atari-tutorials/screenshots/` enthält die Soll-Zustände
der Tutorials vom Entwickler getestet.
