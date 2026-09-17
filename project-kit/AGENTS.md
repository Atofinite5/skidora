# AGENTS

This project uses **Skidora** (markdown Helix files in `.skidora/`). No CLI required.

## Every session

1. If `.skidora/recover.md` exists, read it first. Continue from **Next**. If the task is full work and `.skidora/` is missing, create it from the Skidora templates.
2. If the task is small (typo, one-line, "where is X?"), skip plan and architecture. See skill `skidora-when-not`.
3. Otherwise follow Skidora AG3: intake → plan (hide if the user said don't plan) → architecture before presentation → implement → verify twice.
4. Before you stop: append `.skidora/draft.md` and rewrite `.skidora/recover.md`.

Skill pack: `SKILL.md` in the installed `skidora` skill, or this repo's copy if vendored.

Do not invent files, routes, or APIs. One module per turn. No secrets in `.skidora/`.
