#!/usr/bin/env bash
# Auto-sync: commit & push any config changes in this repo.
# Config files in $HOME are symlinks into this repo, so local edits show up
# here immediately; this script just snapshots them to git and pushes.
# Usage: ./sync.sh   (usually run by launchd, see com.dotfiles.sync.plist)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Snapshot Homebrew packages so new installs get committed too
if command -v brew >/dev/null 2>&1; then
  brew bundle dump --force --file="$DOTFILES_DIR/mac/Brewfile" >/dev/null 2>&1 || true
fi

# Nothing to do if the working tree is clean
if [ -z "$(git status --porcelain)" ]; then
  exit 0
fi

git add -A
git commit -m "chore: auto-sync configs ($(date '+%Y-%m-%d %H:%M'))"

# Push if a remote is reachable; failure is non-fatal (retry next run)
git push origin HEAD 2>/dev/null || echo "[sync] push failed, will retry next run" >&2
