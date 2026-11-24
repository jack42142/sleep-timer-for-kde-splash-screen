#!/usr/bin/env fish

set -l SERVICE "plasma-plasmashell.service"
set -l OVERRIDE_DIR "$HOME/.config/systemd/user/$SERVICE.d"
set -l OVERRIDE_FILE "$OVERRIDE_DIR/override.conf"

echo "=== KDE Plasma Splash Screen Delay Configuration (Fish) ==="
read -l -P "Enter the number of seconds to sleep (enter 0 to remove the delay): " DELAY

# Validate that the input is a non-negative integer
if not string match -qr '^[0-9]+$' -- "$DELAY"
    echo "Error: Please enter an integer only (e.g., 0, 2, 3, 5)."
    exit 1
end

# If 0 is entered -> remove the override configuration
if test "$DELAY" -eq 0
    if test -f "$OVERRIDE_FILE"
        systemctl --user revert "$SERVICE"
        systemctl --user daemon-reload
        echo "Delay removed. $SERVICE has been restored to default."
    else
        echo "No delay configuration is currently set."
    end
    exit 0
end

# Warn if the delay is set too long
if test "$DELAY" -gt 15
    read -l -P "Warning: Setting more than 15 seconds may cause the splash screen to time out (max 30s). Continue? (y/N): " CONFIRM
    if not string match -qr '^[Yy]$' -- "$CONFIRM"
        echo "Operation cancelled."
        exit 0
    end
end

# Create the directory and write override.conf
mkdir -p "$OVERRIDE_DIR"
printf "[Service]\nExecStartPre=/usr/bin/sleep %s\n" "$DELAY" > "$OVERRIDE_FILE"

# Reload the systemd user daemon
systemctl --user daemon-reload

echo "------------------------------------------------"
echo "Set a ${DELAY}-second sleep before starting $SERVICE."
echo "Please log out and log back in to test the effect."
