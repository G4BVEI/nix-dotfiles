#!/usr/bin/env bash

set -e

DEV_SHELLS_DIR="$HOME/nix-dotfiles/devshells"

command -v fzf >/dev/null || { echo "fzf is not installed"; exit 1; }

# List everything (dirs + files)
entry=$(find "$DEV_SHELLS_DIR" -maxdepth 1 -mindepth 1 -printf "%f\n" | sort | \
  fzf --prompt="Select devshell: ")

[ -z "$entry" ] && { echo "No selection made"; exit 1; }

ENTRY_PATH="$DEV_SHELLS_DIR/$entry"

# Decide behavior
if [ -d "$ENTRY_PATH" ] && [ -f "$ENTRY_PATH/.envrc" ]; then
  USE_BLOCK="source_env \"$ENTRY_PATH/.envrc\""
elif [ -f "$ENTRY_PATH/flake.nix" ]; then
  USE_BLOCK="use flake \"$ENTRY_PATH\""
else
  echo "Invalid devshell (no .envrc or not a nix file)"
  exit 1
fi

# Prevent overwrite
if [ -f .envrc ]; then
  echo ".envrc already exists. Overwrite? (y/n)"
  read -r ans
  [[ "$ans" != "y" ]] && exit 0
fi

# Generate .envrc
cat <<EOF > .envrc
export DIRENV_WARN_TIMEOUT=20s
$USE_BLOCK
EOF

echo ""
echo "✅ .envrc created:"
echo "   $USE_BLOCK"
echo ""
direnv allow
