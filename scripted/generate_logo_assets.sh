#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path/to/logo.svg"
    exit 1
fi

# INPUT
INPUT_SVG="$1"

# Extract basename without extension
BASE_NAME=$(basename "$INPUT_SVG" .svg)
OUTPUT_DIR="exports"
FAVICON_DIR="$OUTPUT_DIR/favicon"
ICONS_DIR="$OUTPUT_DIR/icons"
LOGOS_DIR="$OUTPUT_DIR/logos/png"
PRINT_DIR="$OUTPUT_DIR/logos/print"

# Create directory structure
mkdir -p "$FAVICON_DIR" "$ICONS_DIR" "$LOGOS_DIR" "$PRINT_DIR"

echo "🔧 Generating PNG logo sizes for $INPUT_SVG..."

# Logo PNGs
inkscape "$INPUT_SVG" -o "$LOGOS_DIR/${BASE_NAME}-1024.png" -w 1024
inkscape "$INPUT_SVG" -o "$LOGOS_DIR/${BASE_NAME}-512.png" -w 512
inkscape "$INPUT_SVG" -o "$LOGOS_DIR/${BASE_NAME}-320.png" -w 320
inkscape "$INPUT_SVG" -o "$LOGOS_DIR/${BASE_NAME}-100.png" -w 100

# Print-ready PNG
inkscape "$INPUT_SVG" -o "$PRINT_DIR/${BASE_NAME}-300dpi.png" -w 2500 -d 300

# Export to PDF for print
inkscape "$INPUT_SVG" -o "$PRINT_DIR/${BASE_NAME}.pdf"

# Social profile icons
inkscape "$INPUT_SVG" -o "$ICONS_DIR/icon-512.png" -w 512
inkscape "$INPUT_SVG" -o "$ICONS_DIR/icon-192.png" -w 192
inkscape "$INPUT_SVG" -o "$ICONS_DIR/icon-96.png"  -w 96
inkscape "$INPUT_SVG" -o "$ICONS_DIR/icon-48.png"  -w 48

# Favicon PNGs
echo "📇 Creating favicon PNGs..."
inkscape "$INPUT_SVG" -o "$FAVICON_DIR/favicon-16.png" -w 16
inkscape "$INPUT_SVG" -o "$FAVICON_DIR/favicon-32.png" -w 32
inkscape "$INPUT_SVG" -o "$FAVICON_DIR/favicon-48.png" -w 48

# Favicon ICO (requires imagemagick)
if command -v convert &> /dev/null; then
    echo "🧱 Creating favicon.ico (ImageMagick found)..."
    convert "$FAVICON_DIR"/favicon-{16,32,48}.png "$FAVICON_DIR/favicon.ico"
else
    echo "⚠️ Skipping favicon.ico: ImageMagick 'convert' not found."
fi

echo "✅ Done. Assets saved in: $OUTPUT_DIR"

