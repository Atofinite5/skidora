---
name: skidora-network
description: >-
  Network debugging, API traffic inspection, CORS, timeouts, and production security. Open-source Jam alternatives (OpenReplay Spot, Highlight.io). Use when handling network requests, HTTP clients, WebSockets, or fixing production API connectivity.
---

# Network & Production Security

Prevent production outages, CORS errors, unhandled network timeouts, and leaked credentials.

## Jam.dev Open-Source Alternatives

When debugging network bugs, console errors, and session repros, leverage open-source tooling:

- **OpenReplay Spot** (`openreplay/openreplay`): Open-source browser extension capturing network requests, console errors, and DOM replays with self-hosted privacy.
- **Highlight.io** (`highlight/highlight`): Full-stack open-source session replay and network payload inspection.
- **Crikket** (`redpangilinan/crikket`): Self-hostable bug-reporting platform capturing network calls and console logs.
- **mitmproxy** (`mitmproxy/mitmproxy`): Headless command-line HTTPS inspection for backend API calls.

## Hard Rules for Network Operations

### 1. No Credentials in URLs
- Never place API keys, access tokens, or secrets in URL query parameters (`?api_key=...`).
- Pass credentials exclusively via headers (`Authorization: Bearer ...`).
- Sanitize and redact tokens before recording network traces in logs or `.skidora/draft.md`.

### 2. CORS & Origin Protection
- Never combine `Access-Control-Allow-Origin: *` with `Access-Control-Allow-Credentials: true`.
- Whitelist specific allowed origins for credentialed requests.
- Explicitly define allowed methods and headers.

### 3. Timeout & Resilience Standards
- Every HTTP client call (`fetch`, `axios`, `reqwest`, `httpoison`) must define an explicit timeout (recommended: 5000ms–10000ms).
- Gracefully handle 429 (rate-limiting with exponential backoff) and network dropouts.
- Guard against SSRF: validate user-provided URLs against private IP ranges (`127.0.0.1`, `10.0.0.0/8`, `169.254.169.254`).

## Network Verification Badge

Before reporting a networking task done, provide the verified network badge:

```markdown
[Skidora Network Proof]
- Endpoint: <METHOD> <URL>
- Status: <HTTP Status Code>
- Headers: Content-Type, Authorization, CORS verified
- Latency: <ms> (timeout: <ms>)
- Payload: Validated against schema
```
