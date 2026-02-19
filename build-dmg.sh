#!/bin/bash

# build-dmg.sh — Creates a distributable macOS DMG for Extract Archive
# Usage: ./build-dmg.sh
# Output: Extract Archive.dmg

set -e

APP_NAME="Extract Archive"
DMG_NAME="Extract Archive"
VOLUME_NAME="Extract Archive"
APP_BUNDLE="${APP_NAME}.app"
STAGING_DIR="/tmp/extract-archive-dmg-staging"
DMG_TEMP="/tmp/${DMG_NAME}-temp.dmg"
DMG_FINAL="${DMG_NAME}.dmg"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Building ${DMG_FINAL}..."
echo ""

# ── Verify app bundle exists ─────────────────────────────────────────────────
if [ ! -d "$SCRIPT_DIR/$APP_BUNDLE" ]; then
    echo "Error: '$APP_BUNDLE' not found in $SCRIPT_DIR"
    exit 1
fi

# ── Clean up previous builds ─────────────────────────────────────────────────
rm -rf "$STAGING_DIR"
rm -f "$DMG_TEMP"
rm -f "$SCRIPT_DIR/$DMG_FINAL"

# ── Create staging directory ─────────────────────────────────────────────────
mkdir -p "$STAGING_DIR"

# Copy the app bundle into staging
echo "  Copying app bundle..."
cp -R "$SCRIPT_DIR/$APP_BUNDLE" "$STAGING_DIR/"

# Create symlink to /Applications (shows as a shortcut in the DMG)
echo "  Adding Applications shortcut..."
ln -s /Applications "$STAGING_DIR/Applications"

# ── Calculate DMG size ────────────────────────────────────────────────────────
APP_SIZE=$(du -sm "$STAGING_DIR" | cut -f1)
DMG_SIZE=$((APP_SIZE + 10))  # Add 10 MB padding

# ── Create writable temporary DMG ────────────────────────────────────────────
echo "  Creating disk image..."
hdiutil create \
    -srcfolder "$STAGING_DIR" \
    -volname "$VOLUME_NAME" \
    -fs HFS+ \
    -fsargs "-c c=64,a=16,b=16" \
    -format UDRW \
    -size "${DMG_SIZE}m" \
    "$DMG_TEMP" > /dev/null

# ── Convert directly to compressed read-only DMG ─────────────────────────────
echo "  Finalizing..."
hdiutil convert "$DMG_TEMP" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$SCRIPT_DIR/$DMG_FINAL" > /dev/null

# ── Clean up ──────────────────────────────────────────────────────────────────
rm -rf "$STAGING_DIR"
rm -f "$DMG_TEMP"

echo ""
echo "Done! Created: $SCRIPT_DIR/$DMG_FINAL"
echo "Size: $(du -sh "$SCRIPT_DIR/$DMG_FINAL" | cut -f1)"
echo ""
echo "Share this DMG with users. They:"
echo "  1. Open the DMG"
echo "  2. Drag 'Extract Archive.app' to Applications"
echo "  3. Launch the app to complete setup"
