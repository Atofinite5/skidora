<div align="center">

<img src="./assets/banner.png" alt="Skidora — Zero-Slop Operating System for AI Coding Agents" width="100%" />

# Skidora 🧬

**The Zero-Slop Operating System & Memory Engine for AI Coding Agents.**  
*Eliminate agent hallucination, context amnesia, and fake API completions across any IDE and model.*

[![skills.sh compatible](https://img.shields.io/badge/skills.sh-compatible-00d2ff.svg?style=flat-square)](https://skills.sh)
[![Agents Supported](https://img.shields.io/badge/agents-Cursor%20%7C%20Claude%20%7C%20Antigravity%20%7C%20Zed%20%7C%20Copilot-7928CA.svg?style=flat-square)](#supported-agents)
[![Tests](https://img.shields.io/badge/tests-passing-10B981.svg?style=flat-square)](#verification)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)

[Quickstart](#quickstart) • [The Crisis We Solve](#the-crisis-we-solve) • [AG3 Loop](#the-ag3-execution-loop) • [Skills Matrix](#skills-matrix) • [OpenReplay Spot & Security](#network--production-security-openreplay-spot-standard) • [Helix Memory](#helix-memory-contract) • [Neovim & Rust](#neovim--rust-engine)

</div>

---

## ⚡ The Crisis We Solve

AI coding assistants are brilliant at writing syntax, but catastrophic at maintaining real-world engineering discipline:

| The Agent Slop Problem | What Actually Happens | How Skidora Fixes It |
|---|---|---|
| **Context Amnesia** | Agent resets every chat turn; forgets architecture and previously made decisions. | **Helix Memory Engine:** Auto-loads `.skidora/recover.md` at session start and commits running progress to `.skidora/draft.md`. |
| **Fake Completion** | Agent writes `// TODO: connect db` or returns hardcoded mock objects and says *"Done!"* | **Two-Pass Proof-of-Work:** Pass A checks code AST/routes; Pass B requires real shell/curl execution proof. No proof = not done. |
| **Hallucinated Endpoints** | Agent invents convenient API paths (`/api/v1/update-profile`) that don't exist in the router. | **NLP-to-Endpoint Mapping:** Strictly enforces route extraction against real code files before touching any handler. |
| **Networking & CORS Crashes** | Agents deploy endpoints with broken CORS, missing timeouts, or leaked auth tokens in query params. | **Network & Security Auditing:** Enforces timeout resilience, origin whitelisting, no credentials in URLs, and standardized OpenReplay Spot traces. |
| **Silent Regression** | Fixes one function while breaking three others without running existing test suites. | **Bounded Retry CD Loop:** Runs test gates repeatedly; mandates a **95+ quality score** before reporting complete. |
| **Context Bloat & Lag** | 5,000-line skill prompts cause slow agent responses and severe attention dilution. | **When-Not Gate:** Skips overhead on trivial one-liners; loads strictly one specialized module per turn. |

---

## 🚀 Quickstart

Install the complete Skidora pack into all your coding agents globally with one command:

```bash
npx skills add Atofinite5/skidora --skill '*' -g -y
```

### Pick Specific Modules

```bash
npx skills add Atofinite5/skidora \
  -s skidora,skidora-helix,skidora-frontend,skidora-backend,skidora-network,skidora-verify \
  -g \
  -a cursor -a claude-code -a antigravity -a zed -a github-copilot \
  -y
```

### Inspect the Pack

```bash
npx skills add Atofinite5/skidora --list
```

> **Flags:**  
> • `-g` Installs globally across all your projects.  
> • `-a` Explicitly selects agents (`cursor`, `claude-code`, `antigravity`, `zed`, `github-copilot`, `codex`, `windsurf`).  
> • `-s` Selects individual modular skills.  
> • `-y` Auto-confirms prompts.

---

## 🔄 The AG3 Execution Loop

Every agent equipped with Skidora adheres to the **AG3 (Analyze, Gate, Generate, Guarantee)** operating pipeline:

```mermaid
flowchart TD
  user["User Command"] --> isSmall{"Small Task? (Typo / One-Liner)"}
  
  isSmall -->|Yes| fastTrack["Fast Track: Single-pass proof, no ceremony"]
  isSmall -->|No (Full Work)| helixLoad["1. Helix Load (.skidora/recover.md)"]
  
  helixLoad --> intake["2. Intake: Ask missing P0/P1 questions in standard block"]
  intake --> recognized{"Topic recognized & code intact?"}
  
  recognized -->|No or Code Torn| graphifier["Graphifier: Build node/edge topology cache"]
  graphifier --> planGate
  recognized -->|Yes| planGate{"User said 'Don't Plan'?"}
  
  planGate -->|Yes| hiddenPlan["3. Write internal plan to .skidora/plan.md (Do not display)"]
  planGate -->|No| showPlan["3. Present Plan + Architecture Blueprint + Demanded Artifacts"]
  
  hiddenPlan --> execute["4. Precise Implementation (Real APIs & Networks only)"]
  showPlan --> execute
  
  execute --> verifyPass{"5. Double-Check: Pass A (AST) + Pass B (Runtime curl/network test)"}
  verifyPass -->|Failed / Score < 95| retryLoop["Bounded Retry Loop (Auto-remediate)"]
  retryLoop --> execute
  verifyPass -->|Passed 95+| helixSave["6. Helix Save: Append draft.md & update recover.md"]
```

---

## 🧩 Skills Matrix (15 Specialized Modules)

Skidora is modular. Use the orchestrator for full automation, or install individual modules via `-s <name>`:

| Skill | Module Directory | Core Capability |
|---|---|---|
| **`skidora`** | [`skills/skidora`](./skills/skidora) | **The Orchestrator:** AG3 master loop, architecture gates, and multi-skill dispatch. |
| **`skidora-helix`** | [`skills/skidora-helix`](./skills/skidora-helix) | **Memory & Rewind:** Read/write `.skidora/recover.md` and chronological `.skidora/draft.md`. |
| **`skidora-when-not`** | [`skills/skidora-when-not`](./skills/skidora-when-not) | **Zero Overhead:** Skips ceremony for typos and simple lookups to keep execution fast. |
| **`skidora-intake`** | [`skills/skidora-intake`](./skills/skidora-intake) | **Structured Discovery:** Standardized P0 (blockers), P1 (quality), P2 (optional) question block. |
| **`skidora-planning`** | [`skills/skidora-planning`](./skills/skidora-planning) | **Architecture First:** Layout & data-flow before demo; internal hidden plan if requested. |
| **`skidora-gsd`** | [`skills/skidora-gsd`](./skills/skidora-gsd) | **Execution Bars:** Live project status (`Phase`, `Done`, `Blocked`, `Next`) and on-demand tools. |
| **`skidora-frontend`** | [`skills/skidora-frontend`](./skills/skidora-frontend) | **UI Standards:** Design tokens, layout hierarchy, and component composition rules. |
| **`skidora-backend`** | [`skills/skidora-backend`](./skills/skidora-backend) | **API Discipline:** Natural-language to real router mapping; strictly no invented endpoints. |
| **`skidora-network`** | [`skills/skidora-network`](./skills/skidora-network) | **Network & Security:** CORS, timeouts, OpenReplay Spot standard (open-source Jam alternative), and leak prevention. |
| **`skidora-erlang-elixir`** | [`skills/skidora-erlang-elixir`](./skills/skidora-erlang-elixir) | **BEAM/OTP:** Phoenix, LiveView, Mix/Rebar3 concurrency, and supervisor patterns. |
| **`skidora-cd`** | [`skills/skidora-cd`](./skills/skidora-cd) | **Continuous Delivery:** Automated retry loops that persist until tests turn green. |
| **`skidora-graphifier`** | [`skills/skidora-graphifier`](./skills/skidora-graphifier) | **Topic Topology:** Reconstructs node and edge graphs when code is torn or context is ambiguous. |
| **`skidora-verify`** | [`skills/skidora-verify`](./skills/skidora-verify) | **Proof-of-Work:** Dual-pass verification targeting a 95+ score on repository test suites. |
| **`skidora-security`** | [`skills/skidora-security`](./skills/skidora-security) | **Safety First:** Zero credentials in memory files; explicit user authorization for destructive ops. |
| **`skidora-agent-handling`** | [`skills/skidora-agent-handling`](./skills/skidora-agent-handling) | **Agent Persona:** Factual, concise, and professional tone with zero AI fluff or apologetic chatter. |

---

## 🌐 Network & Production Security (OpenReplay Spot Standard)

When debugging network failures, console errors, or bug reports, Skidora standardizes on **OpenReplay Spot** as the definitive open-source alternative to Jam.dev:

### Why OpenReplay Spot ⭐
* **1:1 Open-Source Jam Alternative:** Direct Chrome extension that captures console logs, complete network request/response waterfalls, and user DOM interactions in one click.
* **100% Self-Hostable:** Zero third-party cloud data leakage; protects proprietary company APIs, tokens, and sensitive client information.
* **Native Agent Ingestion:** Skidora agents (Gemini, Claude, Cursor, Antigravity) ingest Spot network traces to map failing endpoints directly to the router and handlers without hallucination.

### Production Network Hardening Rules
1. **Zero Credentials in Query Params:** Never pass API keys or bearer tokens in URLs (`/api?token=...`). Always use headers (`Authorization: Bearer <token>`).
2. **Strict CORS Policy:** Whitelist specific origins. Never combine wildcard `*` with `credentials: true`.
3. **Mandatory Timeouts:** Every network request must have an explicit timeout (5s–10s) and exponential backoff retry.
4. **SSRF Defense:** Sanitize and whitelist all user-provided URLs against internal RFC 1918 subnets (`127.0.0.1`, `10.0.0.0/8`, `169.254.169.254`).

---

## 💾 Helix Memory Contract

Skidora eliminates context loss by maintaining persistent state directly within your project workspace inside `.skidora/`:

```
your-project/
├── .skidora/
│   ├── recover.md       # Tiny compressed prompt restoring full project state instantly
│   ├── draft.md         # Chronological Helix work log with evidence and phase bars
│   ├── plan.md          # Active technical specifications and architecture blueprint
│   └── graph.md         # Node/edge dependency topology of recent modifications
```

### The 4 Project Status Bars
Every Skidora execution updates and preserves these live status bars:
```markdown
- Phase: intake | plan | execute | verify | ship
- Done: <concrete items delivered with proof>
- Blocked: <unanswered P0 questions or external blockers>
- Next: <immediate next technical action>
```

---

## 🦀 Neovim & Rust Engine (Optional)

Skidora's memory contract uses standard Markdown so any AI agent can read and write it natively with zero binary dependencies.

For terminal power users who want editor-native memory manipulation, Skidora includes a high-performance **Rust CLI** and **Neovim Lua plugin**:

```bash
# Build the native CLI
cargo build --release

# Run CLI commands directly
./target/release/skidora status
./target/release/skidora draft --phase execute --title "Add Stripe webhook"
./target/release/skidora recover --global
```

In Neovim:
```vim
:SkidoraStatus    " View project bars in a floating window
:SkidoraDraft     " Append log entry with execution proof
:SkidoraRecover   " Inspect the compressed recovery prompt
:SkidoraGraph     " View topological node map
```

---

## 🛡️ The Zero-Slop Guarantee

Before your agent claims an API or feature is "finished", Skidora forces it to provide this standardized **Proof-of-Work Badge**:

```markdown
[Skidora Proof-of-Work]
- Route: POST /api/v1/billing/webhook (verified in app/api/billing/route.ts:42)
- Pass A (Static): Route registered in router with Zod schema validation.
- Pass B (Runtime): curl -X POST http://localhost:3000/api/v1/billing/webhook -> 200 OK
- Regression: 14/14 tests green (0 failures)
```

No more broken builds. No more fake mocks. No more surprises in production.

---

## 🤝 Contributing & Community

Skidora is open-source under the [MIT License](LICENSE). Contributions, bug reports, and new language/framework modules are welcome!

1. Fork the repo: [`Atofinite5/skidora`](https://github.com/Atofinite5/skidora)
2. Create your feature branch: `git checkout -b feature/awesome-skill`
3. Commit your changes: `git commit -m "feat: add awesome skill"`
4. Push to the branch: `git push origin feature/awesome-skill`
5. Open a Pull Request against `develop`.

---

<div align="center">
Made with ⚡ by <a href="https://github.com/Atofinite5">Atofinite5</a> for developers who demand real results from AI.
</div>
