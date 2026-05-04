#!/bin/bash
# ChibiAkumas Atari 5200 Tutorials bauen
VASM=/tmp/vasm/vasm6502_oldstyle
SRC=sources
OUT=roms

echo "=== Building Tutorials ==="

# Hello World
$VASM $SRC/SimpleHelloWorld/A52_HelloWorld.asm -chklabels -nocase -Dvasm=1 -DBuildA52=1 -I$SRC -Fbin -o $OUT/hello52.rom

# Simple Samples
for src in Bitmap Joystick; do
    $VASM $SRC/SimpleSamples/A52_${src}.asm -chklabels -nocase -Dvasm=1 -DBuildA52=1 -I$SRC -Fbin -o $OUT/simple_${src,,}.rom
done

echo "=== Done ==="
ls -la $OUT/
