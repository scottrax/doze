#!/bin/bash

# Exit on error
set -e

# Display help message
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: $0 [version]"
    echo "Build a Debian package for Doze."
    echo ""
    echo "Arguments:"
    echo "  version    Version number (default: 1.0.0)"
    exit 0
fi

# Set version (default or from argument)
VERSION=${1:-"1.0.0"}
PACKAGE_NAME="doze"
MAINTAINER_EMAIL="scottrax"  # Replace with your email

echo "Building Doze package version $VERSION"

# Clean up previous build
if [ -d "$PACKAGE_NAME" ]; then
    echo "Removing previous build directory..."
    rm -rf "$PACKAGE_NAME"
fi

if [ -f "${PACKAGE_NAME}_${VERSION}_all.deb" ]; then
    echo "Removing previous .deb file..."
    rm "${PACKAGE_NAME}_${VERSION}_all.deb"
fi

# Create directory structure
echo "Creating directory structure..."
mkdir -p "$PACKAGE_NAME/DEBIAN"
mkdir -p "$PACKAGE_NAME/usr/bin"
mkdir -p "$PACKAGE_NAME/usr/share/applications"
mkdir -p "$PACKAGE_NAME/usr/share/icons/hicolor/scalable/apps"
mkdir -p "$PACKAGE_NAME/usr/share/doc/$PACKAGE_NAME"

# Create DEBIAN control file
echo "Creating control file..."
cat > "$PACKAGE_NAME/DEBIAN/control" << EOF
Package: $PACKAGE_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Depends: xinput, xdotool, yad
Maintainer: scottrax <$MAINTAINER_EMAIL>
Description: Prevent system idle by simulating mouse movements
 Doze monitors keyboard and mouse activity and prevents
 the system from going idle by making subtle mouse movements
 after a configurable period of inactivity.
EOF

# Create postinst script
echo "Creating postinst script..."
cat > "$PACKAGE_NAME/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

# Update icon cache after installation
if command -v update-icon-caches >/dev/null; then
    update-icon-caches /usr/share/icons/hicolor/
fi

# Make executables executable (redundant but safe)
chmod +x /usr/bin/doze /usr/bin/doze-gui

echo "Doze has been installed successfully!"
echo "You can run it from the applications menu or by typing 'doze-gui' in terminal."

exit 0
EOF
chmod +x "$PACKAGE_NAME/DEBIAN/postinst"

# Create prerm script
echo "Creating prerm script..."
cat > "$PACKAGE_NAME/DEBIAN/prerm" << 'EOF'
#!/bin/bash
set -e

# Terminate any running instances
pkill -f "doze" 2>/dev/null || true
rm -f /tmp/doze_temp.sh /tmp/doze.log 2>/dev/null || true

exit 0
EOF
chmod +x "$PACKAGE_NAME/DEBIAN/prerm"

# Copy scripts
echo "Copying application scripts..."
cp doze.sh "$PACKAGE_NAME/usr/bin/doze"
cp doze-gui.sh "$PACKAGE_NAME/usr/bin/doze-gui"
chmod +x "$PACKAGE_NAME/usr/bin/doze" "$PACKAGE_NAME/usr/bin/doze-gui"

# Create desktop entry
echo "Creating desktop entry..."
cat > "$PACKAGE_NAME/usr/share/applications/$PACKAGE_NAME.desktop" << EOF
[Desktop Entry]
Name=Doze
Comment=Prevent system idle
Exec=doze-gui
Icon=doze
Terminal=false
Type=Application
Categories=Utility;
EOF

# Create icon
echo "Creating icon..."
cat > "$PACKAGE_NAME/usr/share/icons/hicolor/scalable/apps/$PACKAGE_NAME.svg" << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">
  <circle cx="24" cy="24" r="20" fill="#3498db"/>
  <path d="M18 30c0-2 1.5-3 3-3s3 1 3 3M24 30c0-2 1.5-3 3-3s3 1 3 3" stroke="white" stroke-width="2" fill="none"/>
  <ellipse cx="17" cy="20" rx="3" ry="4" fill="white"/>
  <ellipse cx="31" cy="20" rx="3" ry="4" fill="white"/>
</svg>
EOF

# Copy documentation
echo "Copying documentation..."
cp README.md "$PACKAGE_NAME/usr/share/doc/$PACKAGE_NAME/"

# Calculate package size
SIZE=$(du -s "$PACKAGE_NAME" | cut -f1)
echo "Installed-Size: $SIZE" >> "$PACKAGE_NAME/DEBIAN/control"

# Build the package
echo "Building Debian package..."
dpkg-deb --build "$PACKAGE_NAME" "${PACKAGE_NAME}_${VERSION}_all.deb"

# Check if the build was successful
if [ -f "${PACKAGE_NAME}_${VERSION}_all.deb" ]; then
    echo "Package built successfully: ${PACKAGE_NAME}_${VERSION}_all.deb"
    echo "You can install it with: sudo dpkg -i ${PACKAGE_NAME}_${VERSION}_all.deb"
    echo "If dependencies are missing, run: sudo apt-get install -f"
else
    echo "Package build failed."
    exit 1
fi
