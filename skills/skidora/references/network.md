# Network and Security Auditing

Use this skill when changing networking, HTTP client/server communication, WebSockets, CORS, authentication headers, or debugging API payloads and production traffic.

## Official Standard: OpenReplay Spot ⭐

**OpenReplay Spot** (`openreplay/openreplay`) is the official open-source standard for Skidora.

### Why OpenReplay Spot Over Jam.dev?
- **100% Open Source & Self-Hostable:** Eliminates the privacy and compliance hazards of sending sensitive enterprise API payloads to third-party proprietary SaaS.
- **Direct 1:1 Parity:** Captures full network waterfall (fetch/XHR requests, request/response bodies, response codes, latency), console logs, and user DOM interactions in a single click.
- **Agent Diagnosis Ready:** Produces clean, structured traces that agents (Gemini, Claude, Cursor, Antigravity) can ingest directly to pinpoint failures without guessing.

### How Skidora Agents Ingest OpenReplay Spot Traces
When a developer provides an OpenReplay Spot link, trace, or network HAR:
1. **Network Extraction:** Extract the failing request method, target URL, HTTP status code (e.g. 401, 403, 422, 500), and response payload.
2. **Console Correlation:** Match network errors with the corresponding frontend console logs and stack traces.
3. **Router Mapping:** Correlate the failing endpoint directly to the local backend router file (e.g. `routes/api.ts`, Phoenix router, Express handler).
4. **Targeted Remediation:** Fix the underlying issue (schema mismatch, missing header, CORS policy, timeout) without guessing.
5. **Redaction Check:** Verify that no authorization tokens, session cookies, or PII from the trace enter memory or git history.

---

## Hard Rules for Networking & Production Security

Agents frequently cause production outages by guessing network behavior. Follow these strict rules:

### 1. Zero Secret Leaks in Network Traffic
- Never put API keys, bearer tokens, or sensitive credentials in **URL query parameters** (they leak into access logs, proxies, and browser histories).
- Always pass credentials in headers (`Authorization: Bearer <token>`).
- Redact secrets before logging network payloads in `.skidora/draft.md` or application logs.

### 2. CORS & Origin Hardening
- Never set `Access-Control-Allow-Origin: *` together with `Access-Control-Allow-Credentials: true` in production endpoints.
- Always validate incoming `Origin` against a strict whitelist of allowed domains.
- Explicitly configure allowed headers (`Content-Type`, `Authorization`) and methods (`GET, POST, PUT, DELETE, OPTIONS`).

### 3. Network Resilience & Timeout Defense
- Every outbound HTTP/RPC request (`fetch`, `axios`, `reqwest`, `httpoison`) must have an **explicit timeout** (default: 5000ms–10000ms). Never leave network calls unbounded.
- Always handle network failure states: DNS failure, connection reset, 429 Too Many Requests (implement exponential backoff), and 5xx server errors.

### 4. Payload & Content-Type Discipline
- Explicitly specify `Content-Type: application/json` or `multipart/form-data` on POST/PUT requests.
- Validate incoming and outgoing network payloads with schema validators (Zod, TypeBox, Pydantic, Ecto changeset).
- Guard against Server-Side Request Forgery (SSRF) by validating and whitelisting any user-supplied URLs before making outbound server requests.

---

## Network Proof Badge

Before marking any networking or API feature complete, verify runtime connectivity:

```markdown
[Skidora Network Proof]
- Endpoint: <METHOD> <URL>
- Status: <HTTP Status Code>
- Headers Verified: Content-Type, Authorization, CORS
- Latency & Timeout: <ms> (timeout configured: <ms>)
- Payload Schema: Validated against <SchemaName>
- Bug Trace: Verified against OpenReplay Spot / runtime log
```
