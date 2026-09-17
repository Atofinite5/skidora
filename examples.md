# Examples

Copy these traces. Do not invent a fourth ritual.

## 1. Small: one-line fix (skip full loop)

User: `typo in README title`

Agent:

1. Skip gate: small. No plan shown. No Graphifier.
2. If `.skidora/` exists, read recover (do not init).
3. Fix the typo. Prove with a Read of the line.
4. Bars optional. No architecture.

## 2. Shown plan: new endpoint

User: `add POST /widgets that creates a widget`

Agent:

1. Helix load (`skidora status` or `.skidora/recover.md`).
2. P0 only if the router/stack is unknown after the repo read.
3. Show plan + architecture (router → handler → store) + artifact list.
4. Read only [backend.md](references/backend.md) (and [erlang-elixir.md](references/erlang-elixir.md) if `mix.exs` / `rebar.config`).
5. Implement the real route. Pass A: route in code. Pass B: test or curl.
6. `skidora draft` + `skidora recover` (or write the same files).

## 3. Hidden plan + recover

User: `don't plan, continue yesterday's auth work`

Agent:

1. Helix load. If recover says next = auth middleware, continue that — do not start over.
2. Write `.skidora/plan.md`. Do not paste it.
3. Implement. Verify twice.
4. Before any "here's the API" moment, show architecture.
5. Update recover prompt (tiny). Bars: Phase / Done / Blocked / Next.
