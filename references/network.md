# Network and Security Auditing

Use this skill when changing networking, HTTP client/server communication, WebSockets, CORS, authentication headers, or debugging API payloads and production traffic.

## The Jam.dev Problem & Open-Source Equivalents

Jam (jam.dev) is popular because it bundles:
- Network waterfall (fetch/XHR requests, headers, status codes, timings)
- Console errors and logs
- Device/browser metadata and visual repros

### Recommended Open-Source Alternatives:
1. **OpenReplay Spot** (`openreplay/openreplay`): Direct open-source browser extension alternative to Jam. Captures console logs, network payloads, and user actions; fully self-hostable for data privacy.
2. **Highlight.io** (`highlight/highlight`): Open-source full-stack session replay, network payload capture, and frontend/backend tracing.
3. **Crikket** (`redpangilinan/crikket`): Self-hostable bug-reporting tool with automated console & network capture.
4. **mitmproxy** (`mitmproxy/mitmproxy`): Interactive HTTPS network proxy for inspecting CLI and backend network traffic.

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
```
