#!/bin/bash

# Fix macOS Security Issues for RAR Tools
# This script removes quarantine attributes and helps bypass Gatekeeper

SCRIPT_DIR="/Users/yanmcruz/rar"

echo "Fixing macOS security settings for RAR tools..."
echo ""

# Remove quarantine attributes
echo "Removing quarantine attributes..."
xattr -d com.apple.quarantine "$SCRIPT_DIR/unrar" 2>/dev/null && echo "✓ Removed quarantine from unrar" || echo "  No quarantine on unrar"
xattr -d com.apple.quarantine "$SCRIPT_DIR/rar" 2>/dev/null && echo "✓ Removed quarantine from rar" || echo "  No quarantine on rar"

echo ""
echo "If you still see security warnings, try one of these:"
echo ""
echo "Option 1 (Easiest):"
echo "  1. Right-click on unrar in Finder"
echo "  2. Hold Option key and select 'Open'"
echo "  3. Click 'Open' in the security dialog"
echo ""
echo "Option 2 (Terminal):"
echo "  sudo spctl --master-disable  # Disables Gatekeeper (not recommended)"
echo ""
echo "Option 3 (System Settings):"
echo "  1. Go to System Settings → Privacy & Security"
echo "  2. Scroll down to 'Security' section"
echo "  3. Click 'Allow Anyway' if unrar appears there"
echo ""
echo "After allowing, try running: $SCRIPT_DIR/extract.sh <archive-file>"
