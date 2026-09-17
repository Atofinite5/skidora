# Neovim & Rust Reference

The Rust CLI and Neovim plugin provide local manipulation of Helix memory files (`.skidora/recover.md`).

## Neovim Setup

```lua
vim.opt.runtimepath:prepend("/path/to/skidora/nvim")
```

Commands: `:SkidoraInit`, `:SkidoraStatus`, `:SkidoraRecover`.

On `VimEnter` / `DirChanged`, if `.skidora/recover.md` exists, status is displayed.

## Agent Rules

- Do not invent a second memory format. Single-file memory lives in `.skidora/recover.md`.
- After CLI writes, re-read `.skidora/recover.md` (pass B).
- Rust changes in this repo: `cargo test` is pass A; a second `cargo test` after the fix is pass B.
