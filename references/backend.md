# Backend & NLP-to-Endpoints Reference

Zero-hallucination endpoint discipline. Canonical map stencil: [`skills/skidora/templates/connection-health.md`](../skills/skidora/templates/connection-health.md).

## NLP -> Router Mapping

1. Parse user phrase for CRUD intent and entities.
2. Locate physical route definition file.
3. Validate handler binding and parameter schema.
4. If torn or conflicting, construct an in-memory route map (`Route -> Middleware -> Handler -> Store`). Resolve at router level without writing `graph.md`.

## Connection Health Map

When the user asks if wiring is done, reply in chat (Claude cowork): status sentence + mermaid + brightest hop + next `file:line`.

| Color | Stroke | Meaning |
|---|---|---|
| green | 2px | Linked + Pass A and Pass B this turn |
| yellow | 3px | Linked, Pass B `UNVERIFIED` |
| orange | 4px | Linked, defect on the hop (warning, torn handler, missing schema) |
| red | 5px | Broken (compile error, 5xx, dangling edge) |

Brighter / thicker = more danger. Never paint green without evidence from this turn. Never invent nodes.

## Hard Rules

- **No Mock Hallucinations:** Never claim an endpoint works using fake stubs or hardcoded mocks.
- **Single Recover Record:** Log verified routes into `.skidora/recover.md`.
- **Proof-of-Work:** Pass A static router/handler `<file>:<line>` + Pass B runtime command or `UNVERIFIED`.
