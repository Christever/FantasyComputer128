#!/bin/bash

set -e
cd "$(dirname "$0")"

PROJECT_NAME="Love2D-Game-Template"

LOVE_APPIMAGE="tools/love-11.5-x86_64.AppImage"
LOVE_WINDOWS="tools/love-11.5-win64"
LOVE_JS="node_modules/love.js/index.js"

BUILD_DIR="build"
LINUX_DIR="$BUILD_DIR/linux"
WINDOWS_DIR="$BUILD_DIR/windows"
WEB_DIR="$BUILD_DIR/web"

LINUX_PACKAGE="$BUILD_DIR/${PROJECT_NAME}-linux"
WINDOWS_PACKAGE="$BUILD_DIR/${PROJECT_NAME}-windows"
WEB_PACKAGE="$BUILD_DIR/${PROJECT_NAME}-web"

echo "=== Building $PROJECT_NAME ==="

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$LINUX_DIR"

# Create .love file
echo "Creating .love..."
zip -9 -r "$BUILD_DIR/$PROJECT_NAME.love" . \
    -x ".git/*" \
       "build/*" \
       "node_modules/*" \
       "tools/*" \
       "web/*" \
       ".vscode/*" \
       "package.json" \
       "package-lock.json" \
       "setup.sh" \
       "build.sh" \
       "readme.MD"
# Extract LÖVE runtime
echo "Extracting LÖVE runtime..."
"$LOVE_APPIMAGE" --appimage-extract >/dev/null

# Copy LÖVE binary
echo "Preparing Linux build..."
cp squashfs-root/bin/love "$LINUX_DIR/$PROJECT_NAME"

# Copy required library
mkdir -p "$BUILD_DIR/lib"
cp squashfs-root/lib/liblove-11.5.so "$BUILD_DIR/lib/"

# Append game to LÖVE binary
cat "$BUILD_DIR/$PROJECT_NAME.love" >> "$LINUX_DIR/$PROJECT_NAME"

# Make executable
chmod +x "$LINUX_DIR/$PROJECT_NAME"

# Remove temporary runtime
rm -rf squashfs-root

# Build Windows
echo "Preparing Windows build..."
mkdir -p "$WINDOWS_DIR"

cp "$LOVE_WINDOWS"/* "$WINDOWS_DIR/"

cat "$WINDOWS_DIR/love.exe" "$BUILD_DIR/$PROJECT_NAME.love" \
    > "$WINDOWS_DIR/$PROJECT_NAME.exe"

rm "$WINDOWS_DIR/love.exe"

# Build Web
echo "Preparing Web build..."
rm -rf "$WEB_DIR"

"$LOVE_JS" -c "$BUILD_DIR/$PROJECT_NAME.love" "$WEB_DIR" \
    -t "$PROJECT_NAME"

# Create distribution packages
echo "Creating distribution archives..."

mkdir -p "$LINUX_PACKAGE"
mkdir -p "$WINDOWS_PACKAGE"
mkdir -p "$WEB_PACKAGE"

# Linux package
cp "$LINUX_DIR/$PROJECT_NAME" "$LINUX_PACKAGE/"
cp "$BUILD_DIR/lib/liblove-11.5.so" "$LINUX_PACKAGE/"

# Windows package
cp "$WINDOWS_DIR"/* "$WINDOWS_PACKAGE/" 
rm "$WINDOWS_PACKAGE/lovec.exe"

# Web package
cp -r "$WEB_DIR"/* "$WEB_PACKAGE/"

# Create ZIP archives
cd "$BUILD_DIR"

zip -9 -r "${PROJECT_NAME}-linux.zip" "${PROJECT_NAME}-linux"
zip -9 -r "${PROJECT_NAME}-windows.zip" "${PROJECT_NAME}-windows"

cd "${PROJECT_NAME}-web"
zip -9 -r "../${PROJECT_NAME}-web.zip" .
cd ..

cd ..

echo
echo "=== Build complete ==="
echo "Linux:       $LINUX_DIR/$PROJECT_NAME"
echo "Linux ZIP:   $BUILD_DIR/${PROJECT_NAME}-linux.zip"
echo "Windows:     $WINDOWS_DIR/$PROJECT_NAME.exe"
echo "Windows ZIP: $BUILD_DIR/${PROJECT_NAME}-windows.zip"
echo "Web:         $WEB_DIR/index.html"
echo "Web ZIP:     $BUILD_DIR/${PROJECT_NAME}-web.zip"