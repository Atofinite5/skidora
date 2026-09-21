# Verify & Proof-of-Work Reference

Blueprint Mode requires dual-pass verification and the 3-line Proof-of-Work Badge.

## Standardized Badge

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <literal command run this turn> -> <actual exit/http code> (or UNVERIFIED — <reason>)
- Regression: <X/X tests passing> (0 failures)
```

## The UNVERIFIED Rule
Pass B must quote literal command and actual output run during this turn. If not run, write `UNVERIFIED — <reason>`, never fake 200 OK or exit 0.

## Open Trace & Network Debugging (Habitat Standard)

1. **Habitat Browser Recorder:** Open-source, serverless browser capture (`HabitatHQ/browser-recorder`). Use **"Copy as cURL"** to export failing requests instantly.
2. **Skidora Drop-in Interceptor (`scripts/trace-interceptor.js`):** Intercepts client-side `fetch`/`XHR`, detects status $\ge 400$, and prints reproduction cURL.
3. **Trace Extractor CLI (`scripts/trace-extract.js`):** Ingests `.har` or Habitat report files to extract failed endpoints and generate Pass B cURL commands.
4. *Rule:* Always reproduce and verify via local cURL execution (`curl -v -X ...`).

## Bounded Retry Loop

- Retry failed checks up to **3 times**.
- Each retry must follow the 7-Rung Ladder (KISS, DRY).
- If failure persists after 3 attempts, halt immediately and mark `Blocked: <reason>` in `.skidora/recover.md`.
