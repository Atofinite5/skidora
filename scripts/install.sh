#!/usr/bin/env bash
# Install Skidora skills via the open skills CLI (Cursor, Claude, Antigravity, Zed, …).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS="${SKILLS:-skidora,skidora-helix,skidora-when-not,skidora-intake,skidora-planning,skidora-gsd,skidora-frontend,skidora-backend,skidora-erlang-elixir,skidora-cd,skidora-graphifier,skidora-verify,skidora-security,skidora-agent-handling}"
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
npx --yes skills add "$ROOT" "${SKILL_FLAGS[@]}" "${AGENT_FLAGS[@]}" -g -y --copy
