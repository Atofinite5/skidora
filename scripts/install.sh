#!/usr/bin/env bash
# Install Skidora skills via the open skills CLI and ensure native Cursor / Claude discovery.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS="${SKILLS:-skidora,skidora-when-not,skidora-helix,skidora-verify,skidora-backend}"
AGENTS="${AGENTS:-cursor,claude-code,antigravity,zed,github-copilot,codex}"

IFS=',' read -r -a SKILL_ARR <<< "$SKILLS"
IFS=',' read -r -a AGENT_ARR <<< "$AGENTS"

SKILL_FLAGS=()
for s in "${SKILL_ARR[@]}"; do
  SKILL_FLAGS+=(-s "$s")
done

AGENT_FLAGS=()
for a in "${AGENT_ARR[@]}"; do
  AGENT_FLAGS+=(-a "$a")
done

echo "⚡ Installing Skidora core skills via skills.sh..."
npx --yes skills add "$ROOT" "${SKILL_FLAGS[@]}" "${AGENT_FLAGS[@]}" -g -y --copy

# Ensure Cursor native discovery path (~/.cursor/skills/) is populated
CURSOR_SKILLS_DIR="$HOME/.cursor/skills"
AGENTS_SKILLS_DIR="$HOME/.agents/skills"

if [ -d "$HOME/.cursor" ]; then
  echo "🔗 Linking Skidora into native Cursor skills path ($CURSOR_SKILLS_DIR)..."
  mkdir -p "$CURSOR_SKILLS_DIR"
  for s in "${SKILL_ARR[@]}"; do
    if [ -d "$AGENTS_SKILLS_DIR/$s" ]; then
      rm -rf "$CURSOR_SKILLS_DIR/$s"
      cp -R "$AGENTS_SKILLS_DIR/$s" "$CURSOR_SKILLS_DIR/$s"
    elif [ -d "$ROOT/skills/$s" ]; then
      rm -rf "$CURSOR_SKILLS_DIR/$s"
      cp -R "$ROOT/skills/$s" "$CURSOR_SKILLS_DIR/$s"
    fi
  done
  echo "✅ Cursor native skills verified in $CURSOR_SKILLS_DIR."
  echo "ℹ️ Please reload Cursor window (Cmd+Shift+P -> 'Developer: Reload Window') or restart Cursor."
fi
