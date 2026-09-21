#!/usr/bin/env bash
# Install Skidora skills via the open skills CLI and ensure native Cursor / Claude / Codex discovery.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS="${SKILLS:-skidora,skidora-when-not,skidora-helix,skidora-verify,skidora-backend,skidora-erlang-elixir}"
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

PRUNE_DIRS=(
  "$HOME/.agents/skills"
  "$HOME/.cursor/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.gemini/antigravity/skills"
)

AGENTS_SKILLS_DIR="$HOME/.agents/skills"

echo "🧹 Pruning deprecated zombie skills across agent skill directories..."
# Unregister legacy skills from skills-cli registry if present
npx --yes skills remove skidora-planning skidora-gsd skidora-network skidora-intake skidora-graphifier skidora-frontend skidora-cd skidora-security skidora-agent-handling -g -y 2>/dev/null || true

for target_dir in "${PRUNE_DIRS[@]}"; do
  if [ -d "$target_dir" ]; then
    # Dynamically purge any skidora directory that is not in the canonical 6-pack
    for item in "$target_dir"/skidora*; do
      [ -e "$item" ] || [ -L "$item" ] || continue
      base="$(basename "$item")"
      is_valid=false
      for valid in "${SKILL_ARR[@]}"; do
        if [ "$base" = "$valid" ]; then
          is_valid=true
          break
        fi
      done
      if [ "$is_valid" = false ]; then
        rm -rf "$item"
        echo "  - Removed zombie skill: $item"
      fi
    done
  fi
done

echo "⚡ Installing Skidora core skills via skills.sh..."
npx --yes skills add "$ROOT" "${SKILL_FLAGS[@]}" "${AGENT_FLAGS[@]}" -g -y

# Agent homes where native symlink discovery is enforced
AGENT_HOMES=(
  "$HOME/.cursor/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
)

echo "🔗 Enforcing real symlinks across active agent directories..."
for target_dir in "${AGENT_HOMES[@]}"; do
  parent_home="$(dirname "$target_dir")"
  if [ -d "$parent_home" ]; then
    mkdir -p "$target_dir"
    for s in "${SKILL_ARR[@]}"; do
      src="$AGENTS_SKILLS_DIR/$s"
      if [ ! -d "$src" ] && [ -d "$ROOT/skills/$s" ]; then
        src="$ROOT/skills/$s"
      fi
      if [ -e "$target_dir/$s" ] || [ -L "$target_dir/$s" ]; then
        rm -rf "$target_dir/$s"
      fi
      ln -sfn "$src" "$target_dir/$s"
    done
    echo "  ✅ Verified real symlinks in $target_dir"
  fi
done

echo "🎉 Installation complete. 6 core skills active with native discovery."
