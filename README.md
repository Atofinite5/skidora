<div align="center">

<img src="./assets/banner.png" alt="Skidora — Zero-Slop Operating System for AI Coding Agents" width="100%" />

# Skidora 🧬

**The Zero-Slop Operating System & Memory Engine for AI Coding Agents.**  
*Eliminate agent hallucination, context amnesia, and ceremony suffocation across any IDE and model.*

[![skills.sh compatible](https://img.shields.io/badge/skills.sh-compatible-00d2ff.svg?style=flat-square)](https://skills.sh)
[![Agents Supported](https://img.shields.io/badge/agents-Cursor%20%7C%20Claude%20%7C%20Antigravity%20%7C%20Zed%20%7C%20Copilot-7928CA.svg?style=flat-square)](#supported-agents)
[![Tests](https://img.shields.io/badge/tests-passing-10B981.svg?style=flat-square)](#verification)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)

[Quickstart](#quickstart) • [The Crisis We Solve](#the-crisis-we-solve) • [Adaptive Principles (KISS, DRY, SOLID)](#-adaptive-engine-the-7-rung-ladder--core-principles) • [AG3 Loop](#-the-adaptive-ag3-loop) • [Skills Matrix](#-skills-matrix-15-specialized-modules) • [OpenReplay Spot & Network](#-network--production-security-openreplay-spot-standard) • [Helix Memory](#-helix-single-file-memory-contract)

</div>

---

## ⚡ The Crisis We Solve

AI coding assistants are brilliant at syntax, but catastrophic at engineering discipline and developer wellness:

| The Agent Slop Problem | What Actually Happens | How Skidora Fixes It |
|---|---|---|
| **Ceremony Suffocation** | Agent writes 5 markdown files (`plan.md`, `architecture.md`, `artifact-index.md`) and a 400-word essay for a 1-line date fix. | **Adaptive Surgical Execution:** Default to the **Ponytail 7-Rung Ladder**. Shortest working diff, ≤3 lines response, zero paperwork. |
| **Context Amnesia** | Agent resets every chat turn; forgets past architecture decisions and repeats previous bugs. | **Single-File Helix Memory:** Silent, background persistence in `.skidora/recover.md`. Zero file bloat. |
| **Fake Completion** | Agent writes `// TODO: connect db` or returns hardcoded mock objects and says *"Done!"* | **Two-Pass Proof-of-Work:** Pass A checks code AST/routes; Pass B requires real shell/curl execution proof. No proof = not done. |
| **Hallucinated Endpoints** | Agent invents convenient API paths (`/api/v1/update-profile`) that don't exist in the router. | **NLP-to-Endpoint Mapping:** Strictly enforces route extraction against real code files before touching any handler. |
| **Networking & CORS Crashes** | Agents deploy endpoints with broken CORS, missing timeouts, or leaked auth tokens in query params. | **Network & Security Auditing:** Standardizes on **OpenReplay Spot ⭐** traces, strict CORS whitelists, and mandatory timeouts. |
| **Code Bloat & Reinvented Wheels** | Agents install new libraries for things that take 2 lines of standard library code. | **YAGNI, KISS & DRY Enforcement:** Reuses existing utilities and stdlib; halts at the lowest rung that holds. |

---

## 📐 Adaptive Engine: The 7-Rung Ladder & Core Principles

Skidora bakes timeless software engineering principles directly into agent prompts:

### The Engineering Creed
1. **YAGNI (You Aren't Gonna Need It):** Never generate speculative abstractions or unrequested documentation files.
2. **KISS ("Do It Simple"):** The shortest working diff that solves the root cause wins. Avoid over-engineering.
3. **DRY ("Do It Once"):** Reuse existing codebase helpers and standard libraries. In memory, maintain **one single `.skidora/recover.md`** ledger instead of duplicating state across multiple files.
4. **SOLID Design Principles:**
   - **Single Responsibility (S):** Each change and function does one thing cleanly.
   - **Open/Closed (O):** Extend capabilities without mutating stable contracts.
   - **Liskov Substitution (L):** New implementations remain 100% drop-in compatible.
   - **Interface Segregation (I):** No developer is forced to endure paperwork ceremonies for daily bug fixes.
   - **Dependency Inversion (D):** Business logic depends on routers and abstractions, not fragile hardcoded bindings.

### The 7-Rung Ladder of Laziness (Default Daily Driver)
Before generating any new code, the agent steps down the ladder and **stops at the first rung that holds**:
1. **Rung 1 — YAGNI:** Does this need to exist? If speculative, skip it.
2. **Rung 2 — Already in codebase?** Reuse existing helpers, types, or utilities (DRY).
3. **Rung 3 — Standard library does it?** Use built-in language primitives.
4. **Rung 4 — Native platform covers it?** Use HTML5, native CSS, or SQL database constraints.
5. **Rung 5 — Existing dependency solves it?** Check `package.json`, `Cargo.toml`, or `mix.exs`.
6. **Rung 6 — Can it be a clean one-liner?** If it can be expressed clearly in one line, do so (KISS).
7. **Rung 7 — Minimum viable code:** Write the absolute minimum safe code that fixes the root cause.

---

## 🚀 Quickstart

Install the complete Skidora pack into all your coding agents globally with one command:

```bash
npx skills add Atofinite5/skidora --skill '*' -g -y
```

### Pick Specific Modules

```bash
npx skills add Atofinite5/skidora \
  -s skidora,skidora-when-not,skidora-helix,skidora-frontend,skidora-backend,skidora-network,skidora-verify \
  -g \
  -a cursor -a claude-code -a antigravity -a zed -a github-copilot \
  -y
```

### Inspect the Pack

```bash
npx skills add Atofinite5/skidora --list
```

---

## 🔄 The Adaptive AG3 Loop

Skidora automatically routes between **Surgical Mode** (90% of daily work) and **Blueprint Mode** (10% structural work):

```mermaid
flowchart TD
  user["User Command"] --> isStructural{"Is it Public API Change, DB Migration, or /plan?"}
  
  isStructural -->|No (90% Daily Work)| surgical["⚡ SURGICAL MODE (Ponytail 7-Rung Ladder)
- YAGNI, KISS ('Do it simple'), DRY ('Do it once')
- Shortest working diff wins
- Max 3 lines of summary explanation
- Silent 1-line append to .skidora/recover.md"]
  
  isStructural -->|Yes (10% Structural)| blueprint["🛡️ BLUEPRINT MODE (Skidora Deep)
- 1. Load Helix recover.md
- 2. Intake: Ask missing P0 blockers
- 3. Architecture Blueprint before presentation
- 4. NLP-to-Endpoint mapping (real routers only)
- 5. Dual-Pass Verification (Pass A AST + Pass B Runtime curl)
- 6. Append verified milestone to recover.md"]
```

---

## 🧩 Skills Matrix (15 Specialized Modules)

Skidora is modular. Use the orchestrator for full automation, or install individual modules via `-s <name>`:

| Skill | Module Directory | Core Capability |
|---|---|---|
| **`skidora`** | [`skills/skidora`](./skills/skidora) | **The Master Orchestrator:** Adaptive loop, architecture gates, and multi-skill dispatch. |
| **`skidora-when-not`** | [`skills/skidora-when-not`](./skills/skidora-when-not) | **Adaptive Gatekeeper:** Ponytail 7-Rung Ladder, YAGNI, KISS, DRY, and SOLID principles. |
| **`skidora-helix`** | [`skills/skidora-helix`](./skills/skidora-helix) | **Single-File Memory:** Silent, background state persistence via `.skidora/recover.md`. |
| **`skidora-network`** | [`skills/skidora-network`](./skills/skidora-network) | **Network & Security:** CORS, timeouts, OpenReplay Spot standard (open-source Jam alternative). |
| **`skidora-intake`** | [`skills/skidora-intake`](./skills/skidora-intake) | **Structured Discovery:** Standardized P0 (blockers), P1 (quality), P2 (optional) question block. |
| **`skidora-planning`** | [`skills/skidora-planning`](./skills/skidora-planning) | **Architecture First:** Layout & data-flow before demo; internal hidden plan if requested. |
| **`skidora-gsd`** | [`skills/skidora-gsd`](./skills/skidora-gsd) | **Execution Bars:** Live project status (`Phase`, `Done`, `Blocked`, `Next`) and on-demand tools. |
| **`skidora-frontend`** | [`skills/skidora-frontend`](./skills/skidora-frontend) | **UI Standards:** Design tokens, layout hierarchy, and component composition rules. |
| **`skidora-backend`** | [`skills/skidora-backend`](./skills/skidora-backend) | **API Discipline:** Natural-language to real router mapping; strictly no invented endpoints. |
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
* **Native Agent Ingestion:** Skidora agents ingest Spot network traces to map failing endpoints directly to the router and handlers without hallucination.

### Production Network Hardening Rules
1. **Zero Credentials in Query Params:** Never pass API keys or bearer tokens in URLs (`/api?token=...`). Always use headers (`Authorization: Bearer <token>`).
2. **Strict CORS Policy:** Whitelist specific origins. Never combine wildcard `*` with `credentials: true`.
3. **Mandatory Timeouts:** Every network request must have an explicit timeout (5s–10s) and exponential backoff retry.
4. **SSRF Defense:** Sanitize and whitelist all user-provided URLs against internal RFC 1918 subnets (`127.0.0.1`, `10.0.0.0/8`, `169.254.169.254`).

---

## 💾 Helix Single-File Memory Contract

Skidora eliminates both context amnesia AND markdown bloat by keeping **one single, compact ledger** inside `.skidora/`:

```
your-project/
└── .skidora/
    └── recover.md       # Single-file compact ledger: past milestones & active state
```

### Clean, Silent Updates
Instead of dumping 5 separate files, Skidora quietly appends one line upon completing verified work:
```markdown
# Helix Recover Ledger
- [2026-09-18] Fixed bookingKpis day window in src/kpis.ts. (14/14 tests pass)
- [2026-09-18] Hardened CORS whitelist on /api/v1/checkout. (Pass A & B verified)
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

Before your agent claims an API or structural feature is "finished", Skidora forces it to provide this standardized **Proof-of-Work Badge**:

```markdown
[Skidora Proof-of-Work]
- Route: POST /api/v1/billing/webhook (verified in app/api/billing/route.ts:42)
- Pass A (Static): Route registered in router with Zod schema validation.
- Pass B (Runtime): curl -X POST http://localhost:3000/api/v1/billing/webhook -> 200 OK
- Regression: 14/14 tests green (0 failures)
```

No more broken builds. No more fake mocks. No ceremony suffocation.

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
