#!/bin/bash

# Extract Archive Script
# Handles: .rar, .zip, .tar, .tar.gz, .tar.bz2, .7z, .gz, .bz2

# Get the file path from argument or stdin
if [ -n "$1" ]; then
    ARCHIVE="$1"
else
    # If no argument, try to get from stdin (for Automator)
    read ARCHIVE
fi

# Check if file exists
if [ ! -f "$ARCHIVE" ]; then
    osascript -e 'display notification "File not found: '"$ARCHIVE"'" with title "Extract Error"'
    exit 1
fi

# Get directory and filename
DIR=$(dirname "$ARCHIVE")
FILENAME=$(basename "$ARCHIVE")
NAME="${FILENAME%.*}"

# Determine extraction directory (same as archive location)
EXTRACT_DIR="$DIR/$NAME"

# Create extraction directory
mkdir -p "$EXTRACT_DIR"

# Extract based on file extension
case "$FILENAME" in
    *.rar)
        # Use unrar if available
        UNRAR_PATH=""
        if command -v unrar &> /dev/null; then
            UNRAR_PATH="unrar"
        elif [ -f "/Users/yanmcruz/rar/unrar" ]; then
            UNRAR_PATH="/Users/yanmcruz/rar/unrar"
        elif [ -f "$(dirname "$0")/unrar" ]; then
            UNRAR_PATH="$(dirname "$0")/unrar"
        else
            osascript -e 'display notification "unrar not found. Please install RAR tools." with title "Extract Error"'
            exit 1
        fi
        # Remove quarantine attribute if present and execute
        xattr -d com.apple.quarantine "$UNRAR_PATH" 2>/dev/null
        "$UNRAR_PATH" x "$ARCHIVE" "$EXTRACT_DIR/"
        ;;
    *.zip)
        unzip -q "$ARCHIVE" -d "$EXTRACT_DIR/"
        ;;
    *.tar)
        tar -xf "$ARCHIVE" -C "$EXTRACT_DIR/"
        ;;
    *.tar.gz|*.tgz)
        tar -xzf "$ARCHIVE" -C "$EXTRACT_DIR/"
        ;;
    *.tar.bz2|*.tbz)
        tar -xjf "$ARCHIVE" -C "$EXTRACT_DIR/"
        ;;
    *.tar.xz)
        tar -xJf "$ARCHIVE" -C "$EXTRACT_DIR/"
        ;;
    *.7z)
        if command -v 7z &> /dev/null; then
            7z x "$ARCHIVE" -o"$EXTRACT_DIR/"
        else
            osascript -e 'display notification "7z not found. Please install p7zip." with title "Extract Error"'
            exit 1
        fi
        ;;
    *.gz)
        gunzip -c "$ARCHIVE" > "$EXTRACT_DIR/$NAME"
        ;;
    *.bz2)
        bunzip2 -c "$ARCHIVE" > "$EXTRACT_DIR/$NAME"
        ;;
    *)
        osascript -e 'display notification "Unsupported archive type: '"$FILENAME"'" with title "Extract Error"'
        exit 1
        ;;
esac

# Check if extraction was successful
if [ $? -eq 0 ]; then
    # Open the extracted folder in Finder
    open "$EXTRACT_DIR"
    osascript -e 'display notification "Extracted to: '"$EXTRACT_DIR"'" with title "Extraction Complete"'
else
    osascript -e 'display notification "Extraction failed for: '"$FILENAME"'" with title "Extract Error"'
    exit 1
fi
