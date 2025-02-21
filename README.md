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
