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

# Prune obsolete zombie skills from past versions
PRUNE_LIST=(
  "skidora-agent-handling"
  "skidora-cd"
  "skidora-frontend"
  "skidora-graphifier"
  "skidora-gsd"
  "skidora-intake"
  "skidora-network"
  "skidora-planning"
  "skidora-security"
)

PRUNE_DIRS=(
  "$HOME/.agents/skills"
  "$HOME/.cursor/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.gemini/antigravity/skills"
)

AGENTS_SKILLS_DIR="$HOME/.agents/skills"

echo "🧹 Pruning deprecated zombie skills across agent skill directories..."
for target_dir in "${PRUNE_DIRS[@]}"; do
  if [ -d "$target_dir" ]; then
    for dead in "${PRUNE_LIST[@]}"; do
      if [ -e "$target_dir/$dead" ]; then
        rm -rf "$target_dir/$dead"
        echo "  - Removed $target_dir/$dead"
      fi
    done
  fi
done

echo "⚡ Installing Skidora core skills via skills.sh..."
npx --yes skills add "$ROOT" "${SKILL_FLAGS[@]}" "${AGENT_FLAGS[@]}" -g -y --copy

# Ensure all existing agent homes have all 6 core skills
AGENT_HOMES=(
  "$HOME/.cursor/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
)

echo "🔗 Ensuring 6 core skills across active agent directories..."
for target_dir in "${AGENT_HOMES[@]}"; do
  parent_home="$(dirname "$target_dir")"
  if [ -d "$parent_home" ]; then
    mkdir -p "$target_dir"
    for s in "${SKILL_ARR[@]}"; do
      if [ -d "$AGENTS_SKILLS_DIR/$s" ]; then
        rm -rf "$target_dir/$s"
        cp -R "$AGENTS_SKILLS_DIR/$s" "$target_dir/$s"
      elif [ -d "$ROOT/skills/$s" ]; then
        rm -rf "$target_dir/$s"
        cp -R "$ROOT/skills/$s" "$target_dir/$s"
      fi
    done
    echo "  ✅ Verified 6 skills in $target_dir"
  fi
done

echo "🎉 Installation complete. Please reload your editor/agent window if needed."
