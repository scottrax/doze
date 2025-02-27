# Installing Doze

There are several ways to install Doze on your Linux system. Choose the method that works best for you.

## Method 1: Direct Installation from GitHub

### Prerequisites

Make sure you have the required dependencies installed:

```bash
sudo apt update && sudo apt install git xinput xdotool yad
```

### Installation Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/scottrax/Doze.git
   cd Doze
   ```

2. Make the scripts executable:
   ```bash
   chmod +x doze.sh doze_gui.sh
   ```

3. Run the installation script:
   ```bash
   sudo ./install.sh
   ```

4. Launch Doze:
   ```bash
   doze-gui
   ```

## Method 2: Install from Debian Package (.deb)

If a pre-built .deb package is available in the releases section of the GitHub repository, you can download and install it directly.

1. Download the latest .deb package from the [Releases page](https://github.com/scottrax/Doze/releases)

2. Install the package:
   ```bash
   sudo dpkg -i doze_*.deb
   sudo apt-get install -f  # Install any missing dependencies
   ```

3. Launch Doze from your applications menu or by running:
   ```bash
   doze-gui
   ```

## Method 3: Build the Debian Package Yourself

You can build the Debian package from source and then install it.

1. Clone the repository:
   ```bash
   git clone https://github.com/scottrax/Doze.git
   cd Doze
   ```

2. Make the build script executable:
   ```bash
   chmod +x build-package.sh
   ```

3. Build the package (optionally specifying a version number):
   ```bash
   ./build-package.sh 1.0.0
   ```

4. Install the newly created package:
   ```bash
   sudo dpkg -i doze_*.deb
   sudo apt-get install -f  # Install any missing dependencies
   ```

5. Launch Doze from your applications menu or by running:
   ```bash
   doze-gui
   ```

## Uninstalling Doze

If you installed Doze using the .deb package:

```bash
sudo apt remove doze
```

If you installed using the direct installation method:

```bash
sudo rm /usr/bin/doze /usr/bin/doze-gui
sudo rm /usr/share/applications/doze.desktop
sudo rm /usr/share/icons/hicolor/scalable/apps/doze.svg
```

## Troubleshooting

- If you get "command not found" after installation, try restarting your terminal.
- If the GUI doesn't appear, ensure yad is installed: `sudo apt install yad`
- If mouse movements don't work, check that xinput and xdotool are installed and working.
