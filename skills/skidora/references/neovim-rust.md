# Neovim and Rust

Use this when the user works in Neovim, asks for the Skidora CLI, Helix memory files on disk, or a Rust change to this repo.

Cursor still loads [`SKILL.md`](../SKILL.md). This module is the native runtime that **writes the same files**.

## Binary

From the Skidora source repo:

```bash
cargo install --path crates/skidora-cli
```

Or run without installing: `cargo run -p skidora -- <args>`.

Override skill pack location with `SKIDORA_HOME` (default `~/.cursor/skills/skidora`).

| Command | Effect |
|---|---|
| `skidora init --path <root>` | Create `.skidora/` if missing |
| `skidora status --path <root>` | Print Phase / Done / Blocked / Next |
| `skidora draft --phase execute --title "..." --intent "..." --did "..."` | Append one Helix log entry |
| `skidora recover --path <root>` | Print tiny recover prompt |
| `skidora recover --goal "..." --next "..." --global` | Rewrite recover + upsert skill `memory/` |
| `skidora graph --question "..."` | Write Graphifier skeleton |

If `skidora` is on PATH, prefer it over hand-editing `.skidora/` so Neovim and the agent stay in sync. Still **Read** the files after the command for evidence.

## Neovim

Plugin root: `nvim/` in this repo.

```lua
vim.opt.runtimepath:prepend("/Users/bhargavkalambhe/Desktop/skidora/nvim")
-- optional: vim.g.skidora_bin = "/path/to/skidora"
-- optional: vim.g.skidora_autostatus = false
```

Commands: `:SkidoraInit` `:SkidoraStatus` `:SkidoraDraft` `:SkidoraRecover` `:SkidoraGraph [question]`

On `VimEnter` / `DirChanged`, if `.skidora/draft.md` exists, show the four bars.

## Agent rules

- Do not invent a second memory format. Files stay as [helix-memory.md](helix-memory.md).
- After CLI writes, re-read `.skidora/recover.md` or `draft.md` (pass B).
- Rust changes in this repo: `cargo test` is pass A; a second `cargo test` or re-run of the same failing test after the fix is pass B.
