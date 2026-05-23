#!/bin/bash

# Exit protection:
# -u = error if undefined variable used
set -u

# Notification app name
APP_NAME="Theme Switcher"

# Base directories
COLORSCHEMES_DIR="$HOME/.config/colorschemes"
WAYBAR_DIR="$HOME/.config/waybar"
ROFI_DIR="$HOME/.config/rofi"
HYPR_DIR="$HOME/.config/hypr"
SWAYNC_DIR="$HOME/.config/swaync"
GTK3_DIR="$HOME/.config/gtk-3.0"
GTK4_DIR="$HOME/.config/gtk-4.0"
NWG_DIR="$HOME/.local/share/nwg-look"

# Waybar relaunch script
WAYBAR_LAUNCH_SCRIPT="$WAYBAR_DIR/scripts/launch.sh"

# Simple notification helper
notify() {
    notify-send "$APP_NAME" "$1"
}

# OSD-style notification helper
notify_osd() {
    notify-send -e \
        -h string:x-canonical-private-synchronous:osd \
        "$APP_NAME" "$1"
}

# Exit script with error message
die() {
    notify "$1"
    echo "ERROR: $1" >&2
    exit 1
}

# Check required command exists
need_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

# Safely create symlink for file
safe_symlink_file() {
    local src="$1"
    local dst="$2"

    # Validate source file exists
    [ -f "$src" ] || die "File not found: $src"

    # Create destination parent directory if missing
    mkdir -p "$(dirname "$dst")"

    # Force replace symlink
    ln -sfn "$src" "$dst"
}

# Safely create symlink for directory
safe_symlink_dir() {
    local src="$1"
    local dst="$2"

    # Validate source directory exists
    [ -d "$src" ] || die "Directory not found: $src"

    # Create destination parent directory if missing
    mkdir -p "$(dirname "$dst")"

    # Backup existing real directory
    # Prevent accidental deletion with rm -rf
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        local backup="${dst}.backup.$(date +%Y%m%d-%H%M%S)"

        mv "$dst" "$backup" || die "Failed to backup: $dst"

        notify "Backup created: $backup"
    fi

    # Remove old symlink only
    rm -f "$dst"

    # Create new symlink
    ln -sfn "$src" "$dst"
}

# Symlink file only if it exists
optional_symlink_file() {
    local src="$1"
    local dst="$2"

    if [ -f "$src" ]; then
        safe_symlink_file "$src" "$dst"
    fi
}

# Theme selector:
# - use argument if provided
# - otherwise open rofi menu
select_theme() {
    if [ -n "${1:-}" ]; then
        echo "$1"
        return
    fi

    # Validate colorscheme directory exists
    [ -d "$COLORSCHEMES_DIR" ] || die "Colorschemes directory not found: $COLORSCHEMES_DIR"

    # Validate rofi menu script exists
    [ -x "$ROFI_DIR/launchers/type-1/menus.sh" ] || die "Rofi menu script not found or not executable"

    # Find available themes
    find "$COLORSCHEMES_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        ! -name ".vscode" \
        -printf "%f\n" \
        | sort \
        | "$ROFI_DIR/launchers/type-1/menus.sh"
}

# Apply waybar theme
apply_waybar() {
    local theme_dir="$1"

    # Link style.css
    safe_symlink_file \
        "$theme_dir/waybar/style.css" \
        "$WAYBAR_DIR/style.css"

    # Link colors directory
    safe_symlink_file \
        "$theme_dir/waybar/colors.css" \
        "$WAYBAR_DIR/colors/colors.css"
}

# Apply rofi colors
apply_rofi() {
    local theme_dir="$1"

    optional_symlink_file \
        "$theme_dir/rofi/colors.rasi" \
        "$ROFI_DIR/shared/colors.rasi"
    
    optional_symlink_file \
        "$theme_dir/wallpaper.png" \
        "$ROFI_DIR/images/wallrof.png"
}

# Apply wallpaper using awww
apply_wallpaper() {
    local theme_dir="$1"

    local wallpaper_src="$theme_dir/wallpaper.png"

    if [ -f "$wallpaper_src" ]; then
        awww img "$wallpaper_src" \
            --transition-type grow \
            --transition-duration 4
    else
        notify "Wallpaper not found: $wallpaper_src"
    fi
}

# Apply hyprlock wallpaper
apply_hyprlock() {
    local theme_dir="$1"

    optional_symlink_file \
        "$theme_dir/wallpaper.png" \
        "$HYPR_DIR/hyprlock-wallpaper.png"
}

# Apply hyprland decoration module
apply_hyprland() {
    local theme_dir="$1"

    optional_symlink_file \
        "$theme_dir/hyprland/decorations.lua" \
        "$HYPR_DIR/modules/decorations.lua"
}

# Reload services after applying theme
reload_services() {

    # Relaunch waybar
    if [ -x "$WAYBAR_LAUNCH_SCRIPT" ]; then
        "$WAYBAR_LAUNCH_SCRIPT"
    else
        notify "Waybar launch script not found or not executable"
    fi

    # Reload Hyprland config
    hyprctl reload >/dev/null 2>&1 || notify "Hyprland reload failed"
}

# Apply kitty theme
apply_kitty() {
    local theme_dir="$1"

    optional_symlink_file \
        "$theme_dir/kitty/colors.conf" \
        "$HOME/.config/kitty/colors.conf"

    # Reload all running kitty windows
    if pgrep -x kitty >/dev/null 2>&1; then
        pkill -SIGUSR1 kitty
    fi
}

# Apply swaync
apply_swaync() {
    local theme_dir="$1"

# Colors
    optional_symlink_file \
        "$theme_dir/swaync/colors.css" \
        "$SWAYNC_DIR/colors/colors.css"

    # Notifications
    optional_symlink_file \
        "$theme_dir/swaync/notifications.css" \
        "$SWAYNC_DIR/themes/nova-dark/notifications.css"

    # Control center
    optional_symlink_file \
        "$theme_dir/swaync/central_control.css" \
        "$SWAYNC_DIR/themes/nova-dark/central_control.css"

    if pgrep -x swaync >/dev/null 2>&1; then
        pkill swaync
        swaync &
    fi
}

apply_gtk() {
    local theme_dir="$1"

    optional_symlink_file \
        "$theme_dir/gtk/gsettings" \
        "$NWG_DIR/gsettings"

    sleep 0.2

    if ! nwg-look -a; then
    notify "GTK apply failed (-a)"
    return 1
    fi

    if ! nwg-look -x; then
        notify "GTK export failed (-x)"
        return 1
    fi
}

# Main execution flow
main() {

    # Validate required commands
    need_cmd notify-send
    need_cmd find
    need_cmd sort
    need_cmd awww
    need_cmd hyprctl
    need_cmd nwg-look

    # Select theme
    local theme
    theme="$(select_theme "${1:-}")"

    # Exit if no theme selected
    [ -n "$theme" ] || exit 0

    # Current selected theme directory
    local theme_dir="$COLORSCHEMES_DIR/$theme"

    # Validate theme exists
    [ -d "$theme_dir" ] || die "Theme not found: $theme"

    # Apply all theme modules
    apply_waybar "$theme_dir"
    apply_rofi "$theme_dir"
    apply_wallpaper "$theme_dir"
    apply_hyprlock "$theme_dir"
    apply_hyprland "$theme_dir"
    apply_kitty "$theme_dir"
    apply_swaync "$theme_dir"
    apply_gtk "$theme_dir"

    # Reload UI/services
    reload_services

    # Success notification
    notify_osd "Theme changed: $theme"
}

# Start script
main "$@"