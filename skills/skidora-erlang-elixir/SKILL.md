---
name: skidora-erlang-elixir
description: >-
  Erlang, Elixir, OTP, Phoenix, Mix, rebar. Use on BEAM repos or OTP/Phoenix/LiveView work.
---

# Erlang and Elixir (BEAM / OTP)

Load this module **only** when the project contains BEAM artifacts: `mix.exs`, `rebar.config`, `erlang.mk`, `.ex`, `.exs`, `.erl`, `.hrl`, Phoenix, LiveView, OTP, GenServer, supervisor, Cowboy, or Plug.

Helix single-file memory stays on `.skidora/recover.md`. This module defines how the agent builds, modifies, and verifies BEAM systems under Skidora's adaptive execution policy.

## Operating Principles on BEAM

BEAM systems inherently embody Skidora's core principles:

| Skidora Principle | BEAM / OTP Implementation |
|---|---|
| **Surgical execution** | Minimal worker/handler diff; stop at lowest rung of 7-Rung Ladder. |
| **Fail loudly / Let it crash** | Let unexpected faults crash the worker; supervisor restarts. Never blanket `try/rescue`. |
| **Input errors** | User/input validation errors return tagged tuples (`{:ok, _}` / `{:error, _}`) or HTTP error responses. |
| **Bounded retry** | Supervisor max restarts / 3-retry gate. Patch root cause before rerunning tests. |
| **Torn resolution** | In-memory topology check (supervisor tree + router dispatch). Zero invented routes. |

If the request is generic HTTP and the repo is not BEAM, use `skidora-backend` instead.

## Stack Detection

| Evidence | Stack | Rule |
|---|---|---|
| `mix.exs` | Elixir | Use existing Mix tasks in repo (`mix test`, `mix compile`). |
| `mix.exs` + `lib/**_web/router.ex` | Phoenix | NLP maps to real Phoenix router (`scope`, `get`, `post`, `live`). |
| `**/*.heex` or LiveView modules | LiveView | Route + LiveView module + `handle_event`/template integration. |
| `rebar.config` or `src/*.erl` | Erlang | Use `rebar3 compile`, `rebar3 eunit`, or `rebar3 ct`. |
| None of the above | Non-BEAM | Do **not** introduce BEAM/OTP dependencies. |

Never add Phoenix/OTP to a Node/Rust/Python/Go repo unless the user explicitly requests it.

## Routing: NLP to Phoenix / Cowboy

Follow `skidora-backend` routing discipline:
1. Extract intent + entity from the user phrase.
2. Search `lib/**/*_web/router.ex` or Cowboy dispatch tables.
3. If no match exists and route is requested, treat as **Blueprint Mode** (explicit route registration required).
4. Never invent unregistered endpoints.

## Elixir / Phoenix Implementation Guidelines

- Contexts own domain logic; Controllers and LiveViews stay thin.
- Use Ecto changesets (or project's existing validator) at the boundary.
- Run `mix format` on touched files.
- New endpoints require router entry + controller/LiveView + context + test. All must be present or it is not done.
- Do not introduce heavy dependencies (Oban, Broadway, Nx) unless already present in `mix.exs`.

## Dual-Pass Proof-of-Work Verification

All structural BEAM changes require the standardized 3-line **Proof-of-Work Badge**:

- **Pass A (Static):**
  - Worker/child is registered in supervisor's child specification list.
  - Route is registered in `router.ex` or Cowboy dispatch table (`file:line`).
  - Test module exists and covers the route/worker.
- **Pass B (Runtime):**
  - Elixir: `mix test path/to/test_file.exs` -> exit code 0.
  - Erlang: `rebar3 eunit` or `rebar3 ct` -> exit code 0.
  - Live route (if server running): curl against endpoint verifying expected status code.

Produce the Proof-of-Work Badge:
```markdown
[Skidora Proof-of-Work]
- Pass A (Static): lib/my_app_web/router.ex:24 — Route registered in :api pipeline
- Pass B (Runtime): mix test test/my_app_web/controllers/webhook_controller_test.exs -> exit 0
- Regression: 24/24 tests green (0 failures)
```
