# Backend & NLP-to-Endpoints Reference

Zero-hallucination endpoint discipline for coding agents.

## NLP -> Router Mapping

1. Parse user phrase for CRUD intent and entities.
2. Locate physical route definition file.
3. Validate handler binding and parameter schema.
4. If torn or conflicting, construct an in-memory route map (`Route -> Middleware -> Handler -> Store`). Resolve at router level without writing temporary `graph.md` files.

## Hard Rules

- **No Mock Hallucinations:** Never claim an endpoint works using fake in-memory stubs or hardcoded mocks.
- **Single Recover Record:** Log verified routes directly into `.skidora/recover.md`.
- **Proof-of-Work:** Pass A static router/handler `<file>:<line>` + Pass B runtime curl exit code 0.
