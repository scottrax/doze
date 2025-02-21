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
    # Get keyboard and mouse device IDs
    xinput list | grep -iE 'keyboard|mouse' | grep -v 'Virtual' | cut -d'=' -f2 | cut -f1
}

# Monitor input devices for activity
monitor_activity() {
    local device_ids=($1)
    local start_time=$(date +%s)
    local current_time
    local time_diff
    
    while true; do
        current_time=$(date +%s)
        time_diff=$((current_time - start_time))
        
        # Check each device for recent activity
        for id in "${device_ids[@]}"; do
            if xinput query-state "$id" 2>/dev/null | grep -q "key\["; then
                start_time=$current_time
                break
            fi
        done
        
        # If no activity for 45 seconds, move the mouse
        if [ $time_diff -ge 45 ]; then
            move_mouse
            start_time=$current_time
        fi
        
        sleep 1
    done
}

# Move the mouse up and down
move_mouse() {
    local current_pos=$(xdotool getmouselocation)
    local x=$(echo "$current_pos" | cut -d' ' -f1 | cut -d':' -f2)
    local y=$(echo "$current_pos" | cut -d' ' -f2 | cut -d':' -f2)
    
    # Move mouse up 10 pixels
    xdotool mousemove "$x" $((y-10))
    sleep 0.5
    # Move mouse back down 10 pixels
    xdotool mousemove "$x" "$y"
}

# Main execution
main() {
    # Check for root privileges
    if [ "$(id -u)" -eq 0 ]; then
        echo "Please don't run this script as root"
        exit 1
    fi
    
    # Check if DISPLAY is set
    if [ -z "$DISPLAY" ]; then
        echo "No display found. Are you running this in a graphical environment?"
        exit 1
    fi
    
    # Check dependencies
    check_dependencies
    
    echo "Starting mouse movement monitor..."
    echo "Press Ctrl+C to stop"
    
    # Get input devices and start monitoring
    local device_ids=$(get_input_devices)
    monitor_activity "$device_ids"
}

# Run the main function
main
