#!/usr/bin/env bash
# Install Skidora. Default * is the 4 core. Erlang only on BEAM. Prune v1/v2. Fail loud.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

CORE_SKILLS=(skidora skidora-when-not skidora-helix skidora-verify)
OPTIONAL_BACKEND=skidora-backend
OPTIONAL_ERLANG=skidora-erlang-elixir
CANONICAL_PACK=(skidora skidora-when-not skidora-helix skidora-verify skidora-backend skidora-erlang-elixir)
ZOMBIES=(skidora-planning skidora-gsd skidora-network skidora-intake skidora-graphifier skidora-frontend skidora-cd skidora-security skidora-agent-handling)

AGENTS="${AGENTS:-cursor,claude-code,antigravity,zed,github-copilot,codex}"
IFS=',' read -r -a AGENT_ARR <<< "$AGENTS"

# Default *: 4 core + backend. Erlang only when mix.exs / rebar.config exists (or SKILLS override).
if [[ -z "${SKILLS:-}" ]]; then
  SKILL_ARR=("${CORE_SKILLS[@]}" "$OPTIONAL_BACKEND")
  if [[ -f "$PWD/mix.exs" || -f "$PWD/rebar.config" || -f "$ROOT/mix.exs" || -f "$ROOT/rebar.config" ]]; then
    SKILL_ARR+=("$OPTIONAL_ERLANG")
  fi
else
  IFS=',' read -r -a SKILL_ARR <<< "$SKILLS"
fi

is_canonical() {
  local name="$1"
  local c
  for c in "${CANONICAL_PACK[@]}"; do
    [[ "$name" == "$c" ]] && return 0
  done
  return 1
}

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
HUB_REQUIRED=(
  evals/traces.md
  examples.md
  project-kit/AGENTS.md
  templates/proof-of-work.md
)

