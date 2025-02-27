#!/bin/bash

# Exit on error
set -e

echo "Doze Installer Script"
echo "---------------------"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Check dependencies
echo "Checking dependencies..."
MISSING_DEPS=()

for CMD in xinput xdotool yad; do
    if ! command -v "$CMD" &> /dev/null; then
        MISSING_DEPS+=("$CMD")
    fi
done

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo "Installing missing dependencies: ${MISSING_DEPS[*]}"
    apt-get update && apt-get install -y ${MISSING_DEPS[*]}
fi

# Copy scripts to /usr/bin
echo "Installing scripts..."
cp doze.sh /usr/bin/doze
cp doze-gui.sh /usr/bin/doze-gui
chmod +x /usr/bin/doze /usr/bin/doze-gui

# Create desktop entry
echo "Creating desktop entry..."
cat > /usr/share/applications/doze.desktop << EOF
[Desktop Entry]
Name=Doze
Comment=Prevent system idle
Exec=doze-gui
Terminal=false
Type=Application
Categories=Utility;
EOF

# Create simple icon if SVG directory exists
if [ -d "/usr/share/icons/hicolor/scalable/apps" ]; then
    echo "Creating icon..."
    cat > /usr/share/icons/hicolor/scalable/apps/doze.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">
  <circle cx="24" cy="24" r="20" fill="#3498db"/>
  <path d="M18 30c0-2 1.5-3 3-3s3 1 3 3M24 30c0-2 1.5-3 3-3s3 1 3 3" stroke="white" stroke-width="2" fill="none"/>
  <ellipse cx="17" cy="20" rx="3" ry="4" fill="white"/>
  <ellipse cx="31" cy="20" rx="3" ry="4" fill="white"/>
</svg>
EOF

    # Update icon cache if command exists
    if command -v update-icon-caches >/dev/null; then
        update-icon-caches /usr/share/icons/hicolor/
    fi
fi

echo "Installation complete!"
echo "You can now run Doze from your applications menu or by typing 'doze-gui' in terminal."
