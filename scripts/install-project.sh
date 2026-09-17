#!/usr/bin/env bash
# Drop portable Skidora boot files into any project so every agent self-starts.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: bash scripts/install-project.sh <project-root>" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"
KIT="$ROOT/project-kit"

if [[ ! -f "$TARGET/AGENTS.md" ]]; then
  cp "$KIT/AGENTS.md" "$TARGET/AGENTS.md"
  echo "Wrote $TARGET/AGENTS.md"
elif ! grep -q Skidora "$TARGET/AGENTS.md"; then
  printf '\n\n%s\n' "$(cat "$KIT/AGENTS.md")" >> "$TARGET/AGENTS.md"
  echo "Appended Skidora block to $TARGET/AGENTS.md"
else
  echo "AGENTS.md already mentions Skidora"
fi

if [[ ! -f "$TARGET/CLAUDE.md" ]]; then
  cp "$KIT/CLAUDE.md" "$TARGET/CLAUDE.md"
  echo "Wrote $TARGET/CLAUDE.md"
elif ! grep -q Skidora "$TARGET/CLAUDE.md"; then
  printf '\n\n%s\n' "$(cat "$KIT/CLAUDE.md")" >> "$TARGET/CLAUDE.md"
  echo "Appended Skidora block to $TARGET/CLAUDE.md"
else
  echo "CLAUDE.md already mentions Skidora"
fi

if command -v skidora >/dev/null 2>&1; then
  skidora init --path "$TARGET"
  echo "Helix files ready at $TARGET/.skidora"
else
  echo "skidora CLI not on PATH; agent will create .skidora/ on first full task"
fi
