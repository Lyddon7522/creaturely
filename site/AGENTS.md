# Creaturely static-site agent guidance

## Scope and structure

- This directory is a separate Astro 7 static site. Use Node.js 22.19 or newer and npm; keep
  `package-lock.json` in sync with dependency changes.
- The deployable output is plain static content in generated `dist/`. Do not turn the site into a
  Flutter web target or add a server runtime.
- Put routes in `src/pages/`, shared page chrome in `src/layouts/`, reusable UI in
  `src/components/`, shared copy/configuration in `src/data/`, and site-wide styling in
  `src/styles/`.
- Consult the Astro Docs MCP server for current Astro APIs and recommendations when framework
  behavior is relevant.

## Content, privacy, and brand

- Preserve the repository-level product invariants: local-first, species-neutral,
  non-diagnostic, privacy-first, and accessible. Use only synthetic examples.
- Do not add analytics, trackers, advertising, account flows, remote fonts, or remote image/script
  assets. Keep the published site functional without client-side JavaScript unless an interaction
  genuinely requires it.
- Published copy must not contain em dashes; `test/content.test.mjs` enforces this convention.
- `../assets/brand/` is the source of truth. Do not edit generated `public/brand/` or
  `src/styles/brand-tokens.generated.css`; the npm lifecycle scripts regenerate them.
- Reuse the approved tokens and existing components. Keep semantic landmarks, keyboard focus,
  responsive layouts, useful alternative text, and reduced-motion behavior intact.

## Astro implementation

- Prefer Astro components, semantic HTML, and scoped or existing global CSS over adding a
  front-end framework or general-purpose client script.
- Co-locate route and component styles with the Astro file that owns the markup. Prefer an
  adjacent, clearly named CSS file imported by that Astro file, or a small scoped `<style>` block.
  Keep `src/styles/global.css` for tokens, resets, shared primitives, and behavior that truly
  applies across routes. Do not add route-specific or component-specific selectors there.
- Preserve static output, trailing-slash routes, canonical/social metadata based on `SITE_URL`,
  the expected app-store support routes, and the Azure Static Web Apps configuration.
- Update tests when routes, required privacy statements, local links, asset policy, or published
  content invariants change.
- Treat `dist/`, `.astro/`, synced brand assets, and the generated token stylesheet as build output,
  not source files.

## Tests and verification

- Use `npm test` for content-policy tests and `npm run check` for Astro/TypeScript checks while
  iterating.
- Before handoff for site changes, run from this directory:

  ```sh
  npm run verify
  ```

- `npm run verify` checks Astro and TypeScript, runs Node tests, builds the static site, validates
  expected pages and local references, and refreshes generated brand assets. Report any check not
  run.
