# Mouse Activity Simulator

A bash script for Debian-based systems that automatically moves the mouse cursor when no input activity is detected for 45 seconds. This can be useful for preventing screen locks or maintaining "active" status in applications that monitor user activity.

## Features

- Monitors both keyboard and mouse activity
- Automatically moves the mouse cursor up and down when idle
- Configurable idle timeout (default: 45 seconds)
- Minimal mouse movement to avoid disrupting work
- Non-intrusive operation
- Built-in error handling and dependency checking

## Requirements

- Debian-based Linux distribution (tested on Debian 12)
- X11 window system
- Required packages:
  - `xdotool`
  - `xinput`

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/scottrax/doze.git
   cd doze
   ```

2. Install required dependencies:
   ```bash
   sudo apt-get update && sudo apt-get install xdotool xinput
   ```

3. Make the script executable:
   ```bash
   chmod +x doze.sh
   ```

## Usage

Simply run the script from your terminal:
```bash
./doze.sh
```

The script will:
- Check for required dependencies
- Verify it's running in a graphical environment
- Start monitoring for input activity
- Move the mouse cursor up 10 pixels and back when no activity is detected for 45 seconds
- Continue running until you press Ctrl+C

## Customization

You can modify the following parameters in the script:
- Idle timeout: Change the value `45` in the `monitor_activity()` function
- Mouse movement distance: Change the value `10` in the `move_mouse()` function
- Movement pattern: Modify the `move_mouse()` function to create different movement patterns

# Autostart Configuration

## 1. Create the systemd user service file

Create this file at `~/.config/systemd/user/doze.service`:

```ini
[Unit]
Description=Mouse Activity Simulator
After=graphical-session.target
PartOf=graphical-session.target

[Service]
Type=simple
Environment=DISPLAY=:0
Environment=XAUTHORITY=%h/.Xauthority
ExecStart=/full/path/to/your/doze.sh
Restart=on-failure
RestartSec=30

[Install]
WantedBy=graphical-session.target
```

## 2. Setup Instructions

1. Create the systemd user directory:
```bash
mkdir -p ~/.config/systemd/user/
```

2. Save the service file:
```bash
# Replace /full/path/to/your with your actual path
nano ~/.config/systemd/user/doze.service
```

3. Reload systemd user daemon:
```bash
systemctl --user daemon-reload
```

4. Enable and start the service:
```bash
systemctl --user enable doze.service
systemctl --user start doze.service
```

## Management Commands

- Check status:
```bash
systemctl --user status doze.service
```

- Stop the service:
```bash
systemctl --user stop doze.service
```

- Disable autostart:
```bash
systemctl --user disable doze.service
```

- View logs:
```bash
journalctl --user -u doze.service
```

## Alternative: Autostart using Desktop Entry

If you prefer using the desktop environment's autostart functionality:

1. Create this file at `~/.config/autostart/doze.desktop`:
```ini
[Desktop Entry]
Type=Application
Name=Doze
Exec=/full/path/to/your/doze.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
```

2. Make it executable:
```bash
chmod +x ~/.config/autostart/doze.desktop
```
## 2nd Alternative: update-rc.d autostart

1. In a terminal, run the following:

```
cat > /etc/init.d/doze.sh <<EOL
#! /bin/bash
### BEGIN INIT INFO
# Provides:       doze.sh
# Required-Start:    \$local_fs \$syslog
# Required-Stop:     \$local_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts my-start-script
# Description:       starts my-start-script using start-stop-daemon
### END INIT INFO

# doze.sh

exit 0
EOL
chmod 755 /etc/init.d/doze.sh
update-rc.d doze.sh defaults
```
   

## Troubleshooting

1. If the service fails to start, check the logs:
```bash
journalctl --user -u doze.service -n 50 --no-pager
```

2. Common issues:
   - Wrong path in service file: Update the ExecStart path
   - Display not set: Make sure DISPLAY=:0 is correct for your system
   - Permission issues: Ensure the script is executable
   - Wrong XAUTHORITY: Update the path if your system uses a different location

3. To test the service manually:
```bash
XDG_RUNTIME_DIR=/run/user/$(id -u) systemctl --user start doze.service
```

## Troubleshooting

### Common Issues

1. **Script fails to start**
   - Ensure you have X11 running
   - Check if you're running in a graphical environment
   - Verify all dependencies are installed

2. **Permission denied**
   ```bash
   -bash: ./doze.sh: Permission denied
   ```
   Solution: Make sure the script is executable:
   ```bash
   chmod +x doze.sh
   ```

3. **Missing dependencies**
   The script will tell you which dependencies are missing and how to install them.

### Error Messages

- "Please don't run this script as root"
  - Run the script as a normal user, not with sudo
- "No display found"
  - Make sure you're running in a graphical environment
- "Missing required dependencies"
  - Install the missing packages as indicated by the error message

## Security Considerations

- The script does not require root privileges and should not be run as root
- It only monitors input devices for activity status, not actual keystrokes
- No data is collected or transmitted

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Thanks to the `xdotool` and `xinput` developers
- Inspired by the need to prevent automatic screen locks during long reading sessions

## Version History

- 1.0.0
  - Initial release
  - Basic movement functionality
  - Activity monitoring
  - Dependency checking
