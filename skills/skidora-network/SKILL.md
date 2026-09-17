---
name: skidora-network
description: >-
  Network debugging, API traffic inspection, CORS, timeouts, and production security. Standardized on OpenReplay Spot (open-source Jam alternative). Use when handling network requests, HTTP clients, WebSockets, or fixing production API connectivity.
---

# Network & Production Security

Prevent production outages, CORS errors, unhandled network timeouts, and leaked credentials.

## Official Standard: OpenReplay Spot ⭐

**OpenReplay Spot** (`openreplay/openreplay`) is the official open-source standard for Skidora bug reporting and network diagnosis:

- **1:1 Open-Source Jam Alternative:** Captures console logs, full network request/response waterfalls, and user DOM interactions in a single click.
- **Self-Hosted Privacy:** Zero third-party data leakage; keeps confidential company APIs and tokens completely safe.
- **Agent Diagnosis Workflow:** When provided with an OpenReplay Spot trace or network HAR:
  1. Extract failing HTTP method, URL, and status code (4xx/5xx).
  2. Map route directly to the codebase router and controller.
  3. Formulate the fix and run dual verification.
  4. Redact credentials so tokens never leak into memory or commits.

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
- Trace Source: OpenReplay Spot / local runtime proof
```
