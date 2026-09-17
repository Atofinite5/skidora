# Recover prompt

Slug: skidora
Path: /Users/bhargavkalambhe/Desktop/skidora
Updated: 2026-09-16

## Goal
Skill + Rust CLI + Neovim + OTP/Elixir module. Users and agents use the `skidora` CLI for Helix memory.

## Decisions
- Keep SKILL.md as the orchestrator; Rust owns file I/O
- Users use the CLI (`skidora init|status|draft|recover|graph`) and Neovim commands that call it
- Same `.skidora/` contract for agent and editor
- Erlang/Elixir is an OTP module for BEAM repos, not a second CLI
- Install the skill pack to Cursor, Claude, Codex, and Agents; boot repos with AGENTS.md

## Key files
- SKILL.md — orchestrator and dispatch
- crates/skidora-core — draft, recover, graph, index
- crates/skidora-cli — `skidora` binary
- nvim/lua/skidora/init.lua — :Skidora* commands
- references/neovim-rust.md — agent module
- references/erlang-elixir.md — OTP / Phoenix / Mix / rebar
- references/when-not.md — skip vs full loop
- examples.md — three traces
- project-kit/AGENTS.md — drop into any repo

## Live endpoints
- none (skill + CLI, not an HTTP app)

## NLP map
- "recover / rewind" -> skidora recover
- "don't plan" -> hidden plan then implement
- "graph / torn" -> skidora graph / Graphifier
- "phoenix / elixir / erlang / otp" -> erlang-elixir module

## Next
User uses the CLI (`skidora status`, `skidora recover --global`) and Neovim `:Skidora*` on top of it.

## Open risks
- none