# skills-cli can hang forever; local prune/sync/symlink is the source of truth.
npx_try() {
  python3 - "$1" "${@:2}" <<'PY'
import os, subprocess, sys
timeout = int(sys.argv[1])
cmd = sys.argv[2:]
try:
    subprocess.run(cmd, timeout=timeout, check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except subprocess.TimeoutExpired:
    sys.stderr.write("WARN: timed out: " + " ".join(cmd) + "\n")
    sys.exit(0)
PY
}

echo "🧹 Removing v1/v2 leftover skills (planning / gsd / network / intake / graphifier / frontend / cd / security / agent-handling)..."
npx_try 45 npx --yes skills remove "${ZOMBIES[@]}" -g -y || true

# Default * must not secretly keep erlang (or any canonical skill not in this install set).
NOT_THIS_INSTALL=()
for c in "${CANONICAL_PACK[@]}"; do
  keep=false
  for s in "${SKILL_ARR[@]}"; do
    if [[ "$s" == "$c" ]]; then keep=true; break; fi
  done
  if [[ "$keep" == false ]]; then
    NOT_THIS_INSTALL+=("$c")
  fi
done
if [[ "${#NOT_THIS_INSTALL[@]}" -gt 0 ]]; then
  echo "🧹 Uninstalling canonical skills not in this default set: ${NOT_THIS_INSTALL[*]}"
  npx_try 45 npx --yes skills remove "${NOT_THIS_INSTALL[@]}" -g -y || true
  for target_dir in "${PRUNE_DIRS[@]}"; do
    [[ -d "$target_dir" ]] || continue
    for c in "${NOT_THIS_INSTALL[@]}"; do
      if [[ -e "$target_dir/$c" || -L "$target_dir/$c" ]]; then
        rm -rf "$target_dir/$c"
        echo "  - Removed $target_dir/$c (not in default *)"
      fi
    done
  done
fi

for target_dir in "${PRUNE_DIRS[@]}"; do
  [[ -d "$target_dir" ]] || continue
  for z in "${ZOMBIES[@]}"; do
    if [[ -e "$target_dir/$z" || -L "$target_dir/$z" ]]; then
      rm -rf "$target_dir/$z"
      echo "  - Removed leftover: $target_dir/$z"
    fi
  done
  for item in "$target_dir"/skidora*; do
    [[ -e "$item" || -L "$item" ]] || continue
    base="$(basename "$item")"
    if ! is_canonical "$base"; then
      rm -rf "$item"
      echo "  - Removed skill no longer in repo: $item"
    fi
  done
done

echo "⚡ Registering $(IFS=,; echo "${SKILL_ARR[*]}") via skills.sh (45s cap; local copy follows)..."
npx_try 45 npx --yes skills add "$ROOT" "${SKILL_FLAGS[@]}" "${AGENT_FLAGS[@]}" -g -y || true

echo "📦 Syncing skill source so evals / examples / kit / templates actually install..."
mkdir -p "$AGENTS_SKILLS_DIR"
for s in "${SKILL_ARR[@]}"; do
  src="$ROOT/skills/$s"
  dest="$AGENTS_SKILLS_DIR/$s"
  if [[ ! -d "$src" ]]; then
    echo "ERROR: missing skill source $src" >&2
    exit 1
  fi
  rm -rf "$dest"
  cp -R "$src" "$dest"
done

AGENT_HOMES=(
  "$HOME/.cursor/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
)

echo "🔗 Symlinking installed skills into Cursor / Claude / Codex (copy is a hard error)..."
for target_dir in "${AGENT_HOMES[@]}"; do
  parent_home="$(dirname "$target_dir")"
  [[ -d "$parent_home" ]] || continue
  mkdir -p "$target_dir"
  for s in "${SKILL_ARR[@]}"; do
    src="$AGENTS_SKILLS_DIR/$s"
    dest="$target_dir/$s"
    if [[ ! -d "$src" ]]; then
      echo "ERROR: $src missing after install; cannot symlink $dest" >&2
      exit 1
    fi
    rm -rf "$dest"
    if ! ln -sfn "$src" "$dest"; then
      echo "ERROR: symlink failed: $dest -> $src" >&2
      exit 1
    fi
    if [[ ! -L "$dest" ]]; then
      echo "ERROR: $dest is a copy, not a symlink" >&2
      exit 1
    fi
  done
  echo "  OK $target_dir"
done

fail=0

echo "🔎 Root docs must match the installed pack (one source of truth)..."
same_file() {
  if ! diff -q "$1" "$2" >/dev/null; then
    echo "ERROR: $1 != $2" >&2
    fail=1
  fi
}
same_file "$ROOT/examples.md" "$ROOT/skills/skidora/examples.md"
same_file "$ROOT/evals/traces.md" "$ROOT/skills/skidora/evals/traces.md"
same_file "$ROOT/project-kit/AGENTS.md" "$ROOT/skills/skidora/project-kit/AGENTS.md"
same_file "$ROOT/templates/proof-of-work.md" "$ROOT/skills/skidora/templates/proof-of-work.md"
same_file "$ROOT/templates/question-block.md" "$ROOT/skills/skidora/templates/question-block.md"

echo "🔎 Hub files that Boot/Trace Obedience name must exist in the installed folder..."
for f in "${HUB_REQUIRED[@]}"; do
  if [[ ! -f "$AGENTS_SKILLS_DIR/skidora/$f" ]]; then
    echo "ERROR: installed hub missing $f (would fail a turn on a missing file)" >&2
    fail=1
  fi
done

echo "🔎 Leftover v1/v2 dirs must be gone; plan.md skills must not remain..."
for target_dir in "${PRUNE_DIRS[@]}"; do
  [[ -d "$target_dir" ]] || continue
  for z in "${ZOMBIES[@]}"; do
    if [[ -e "$target_dir/$z" || -L "$target_dir/$z" ]]; then
      echo "ERROR: leftover skill still present: $target_dir/$z" >&2
      fail=1
    fi
  done
  if [[ -d "$target_dir" ]]; then
    while IFS= read -r skill_md; do
      [[ -f "$skill_md" ]] || continue
      if grep -Eiq '(^|[^.])write[[:space:]]+`?plan\.md`?' "$skill_md" && ! grep -Eiq 'never|do not|don.t|no `?plan\.md' "$skill_md"; then
        echo "ERROR: plan.md skill remains: $skill_md" >&2
        fail=1
      fi
    done < <(find "$target_dir" -maxdepth 2 -path '*skidora*' -name SKILL.md 2>/dev/null || true)
  fi
done

if [[ ! -L "$HOME/.cursor/skills/skidora" ]]; then
  echo "ERROR: ~/.cursor/skills/skidora is not a symlink" >&2
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  echo "ERROR: install did not tell the truth. Fix the pack and rerun." >&2
  exit 1
fi

echo "OK default pack: ${SKILL_ARR[*]}"
echo "OK Cursor symlink: ~/.cursor/skills/skidora -> $(readlink "$HOME/.cursor/skills/skidora")"
