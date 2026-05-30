#!/usr/bin/env bash

set -e

DEV_SHELLS_DIR="$HOME/nix-dotfiles/devshells"

command -v fzf >/dev/null || { echo "fzf is not installed"; exit 1; }

# List everything (dirs + files)
entry=$(find "$DEV_SHELLS_DIR" -maxdepth 1 -mindepth 1 -printf "%f\n" | sort | \
  fzf --prompt="Select devshell: ")

[ -z "$entry" ] && { echo "No selection made"; exit 1; }

ENTRY_PATH="$DEV_SHELLS_DIR/$entry"

# Enter shell immediately (temporary)
if [ -d "$ENTRY_PATH" ] && [ -f "$ENTRY_PATH/.envrc" ]; then
  # For direnv-based shells
  echo "Entering shell with direnv environment..."
  exec bash --rcfile <(echo "source \"$ENTRY_PATH/.envrc\"; exec bash")
elif [ -f "$ENTRY_PATH/flake.nix" ]; then
  # For flake-based shells
  echo "Entering nix shell from flake: $entry"
  cd "$ENTRY_PATH"
  exec nix develop
else
  echo "Invalid devshell (no .envrc or flake.nix)"
  exit 1
fi
