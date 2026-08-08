# Creaturely public website

This directory contains the static Creaturely marketing, privacy, terms, and
support website. It uses Astro and produces plain files in `dist/` for Azure
Static Web Apps.

## Local development

Use Node.js 22.12 or newer:

```sh
cd site
npm ci
npm run dev
```

Run the complete local verification before committing:

```sh
npm run verify
```

The current public routes are:

- `/`, product overview
- `/privacy/`, app and website privacy policy
- `/terms/`, terms of use and veterinary disclaimer
- `/support/`, app-store support destination and common answers

## Brand assets

The repository-level `assets/brand` directory remains the source of truth.
Before development, checking, or building, `scripts/sync-brand-assets.mjs`
copies the approved design tokens and SVG logos into generated site locations.
Do not edit generated files in `public/brand` or
`src/styles/brand-tokens.generated.css`.

The two local photographs are licensed through Unsplash and documented in
`docs/photography.md`. The website does not request images, fonts, scripts,
or styles from third-party origins at runtime.

## Production URL

Set `SITE_URL` to the final HTTPS origin when building production. This enables
canonical URLs, Open Graph image URLs, and the sitemap. The Azure bootstrap
script stores the generated Azure hostname as `CREATURELY_SITE_URL` in the
`prod` GitHub environment. A future custom domain can replace that value.

Deployment and Azure bootstrap instructions live in
`../infra/site/README.md`.
