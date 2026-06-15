#!/usr/bin/env bash
set -e

DEV_SHELLS_DIR="$HOME/nix-dotfiles/devshells"

# Check for command-line argument
if [ -n "$1" ]; then
    entry="$1"
    # Verify the entry exists
    if [ ! -d "$DEV_SHELLS_DIR/$entry" ] && [ ! -f "$DEV_SHELLS_DIR/$entry" ]; then
        echo "Error: '$entry' not found in $DEV_SHELLS_DIR"
        exit 1
    fi
else
    # Interactive mode: require fzf
    command -v fzf >/dev/null || { echo "fzf is not installed"; exit 1; }
    entry=$(find "$DEV_SHELLS_DIR" -maxdepth 1 -mindepth 1 -printf "%f\n" | sort | \
        fzf --prompt="Select devshell: ")
    [ -z "$entry" ] && { echo "No selection made"; exit 1; }
fi

ENTRY_PATH="$DEV_SHELLS_DIR/$entry"

# 1. Check for devenv
if [ -d "$ENTRY_PATH" ] && [ -f "$ENTRY_PATH/devenv.nix" ]; then
    echo "Entering devenv shell: $entry"
    exec devenv shell "$ENTRY_PATH"

# 2. Check for directory-based flake
elif [ -d "$ENTRY_PATH" ] && [ -f "$ENTRY_PATH/flake.nix" ]; then
    echo "Entering nix shell from flake: $entry"
    exec nix develop "$ENTRY_PATH"

# 3. Check for standalone flake file
elif [ -f "$ENTRY_PATH" ] && [[ "$ENTRY_PATH" == *.nix ]]; then
    echo "Entering nix shell from file: $entry"
    exec nix develop -f "$ENTRY_PATH"

else
    echo "Invalid devshell (no devenv.nix, flake.nix, or .nix file found)"
    exit 1
fi
