# CD and retry loops

Keep work running until the instruction is actually done, not until a first attempt.

## When to use

- Pipelines, deploy, watch, "keep going", failed instructions, project not yet created
- Verify loops after FE/BE changes
- Continuous agent checks until endpoints are green

## Bounded retry

Default: up to 3 retries per failing check, then one P0 to the user if still red.

Each retry must change something (fix the cause). Do not repeat the same failing command as "progress".

```
attempt -> evidence -> if fail, patch -> re-run the same check
```

Log every attempt in `.skidora/draft.md` with the evidence line.

## Pipelines

1. Prefer the repo's existing CI/scripts (`package.json`, `Makefile`, `mix.exs`, `rebar.config`, GitHub Actions).
2. Run the same commands locally that CD would run, when that is possible.
3. If a pipeline must stay up, use the Cursor loop skill if available (`/loop`) rather than a silent infinite shell.
4. Stop the loop when green, when the user says stop, or when a P0 blocker is reached.

## Project not made

If the workspace is empty or the app does not exist yet:

1. Intake P0 (stack, app type) unless Helix already has it.
2. Hidden or shown plan.
3. Scaffold, then verify the first endpoint or first page.
4. Retry until the scaffold actually runs.

## Continuous checks

Until ship:

- Typecheck/lint/test of the touched area
- Endpoint checks from [backend.md](backend.md)
- FE flow check from [frontend.md](frontend.md)
- BEAM: [erlang-elixir.md](erlang-elixir.md) (`mix test` / `rebar3` as the repo uses)

Do not claim ship while any in-scope check is red.
