# Extract Archive - Setup Instructions

This setup allows you to extract archive files directly from Finder using a right-click menu option.

## Quick Setup (5 minutes)

### Option 1: Using Automator (Recommended)

1. **Open Automator** (Applications → Automator)

2. **Create a Quick Action:**
   - Choose "Quick Action" (or "Service" on older macOS versions)
   - Click "Choose"

3. **Configure the workflow:**
   - Set "Workflow receives current" to: **files or folders**
   - Set "in" to: **Finder**

4. **Add actions:**
   - Drag **"Run Shell Script"** from the left sidebar into the workflow
   - Set "Shell" to: **/bin/zsh**
   - Set "Pass input" to: **as arguments**
   - Paste this script:
   ```bash
   for f in "$@"; do
       /Users/yanmcruz/rar/extract.sh "$f"
   done
   ```

5. **Save:**
   - Press Cmd+S
   - Name it: **Extract Archive**
   - Save location: **~/Library/Services/** (it will save automatically)

6. **Test it:**
   - Right-click any archive file (.zip, .rar, .tar, etc.) in Finder
   - You should see "Extract Archive" in the context menu

### Option 2: Command Line Alias

Add this to your `~/.zshrc` file:

```bash
alias extract='/Users/yanmcruz/rar/extract.sh'
```

Then reload: `source ~/.zshrc`

Usage: `extract file.zip`

### Option 3: Keyboard Shortcut (Optional)

1. Go to **System Settings → Keyboard → Keyboard Shortcuts → Services**
2. Find **"Extract Archive"** in the list
3. Assign a keyboard shortcut (e.g., Cmd+E)

## Supported Archive Types

- `.rar` - Uses unrar (from this directory or system)
- `.zip` - Uses unzip
- `.tar` - Uses tar
- `.tar.gz`, `.tgz` - Uses tar
- `.tar.bz2`, `.tbz` - Uses tar
- `.tar.xz` - Uses tar
- `.7z` - Requires p7zip (`brew install p7zip`)
- `.gz` - Uses gunzip
- `.bz2` - Uses bunzip2

## How It Works

1. Extracts the archive to a folder with the same name (without extension)
2. Opens the extracted folder in Finder
3. Shows a notification when complete

## Troubleshooting

- **"unrar not found"**: The script will use the unrar in `/Users/yanmcruz/rar/unrar` if available
- **"7z not found"**: Install p7zip: `brew install p7zip`
- **Permission denied**: Make sure extract.sh is executable: `chmod +x /Users/yanmcruz/rar/extract.sh`
