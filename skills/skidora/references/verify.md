# Verify

No done without evidence. Recheck twice. Target 95-plus on the project's own checks.

## 95-plus

Use the repo's real gate: test, lint, typecheck, build, or a documented script.

- If a numeric coverage/score exists, require >= 95 on the touched area or the project's stated threshold, whichever is documented.
- If no numeric score exists, 95-plus means: all in-scope checks pass, and a second pass found no remaining in-scope failures.
- Never invent a score.

## Double-check

For every requirement in the plan:

1. Pass A — implement and run the check.
2. Pass B — independently confirm (re-read the file, re-hit the endpoint, re-run the test). Do not treat pass A logs as pass B.

For every in-scope API/endpoint:

1. Pass A — route exists in code (registration + handler).
2. Pass B — runtime proof (test or curl or project equivalent).

If A and B disagree, it is not done. Enter the retry loop in [cd-pipelines.md](cd-pipelines.md).

## No hallucination

Before stating a fact:

- File exists → Read or Glob succeeded
- Endpoint exists → found in router or live call
- Component exists → opened the source
- "Tests pass" → command output in this turn
- BEAM: [erlang-elixir.md](erlang-elixir.md) — `mix test` or `rebar3` twice, plus router/child-spec proof

If you cannot prove it, say it is unverified.

## Done bar

```
Verify: pass A <cmd/result>; pass B <cmd/result>
Score: <number or "all in-scope green">
Endpoints: <list with method path and proof>
```
