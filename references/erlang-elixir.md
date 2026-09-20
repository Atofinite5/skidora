# Erlang and Elixir (BEAM / OTP) Reference

Guidelines for building and verifying BEAM/OTP systems under Skidora's adaptive execution policy.

## Operating Principles on BEAM

| Skidora Principle | BEAM / OTP Implementation |
|---|---|
| **Surgical execution** | Minimal worker/handler diff; stop at lowest rung of 7-Rung Ladder. |
| **Fail loudly / Let it crash** | Let unexpected faults crash the worker; supervisor restarts. Never blanket `try/rescue`. |
| **Input errors** | User/input validation errors return tagged tuples (`{:ok, _}` / `{:error, _}`) or HTTP error responses. |
| **Bounded retry** | Supervisor max restarts / 3-retry gate. Patch root cause before rerunning tests. |
| **Torn resolution** | In-memory topology check (supervisor tree + router dispatch). Zero invented routes. |

---

## Stack Detection

| Evidence | Stack | Rule |
|---|---|---|
| `mix.exs` | Elixir | Use existing Mix tasks in repo (`mix test`, `mix compile`). |
| `mix.exs` + `lib/**_web/router.ex` | Phoenix | NLP maps to real Phoenix router (`scope`, `get`, `post`, `live`). |
| `**/*.heex` or LiveView modules | LiveView | Route + LiveView module + `handle_event`/template integration. |
| `rebar.config` or `src/*.erl` | Erlang | Use `rebar3 compile`, `rebar3 eunit`, or `rebar3 ct`. |
| None of the above | Non-BEAM | Do **not** introduce BEAM/OTP dependencies. |

---

## Routing & Torn Resolution

1. Extract intent + entity from the user phrase.
2. Search `lib/**/*_web/router.ex` or Cowboy dispatch tables.
3. In-memory check: verify that controller/LiveView module exists and matches route action.
4. If torn or missing, register route explicitly under Blueprint Mode.

---

## Dual-Pass Verification

Produce the 3-line Proof-of-Work Badge:
```markdown
[Skidora Proof-of-Work]
- Pass A (Static): lib/my_app_web/router.ex:24 — Route registered in :api pipeline
- Pass B (Runtime): mix test test/my_app_web/controllers/webhook_controller_test.exs -> exit 0
- Regression: 24/24 tests green (0 failures)
```
