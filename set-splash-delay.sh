#!/usr/bin/env bash

SERVICE="plasma-plasmashell.service"
OVERRIDE_DIR="$HOME/.config/systemd/user/${SERVICE}.d"
OVERRIDE_FILE="$OVERRIDE_DIR/override.conf"

echo "=== KDE Plasma Splash Screen Delay Configuration ==="
read -rp "Enter the number of seconds to sleep (enter 0 to remove the delay): " DELAY

# Validate that the input is a non-negative integer
if ! [[ "$DELAY" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter an integer only (e.g., 0, 2, 3, 5)."
    exit 1
fi

# If 0 is entered -> remove the override configuration
if [ "$DELAY" -eq 0 ]; then
    if [ -f "$OVERRIDE_FILE" ]; then
        systemctl --user revert "$SERVICE"
        systemctl --user daemon-reload
        echo "Delay removed. $SERVICE has been restored to default."
    else
        echo "No delay configuration is currently set."
    fi
    exit 0
fi

# Warn if the delay is set too long
if [ "$DELAY" -gt 15 ]; then
    read -rp "Warning: Setting more than 15 seconds may cause the splash screen to time out (max 30s). Continue? (y/N): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        exit 0
    fi
fi

# Create the directory and write override.conf
mkdir -p "$OVERRIDE_DIR"
cat <<EOF > "$OVERRIDE_FILE"
[Service]
ExecStartPre=/usr/bin/sleep $DELAY
EOF

# Reload the systemd user daemon
systemctl --user daemon-reload

echo "------------------------------------------------"
echo "Set a ${DELAY}-second sleep before starting $SERVICE."
echo "Please log out and log back in to test the effect."
