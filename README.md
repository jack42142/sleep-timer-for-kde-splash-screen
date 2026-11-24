# sleep-timer-for-kde-splash-screen
## KDE Plasma Splash Screen Delay Script

A lightweight utility script to add a custom startup delay (`ExecStartPre=/usr/bin/sleep`) to `plasma-plasmashell.service`. This ensures your KDE Plasma splash screen (`ksplashqml`) plays its full animation smoothly before the desktop environment loads—especially useful on fast NVMe systems where the desktop appears before the splash animation finishes.

Both **Bash** (`set-splash-delay.sh`) and **Fish** (`set-splash-delay.fish`) versions are included.

### Prerequisites
* KDE Plasma (5.25+ or Plasma 6) running with systemd user session management (`plasma-plasmashell.service`)[cite: 1, 2].
* `bash` or `fish` shell[cite: 1, 2].

### Usage

1. **Make the script executable:**
   * For **Bash / Zsh**:
     ```bash
     chmod +x set-splash-delay.sh
     ```
   * For **Fish**:
     ```fish
     chmod +x set-splash-delay.fish
     ```

2. **Run the script:**
   * For **Bash / Zsh**:
     ```bash
     ./set-splash-delay.sh
     ```
   * For **Fish**:
     ```fish
     ./set-splash-delay.fish
     ```

3. **Configure the delay:**
   * Enter the desired delay in **seconds** (e.g., `2`, `3`, or `5`)[cite: 1, 2].
   * Enter `0` at any time to remove the override and restore default startup speed[cite: 1, 2].
   * **Log out** and **log back in** to see the updated splash screen duration[cite: 1, 2].

> **Note:** Setting a delay longer than 15 seconds will trigger a confirmation warning, as KDE Plasma's splash screen automatically times out after 30 seconds[cite: 1, 2].

### How It Works
The script creates a systemd user drop-in override at `~/.config/systemd/user/plasma-plasmashell.service.d/override.conf` containing[cite: 1, 2]:
```ini
[Service]
ExecStartPre=/usr/bin/sleep <seconds>
