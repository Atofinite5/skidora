# Erlang and Elixir (OTP)

Load this when the repo or request is BEAM: `mix.exs`, `rebar.config`, `erlang.mk`, `.ex` / `.exs` / `.erl` / `.hrl`, Phoenix, LiveView, OTP, GenServer, supervisor, Cowboy, Plug.

Do **not** rewrite the Skidora CLI in Erlang. Helix files stay on the `skidora` binary ([neovim-rust.md](neovim-rust.md)). This module is how the agent builds and verifies BEAM systems.

## Why this module exists

Skidora’s AG3 loop is an OTP loop:

| Skidora | OTP |
|---|---|
| Intake / call | `gen_server:call` — one clear message |
| Plan / spec | child spec — named process, restart, shutdown |
| Execute | worker — smallest unit that can fail loudly |
| Verify twice | probe — static (tree + router) then runtime (`mix test` / `rebar3 ct` / HTTP) |
| Bounded retry | supervisor intensity — fix the cause, restart, stop after max restarts |
| Graphifier | supervision tree + route graph |

If the request is generic HTTP and the repo is not BEAM, use [backend.md](backend.md) only.

## Detect, then stay

| Evidence | Stack |
|---|---|
| `mix.exs` | Elixir. Prefer Mix tasks already in the repo |
| `mix.exs` + `lib/**_web/router.ex` | Phoenix. NLP maps to the router |
| `**/*.heex` or LiveView modules | Frontend via LiveView, then [frontend.md](frontend.md) |
| `rebar.config` or `src/*.erl` | Erlang. Prefer `rebar3` |
| none of the above | do not introduce OTP |

Never add Phoenix/OTP to a Node/Rust/Java repo unless the user P0-asks.

## Before editing

1. Read `mix.exs` or `rebar.config` (apps, extra_applications, deps).
2. Find the supervision tree (`Application.start/2`, `Supervisor.child_spec`).
3. Find the router (`*_web/router.ex`, Cowboy dispatch, or Plug pipeline).
4. List in-scope endpoints from that router — do not invent paths.
5. Graphifier if the tree or router is torn.

## Architecture (show before presentation)

Must include:

- OTP tree: application → supervisors → workers (names, restart type)
- Router → controller/live → context → store
- Endpoints in scope (method, path, pipeline/auth, change)
- NLP map: `"<phrase>" -> <METHOD> <path> (<module>)`

Process names and route paths must exist in files you opened.

## OTP rules

- One process, one job. Do not dump business logic into the application module.
- Let it crash for unexpected faults; supervisor restarts. Do not wrap everything in `try/rescue` / `catch`.
- Expected user/input errors return tagged tuples (`{:ok, _}` / `{:error, _}`) or HTTP error bodies — not process death.
- Name processes that other code must call. Do not guess a registered name.
- Messages: typed, small, documented. No unbounded mailbox growth (no `cast` storms).
- State: hold what the process owns. Contexts/modules stay side-effect explicit.
- Supervisors: `one_for_one` unless the children must die together. Set intensity to match [cd-pipelines.md](cd-pipelines.md) (default 3).

## NLP → Phoenix / Cowboy

Same mapping as [backend.md](backend.md), with BEAM proof:

1. Intent + entity from the user phrase.
2. Match `scope` / `get` / `post` / `live` in the router, or Cowboy paths.
3. No match → P0 (new route vs reuse). Do not silently add a pipeline.
4. Log: `NLP: "<phrase>" -> <METHOD> <path> (<module.function>)`

LiveView: the "endpoint" is the `live` route plus the handle_event names you touch.

## Elixir / Phoenix implementation

- Contexts own domain. Controllers/LiveViews stay thin.
- Changesets (or the project's validator) at the boundary.
- `mix format` on touched files. `mix credo` only if the project already uses it.
- New endpoints: router + controller or LiveView + context + test. All three, or it is not done.
- Do not add Umbrella/Oban/Broadway/Nx unless the repo already has them or P0 asked.

## Erlang implementation

- `rebar3 compile` + existing test profile (`eunit` or `ct`).
- Follow the repo's include and app.src layout.
- New OTP app/release only when asked or when scaffolding a BEAM project from empty.

## Verify twice (95-plus)

Pass A (static):

- Child is in the supervisor list
- Route is in the router
- Test module exists or was added for this change

Pass B (runtime), prefer the repo's gate:

- Elixir: `mix test` (or the documented alias). Phoenix: hit the path with `mix test` request or curl against `mix phx.server` if already how this app is proven
- Erlang: `rebar3 ct` or `rebar3 eunit` as the repo uses

Second pass is a **new** run, not the first log. Coverage >= 95 only if the project reports coverage; otherwise all in-scope tests green twice.

## CD

- Local gate: `mix test` / `rebar3 do compile, ct` (or repo CI)
- Release: `mix release` / `rebar3 as prod release` only if that is the project's ship path
- Retry like a supervisor: patch the cause, rerun the same Mix/rebar command, stop after 3

## Graphifier kinds (BEAM)

Add when recognizing OTP:

- Node kinds: `otp_app`, `supervisor`, `worker`, `route`, `liveview`, `context`
- Edge kinds: `supervises`, `calls`, `routes`, `renders`, `broke`

Torn examples: missing child spec, router path without module, LiveView `handle_event` with no template, dead `GenServer.call` name.
