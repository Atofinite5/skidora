---
name: skidora-backend
description: >-
  Backend APIs and NLP-to-endpoint mapping. Use when changing routes, handlers, or mapping user language to endpoints.
---

# Backend and NLP-to-endpoints

Use this when the request touches APIs, services, jobs, auth, data, or mapping user language to routes.

## Hard rule

An endpoint is real only if it exists in code, an OpenAPI/spec file, or a live server you just called. Do not invent paths, methods, or payloads.

## Before editing

1. Find the HTTP/router layer, handlers, and schema validation in this repo.
2. List current routes that match the request.
3. Read Helix recover for previously verified endpoints.
4. If `mix.exs`, `rebar.config`, or `.erl`/`.ex` sources exist, also read [erlang-elixir.md](erlang-elixir.md) and follow OTP/Phoenix rules there.

## NLP → endpoint

User text is not a spec. Map it:

1. Extract intent (create/modify/remove/query), entity, and constraints from the message.
2. Match to an existing handler/route by name, path, or schema.
3. If no match: that is a P0 (add a new endpoint vs reuse). Do not silently create.
4. Once matched or created, write the mapping into `.skidora/draft.md`:

```
NLP: "<user phrase>" -> <METHOD> <path> (<handler file>)
```

Keep mappings stable so recover can restore them.

## Endpoint work

- Validate input with the project's existing schema library.
- Errors: explicit status codes, no leaked stack/secrets.
- Side effects (mail, payments, deletes) stay behind explicit user intent.
- CD and jobs: [cd-pipelines.md](cd-pipelines.md).

## Architecture to show

- Module map (router → handler → store)
- Sequence for the main request
- Table of endpoints in scope (method, path, auth, change: add/edit/remove)
- How NLP phrases map to those rows

## Verify twice

For each in-scope endpoint:

1. Static: handler file, route registration, schema.
2. Runtime: project test, curl, or equivalent against the running or test server.

Both must pass. See [verify.md](verify.md). If either fails, retry loop — do not report done.
