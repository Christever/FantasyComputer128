#!/bin/bash

set -e

cd "$(dirname "$0")"

TOOLS_DIR="tools"

LOVE_VERSION="11.5"

LOVE_LINUX_URL="https://github.com/love2d/love/releases/download/11.5/love-11.5-x86_64.AppImage"
LOVE_WINDOWS_URL="https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip"

echo "=== LÖVE 2D setup ==="

mkdir -p "$TOOLS_DIR"

# Linux runtime
if [ ! -f "$TOOLS_DIR/love-11.5-x86_64.AppImage" ]; then
    echo
    echo "Downloading LÖVE $LOVE_VERSION Linux runtime..."
    wget -O "$TOOLS_DIR/love-11.5-x86_64.AppImage" "$LOVE_LINUX_URL"
    chmod +x "$TOOLS_DIR/love-11.5-x86_64.AppImage"
else
    echo "Linux runtime already installed."
fi

# Windows runtime
if [ ! -f "$TOOLS_DIR/love-11.5-win64/love.exe" ]; then
    echo
    echo "Downloading LÖVE $LOVE_VERSION Windows runtime..."

    TMP_ZIP="/tmp/love-11.5-win64.zip"

    wget -O "$TMP_ZIP" "$LOVE_WINDOWS_URL"

    mkdir -p "$TOOLS_DIR/love-11.5-win64"
    unzip -q "$TMP_ZIP" -d "$TOOLS_DIR/love-11.5-win64"

    # Flatten extracted directory if necessary
    EXTRACTED_DIR="$TOOLS_DIR/love-11.5-win64/love-11.5-win64"

    if [ -d "$EXTRACTED_DIR" ]; then
        mv "$EXTRACTED_DIR"/* "$TOOLS_DIR/love-11.5-win64/"
        rmdir "$EXTRACTED_DIR"
    fi

    rm "$TMP_ZIP"
else
    echo "Windows runtime already installed."
fi

# love.js
if [ ! -d "node_modules/love.js" ]; then
    echo
    echo "Installing love.js..."
    npm install
else
    echo "love.js already installed."
fi

echo
echo "=== Setup complete ==="
echo
echo "LÖVE Linux runtime:"
echo "  $TOOLS_DIR/love-11.5-x86_64.AppImage"
echo
echo "LÖVE Windows runtime:"
echo "  $TOOLS_DIR/love-11.5-win64/"