#!/bin/bash

# Check if required packages are installed
check_dependencies() {
    local missing_deps=()
    
    for cmd in xdotool xinput; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "Missing required dependencies: ${missing_deps[*]}"
        echo "Please install them using:"
        echo "sudo apt-get update && sudo apt-get install ${missing_deps[*]}"
        exit 1
    fi
}

# Get the IDs of input devices we want to monitor
get_input_devices() {
    xinput list | grep -iE 'keyboard|mouse' | grep -v 'Virtual' | cut -d'=' -f2 | cut -f1
}

# Move the mouse up and down
move_mouse() {
    local current_pos=$(xdotool getmouselocation --shell)
    eval "$current_pos"  # Sets X and Y variables
    xdotool mousemove "$X" $((Y-10))
    sleep 0.5
    xdotool mousemove "$X" "$Y"
}

# Monitor input devices for activity
monitor_activity() {
    local device_ids=($1)
    local start_time=$(date +%s)
    local last_mouse_pos=$(xdotool getmouselocation)
    local current_time
    local time_diff
    
    echo "Monitoring devices: ${device_ids[*]}"
    
    while true; do
        current_time=$(date +%s)
        time_diff=$((current_time - start_time))
        current_mouse_pos=$(xdotool getmouselocation)
        
        # Check mouse movement
        if [ "$current_mouse_pos" != "$last_mouse_pos" ]; then
            start_time=$current_time
            last_mouse_pos=$current_mouse_pos
            echo "Mouse moved, resetting timer"
        fi
        
        # Check keyboard activity (any key down)
        for id in "${device_ids[@]}"; do
            if xinput query-state "$id" 2>/dev/null | grep -q "key\[.*\]=down"; then
                start_time=$current_time
                last_mouse_pos=$current_mouse_pos
                echo "Key pressed on device $id, resetting timer"
                break
            fi
        done
        
        # If no activity for 45 seconds, move the mouse
        if [ $time_diff -ge 45 ]; then
            echo "No activity for 45s, moving mouse"
            move_mouse
            start_time=$current_time
            last_mouse_pos=$(xdotool getmouselocation)
        fi
        
        sleep 1
    done
}

# Main execution
main() {
    if [ "$(id -u)" -eq 0 ]; then
        echo "Please don't run this script as root"
        exit 1
    fi
    
    if [ -z "$DISPLAY" ]; then
        echo "No display found. Are you running this in a graphical environment?"
        exit 1
    fi
    
    check_dependencies
    echo "Starting mouse movement monitor..."
    echo "Press Ctrl+C to stop"
    
    local device_ids=$(get_input_devices)
    monitor_activity "$device_ids"
}

main
