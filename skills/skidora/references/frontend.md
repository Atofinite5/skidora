# Frontend

Use this when the request touches UI, layout, pages, components, styling, or presentation.

## Before editing

1. Inspect the real app: routes, existing components, tokens, design files (`.21st/design.json`, `DESIGN.md` if present).
2. Prefer existing primitives over new lookalikes.
3. If 21st skills are installed and the work is production UI, follow `21st-ui-build` after this file.
4. If `ui-design` or `web-design-guidelines` are installed, apply them on review.
5. If the UI is Phoenix LiveView / HEEx, read [erlang-elixir.md](erlang-elixir.md) and treat `live` routes as the page map.

## Standards

- Semantic HTML, keyboard access, visible focus, labels on icon-only controls.
- Responsive: desktop and a mobile width when layout changes.
- Real product copy and states: loading, empty, error, success.
- No decorative-only gradients, glass, or giant headings unless the project already uses them or the user asked.
- Do not claim a component exists without opening it.

## Architecture to show

For FE work, architecture includes:

- Route/page map
- Component tree for the changed surface
- Data in / data out (hooks, APIs)
- States (loading, empty, error)

Use [templates/architecture.md](../templates/architecture.md).

## Verify

- Exercise the changed flow, not only a screenshot.
- Check other routes that share the same state or component.
- If browser tools are available, use them; otherwise use the project test/dev path and say what could not be clicked.

Removal of a component: Graphifier for dependents, then delete the named files and leftover imports. Recheck the routes that referenced it twice.
