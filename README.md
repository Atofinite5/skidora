# Skidora

Agent skills for any project developer. Same format as [skills.sh](https://skills.sh): each folder under `skills/` has a `SKILL.md`. No CLI required. Helix memory is `.skidora/*.md`.

## Install (like wshobson)

From GitHub (Universal):

```bash
npx skills add Atofinite5/skidora \
  -s skidora,skidora-helix,skidora-when-not,skidora-intake,skidora-planning,skidora-gsd,skidora-frontend,skidora-backend,skidora-erlang-elixir,skidora-cd,skidora-graphifier,skidora-verify,skidora-security,skidora-agent-handling \
  -g \
  -a cursor -a claude-code -a antigravity -a zed -a github-copilot -a codex \
  -y
```

Install everything in the pack at once:

```bash
npx skills add Atofinite5/skidora --skill '*' -g -y
```

From this folder (local):

```bash
npx skills add /Users/bhargavkalambhe/Desktop/skidora \
  -s skidora,skidora-helix,skidora-when-not,skidora-intake,skidora-planning,skidora-gsd,skidora-frontend,skidora-backend,skidora-erlang-elixir,skidora-cd,skidora-graphifier,skidora-verify,skidora-security,skidora-agent-handling \
  -g \
  -a cursor -a claude-code -a antigravity -a zed -a github-copilot -a codex \
  -y
```

List what this pack contains:

```bash
npx skills add Atofinite5/skidora --list
```

`-g` = all your projects (global). Omit `-g` to install into the current repo only. `-a` picks agents (`cursor`, `claude-code`, `antigravity`, `zed`, `github-copilot`, `codex`, `windsurf`, …). `-s` picks skills. `-y` skips prompts.

## Skills (`-s`)

| `-s` | When |
|---|---|
| `skidora` | Full orchestrator (includes references + templates) |
| `skidora-helix` | Recover / rewind / draft log |
| `skidora-when-not` | Skip small tasks |
| `skidora-intake` | P0/P1/P2 questions |
| `skidora-planning` | Shown or hidden plan |
| `skidora-gsd` | Phases and bars |
| `skidora-frontend` | UI / LiveView |
| `skidora-backend` | APIs / NLP → endpoints |
| `skidora-erlang-elixir` | OTP / Phoenix / Mix / rebar |
| `skidora-cd` | Retry until green |
| `skidora-graphifier` | Nodes, edges, torn code |
| `skidora-verify` | Double-check, 95-plus |
| `skidora-security` | Secrets, no fake APIs |
| `skidora-agent-handling` | Voice and bars |

## Recover index

```
skidora | /Users/bhargavkalambhe/Desktop/skidora | Skill + Rust CLI + Neovim + OTP/Elixir module | 2026-09-16 |
```

## Layout

```
skills/<name>/SKILL.md
```

That is what `npx skills add` discovers.
