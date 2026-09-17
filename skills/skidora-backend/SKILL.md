---
name: skidora-backend
description: >-
  Backend APIs, NLP-to-endpoint mapping, and torn router resolution. Zero invented routes; maps natural language to real router handlers with schema validation.
---

# Backend & NLP-to-Endpoints

Enforce zero-hallucination routing: an endpoint is real ONLY if it exists in router code, an OpenAPI/schema spec, or a verified live route table.

## NLP -> Real Route Mapping

User language is not a technical spec. Map intent to real router files before touching any code:

1. Extract intent, entity, and constraints from the prompt.
2. Match to an existing handler and router file by name, path, or schema.
3. If no match exists, flag as a Blueprint task (new endpoint). Never silently invent a path.
4. Record verified route in `.skidora/recover.md`:
   `Route: <METHOD> <path> -> <handler file:line>`

## Torn Router Resolution (In-Memory Graph)

When a codebase has torn routes, dual backends, or conflicting middleware:
1. Scan router files (`src/routes/*`, `app/api/*`, `router.ex`).
2. Build an in-memory route dependency map: `Route -> Middleware/Auth -> Controller/Handler -> Database/Store`.
3. Resolve conflicts at the router level. Do NOT write external `graph.md` files unless explicitly requested.

## Backend Hardening Rules

- **Schema Validation:** Always validate incoming payloads using the project's existing schema library (Zod, Joi, Pydantic, Ecto).
- **Network Resilience:** Enforce explicit 5s–10s timeouts and sanitized error responses.
- **Zero Secrets in Logs:** Never log authorization headers, passwords, or tokens.
- **Side Effects Guard:** Mutations, webhooks, or deletions require explicit verification.
