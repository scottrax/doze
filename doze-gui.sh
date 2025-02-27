#!/bin/bash

# Check if yad is installed
if ! command -v yad &> /dev/null; then
    echo "Error: yad is not installed. Install it with 'sudo apt-get install yad'."
    exit 1
fi

# Path to the doze.sh script (assumed in the same directory)
DOZE_SCRIPT="./doze.sh"

# Ensure doze.sh exists and is executable
if [ ! -f "$DOZE_SCRIPT" ] || [ ! -x "$DOZE_SCRIPT" ]; then
    echo "Error: doze.sh not found or not executable in the current directory."
    exit 1
fi

# Function to start the script
start_script() {
    # Kill any existing instance
    pkill -f "$DOZE_SCRIPT"
    # Start doze.sh in the background with the specified timeout
    sed "s/if \[ \$time_diff -ge [0-9]* \]/if [ \$time_diff -ge $TIMEOUT ]/" "$DOZE_SCRIPT" > /tmp/doze_temp.sh
    chmod +x /tmp/doze_temp.sh
    /tmp/doze_temp.sh > /tmp/doze.log 2>&1 &
    PID=$!
    echo "Started doze.sh with PID $PID and timeout $TIMEOUT seconds."
}

# Function to stop the script
stop_script() {
    pkill -f "/tmp/doze_temp.sh"
    rm -f /tmp/doze_temp.sh /tmp/doze.log
    PID=""
    echo "Stopped doze.sh."
}

# Default timeout (in seconds)
TIMEOUT=45
PID=""

# GUI loop using yad
while true; do
    OUTPUT=$(yad --form \
        --title="Doze Control" \
        --width=300 \
        --height=150 \
        --text="Control the mouse activity monitor" \
        --field="Timeout (seconds):NUM" "$TIMEOUT!10..300!5" \
        --field="Status:LBL" "$(if [ -n "$PID" ]; then echo "Running (PID: $PID)"; else echo "Stopped"; fi)" \
        --button="$(if [ -n "$PID" ]; then echo "Stop!gtk-stop"; else echo "Start!gtk-media-play"; fi)":0 \
        --button="Quit!gtk-quit":1 \
        --center \
        --on-top)

    BUTTON=$?
    VALUES=($(echo "$OUTPUT" | tr '|' '\n'))

    # Extract timeout value
    TIMEOUT="${VALUES[0]}"

    # Handle button presses
    case $BUTTON in
        0) # Start/Stop button
            if [ -n "$PID" ]; then
                stop_script
                PID=""
            else
                start_script
            fi
            ;;
        1) # Quit button
            if [ -n "$PID" ]; then
                stop_script
            fi
            break
            ;;
        252) # Window closed
            if [ -n "$PID" ]; then
                stop_script
            fi
            exit 0
            ;;
    esac
done

exit 0
