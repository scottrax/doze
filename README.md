# Doze

A lightweight utility to prevent your Linux system from going idle by simulating subtle mouse movements.

## Overview

Doze monitors your keyboard and mouse activity. After a configurable period of inactivity (default: 45 seconds), it will automatically move your mouse cursor slightly to prevent screen locks, sleep mode, or "away" status in messaging applications.

## Features

- Monitors all physical keyboard and mouse devices (ignores virtual devices)
- Configurable inactivity timeout
- Minimal mouse movement (barely noticeable)
- Available in both CLI and GUI versions
- Low resource usage

## Requirements

- Linux with X11 display server
- `xinput` and `xdotool` packages
- `yad` package (for GUI version only)

## Installation
(please see INSTALL.md for automated install options)

1. Clone the repository:
   ```
   git clone https://github.com/scottrax/Doze.git
   cd Doze
   ```

2. Make scripts executable:
   ```
   chmod +x doze.sh doze-gui.sh
   ```

3. Install dependencies:
   ```
   sudo apt update && sudo apt install xinput xdotool yad
   ```

## Usage

### CLI Version (`doze.sh`)

Simply run the script from terminal:

```
./doze.sh
```

The script will:
- Check for required dependencies
- Monitor all keyboard and mouse devices
- Move the mouse slightly every 45 seconds of inactivity
- Display status messages in the terminal
- Run until terminated with Ctrl+C

### GUI Version (`doze-gui.sh`)

For a more user-friendly experience, use the GUI version:

```
./doze-gui.sh
```

Features:
- Adjust inactivity timeout (10-300 seconds)
- Start/Stop button to control the script
- Status indicator showing whether Doze is running
- Clean interface using YAD dialog

## Troubleshooting

- If you see "Missing required dependencies" message, install the mentioned packages.
- If "No display found" appears, ensure you're running in a graphical environment.
- The script should not be run as root for security reasons.

## Limitations

- Works only with X11 (not Wayland)
- Requires graphical environment
- May not prevent all types of system sleep/lock mechanisms

## License

This project is open source and available under the MIT License.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Author

[scottrax](https://github.com/scottrax)
