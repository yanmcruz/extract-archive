#!/bin/bash

# build-dmg.sh — Creates a distributable macOS DMG for Extract Archive
# Uses node-appdmg for a polished UI (background, icon positioning, window layout)
# Usage: ./build-dmg.sh
# Output: Extract.Archive.dmg

set -e

APP_NAME="Extract Archive"
DMG_FINAL="Extract.Archive.dmg"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Building ${DMG_FINAL}..."
echo ""

# ── Verify app bundle exists ─────────────────────────────────────────────────
if [ ! -d "$SCRIPT_DIR/$APP_NAME.app" ]; then
    echo "Error: '$APP_NAME.app' not found in $SCRIPT_DIR"
    exit 1
fi

# ── Remove previous build ────────────────────────────────────────────────────
rm -f "$SCRIPT_DIR/$DMG_FINAL"

# ── Use node-appdmg if available ────────────────────────────────────────────
cd "$SCRIPT_DIR"

if command -v npx &> /dev/null; then
    echo "  Using node-appdmg for polished DMG layout..."
    npx --yes appdmg dmg-assets/appdmg.json "$DMG_FINAL"
elif command -v appdmg &> /dev/null; then
    echo "  Using appdmg for polished DMG layout..."
    appdmg dmg-assets/appdmg.json "$DMG_FINAL"
elif [ -f "node_modules/.bin/appdmg" ]; then
    echo "  Using local appdmg..."
    npm run build-dmg
else
    echo "  Installing appdmg (npm install)..."
    npm install --no-save appdmg 2>/dev/null || npm install
    npx appdmg dmg-assets/appdmg.json "$DMG_FINAL"
fi

echo ""
echo "Done! Created: $SCRIPT_DIR/$DMG_FINAL"
echo "Size: $(du -sh "$SCRIPT_DIR/$DMG_FINAL" | cut -f1)"
echo ""
echo "Share this DMG with users. They:"
echo "  1. Open the DMG"
echo "  2. Drag 'Extract Archive.app' to Applications"
echo "  3. Launch the app to complete setup"
