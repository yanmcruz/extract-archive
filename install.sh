#!/bin/bash

# Extract Archive — Terminal Installer
# For users who download the ZIP. Run: chmod +x install.sh && ./install.sh

set -e

INSTALL_DIR="$HOME/.local/bin/extract-archive"
SERVICES_DIR="$HOME/Library/Services"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "  Extract Archive — Installation"
echo "=========================================="
echo ""

# Copy files
echo "Copying files to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/extract.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/unrar" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/rar" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/default.sfx" "$INSTALL_DIR/" 2>/dev/null || true
cp "$SCRIPT_DIR/rarfiles.lst" "$INSTALL_DIR/" 2>/dev/null || true
cp "$SCRIPT_DIR/fix-security.sh" "$INSTALL_DIR/" 2>/dev/null || true

# Permissions
chmod +x "$INSTALL_DIR/extract.sh"
chmod +x "$INSTALL_DIR/unrar"
chmod +x "$INSTALL_DIR/rar"
chmod +x "$INSTALL_DIR/fix-security.sh" 2>/dev/null || true

# Remove quarantine
xattr -dr com.apple.quarantine "$INSTALL_DIR" 2>/dev/null || true

# Create Finder Quick Action
echo "Creating Finder Quick Action..."
mkdir -p "$SERVICES_DIR/Extract Archive.workflow/Contents"

cat > "$SERVICES_DIR/Extract Archive.workflow/Contents/document.wflow" << 'WORKFLOW_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AMApplicationBuild</key>
	<string>520</string>
	<key>AMApplicationVersion</key>
	<string>2.11</string>
	<key>AMDocumentVersion</key>
	<string>2</string>
	<key>actions</key>
	<array>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<true/>
					<key>Types</key>
					<array>
						<string>public.item</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.0.3</string>
				<key>AMApplication</key>
				<array>
					<string>Automator</string>
				</array>
				<key>AMParameterProperties</key>
				<dict>
					<key>AMShowWhenRun</key>
					<false/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Types</key>
					<array>
						<string>public.file-url</string>
					</array>
				</dict>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Get Selected Finder Items.action</string>
				<key>ActionName</key>
				<string>Get Selected Finder Items</string>
				<key>ActionParameters</key>
				<dict>
					<key>AMShowWhenRun</key>
					<false/>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.GetSelectedFinderItems</string>
				<key>CFBundleVersion</key>
				<string>2.0.3</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<true/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Category</key>
				<array>
					<string>AMCategoryUtilities</string>
				</array>
				<key>Class Name</key>
				<string>GetSelectedFinderItemsAction</string>
				<key>InputUUID</key>
				<string>0</string>
				<key>Keywords</key>
				<array>
					<string>Finder</string>
					<string>File</string>
					<string>Item</string>
					<string>Selection</string>
					<string>Selected</string>
					<string>Get</string>
				</array>
				<key>OutputUUID</key>
				<string>1</string>
				<key>UUID</key>
				<string>E6218F8B-51D6-4F1C-9F8A-123456789ABC</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Finder</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>AMShowWhenRun</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
				</dict>
				<key>conversionLabel</key>
				<integer>0</integer>
				<key>isViewVisible</key>
				<integer>1</integer>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<true/>
					<key>Types</key>
					<array>
						<string>public.file-url</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.0.3</string>
				<key>AMApplication</key>
				<array>
					<string>Automator</string>
				</array>
				<key>AMParameterProperties</key>
				<dict>
					<key>COMMAND_STRING</key>
					<dict>
						<key>NSTextAlignment</key>
						<integer>0</integer>
					</dict>
					<key>CheckedForUserDefaultShell</key>
					<true/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>None</string>
				</dict>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Run Shell Script.action</string>
				<key>ActionName</key>
				<string>Run Shell Script</string>
				<key>ActionParameters</key>
				<dict>
					<key>COMMAND_STRING</key>
					<string>for f in "$@"; do
    "$HOME/.local/bin/extract-archive/extract.sh" "$f"
done</string>
					<key>CheckedForUserDefaultShell</key>
					<true/>
					<key>CheckedForUserShell</key>
					<string>/bin/zsh</string>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.RunShellScript</string>
				<key>CFBundleVersion</key>
				<string>2.0.3</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<false/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Category</key>
				<array>
					<string>AMCategoryUtilities</string>
				</array>
				<key>Class Name</key>
				<string>RunShellScriptAction</string>
				<key>InputUUID</key>
				<string>1</string>
				<key>Keywords</key>
				<array>
					<string>Shell</string>
					<string>Script</string>
					<string>Run</string>
					<string>Execute</string>
					<string>Command</string>
				</array>
				<key>OutputUUID</key>
				<string>2</string>
				<key>UUID</key>
				<string>F6218F8B-51D6-4F1C-9F8A-123456789ABD</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Terminal</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>COMMAND_STRING</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
					<key>1</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>CheckedForUserDefaultShell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>1</string>
					</dict>
				</dict>
				<key>conversionLabel</key>
				<integer>0</integer>
				<key>isViewVisible</key>
				<integer>1</integer>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>connectors</key>
	<dict/>
	<key>workflowType</key>
	<string>QuickAction</string>
	<key>workflowMetaData</key>
	<dict>
		<key>serviceApplicationBundleID</key>
		<string>com.apple.finder</string>
		<key>serviceInputTypeIdentifier</key>
		<string>public.item</string>
		<key>serviceOutputTypeIdentifier</key>
		<string>public.item</string>
		<key>serviceProvidesApplicationBundleID</key>
		<false/>
		<key>serviceBundleID</key>
		<string>com.apple.Automator.Extract Archive</string>
		<key>serviceName</key>
		<string>Extract Archive</string>
		<key>serviceDescription</key>
		<string>Extract archive files (rar, zip, tar, etc.)</string>
		<key>serviceCategory</key>
		<string>public.item</string>
		<key>serviceInputPathIdentifier</key>
		<string>public.item</string>
		<key>serviceOutputPathIdentifier</key>
		<string>public.item</string>
		<key>serviceApplicationPath</key>
		<string>/System/Library/CoreServices/Finder.app</string>
		<key>serviceReceivesFiles</key>
		<integer>1</integer>
		<key>serviceInputFileTypes</key>
		<array>
			<string>public.item</string>
		</array>
		<key>serviceOutputFileTypes</key>
		<array>
			<string>public.item</string>
		</array>
		<key>serviceWorkflowType</key>
		<string>QuickAction</string>
		<key>serviceWorkflowActions</key>
		<array>
			<string>com.apple.GetSelectedFinderItems</string>
			<string>com.apple.RunShellScript</string>
		</array>
	</dict>
</dict>
</plist>
WORKFLOW_EOF

cat > "$SERVICES_DIR/Extract Archive.workflow/Contents/Info.plist" << 'INFOPLIST_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleIdentifier</key>
	<string>com.apple.Automator.Extract Archive</string>
	<key>CFBundleName</key>
	<string>Extract Archive</string>
	<key>CFBundleVersion</key>
	<string>1.0</string>
</dict>
</plist>
INFOPLIST_EOF

echo ""
echo "Installation complete!"
echo ""
echo "Next: Right-click any archive file in Finder and select 'Extract Archive'."
echo ""
echo "If macOS blocks unrar the first time, run: $INSTALL_DIR/fix-security.sh"
echo ""
