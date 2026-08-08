# Creaturely agent guidance

## Repository map

- The repository root is the Flutter application for Android and iOS. There is intentionally no
  Flutter web target.
- `site/` is the separate static Astro website and has additional instructions in
  `site/AGENTS.md`.
- `infra/site/` contains the Azure Static Web Apps infrastructure for the website.
- Read `README.md`, `CONTRIBUTING.md`, and the relevant document under `docs/` before changing a
  product boundary, persisted format, privacy behavior, platform integration, or release flow.
- Preserve unrelated work in the working tree and keep generated/editor artifacts out of changes.

## Product invariants

- Keep Creaturely local-first, useful offline, and usable without an account or optional
  permissions. Do not add advertising, analytics, crash reporting, hidden network traffic, or a
  health-data backend.
- Remain species-neutral and non-diagnostic. Do not invent clinical defaults, predictions, or
  medical claims.
- Use only synthetic animal and health data in code, tests, fixtures, screenshots, and reports.
- Maintain accessibility: semantics, contrast, large text, dark theme, practical touch targets,
  and reduced-motion-friendly behavior.
- `assets/brand/` is the source of truth for identity assets and design tokens. Follow
  `docs/brand-guidelines.md`; do not redraw or recolor the mark.
- Never commit credentials, signing material, private backups, or real health data.

## Flutter architecture and code style

- Put immutable models and pure rules in `lib/domain/`, persistence and file/archive behavior in
  `lib/data/`, native integrations behind adapters in `lib/platform/`, and Riverpod/go_router UI
  code in `lib/ui/`.
- Keep platform calls out of widgets and pure domain rules. Prefer small feature screens and
  focused repositories over global service locators or large multipurpose classes.
- Keep user-visible strings in ARB localization resources. Run localization generation after ARB
  edits and commit the generated localization files.
- Follow `analysis_options.yaml`: strict typing, single quotes, declared return types, and the
  100-column formatter. Avoid `dynamic` and unnecessary casts.
- Treat new dependencies, platform permissions, and network behavior as privacy-sensitive. Check
  licenses, transitive behavior, and platform implementations; update
  `docs/PRIVACY_AND_NETWORK.md` when the boundary changes.

## Persistence and generated files

- Read `docs/BACKUP_FORMAT.md` before changing database tables, canonical models, backups,
  attachments, restores, or migrations. Validate a restore fully before any live write and retain
  backward-compatible fixtures for supported formats.
- After Drift schema changes, run `dart run build_runner build`, format
  `lib/data/database.g.dart`, and commit the regenerated file.
- After ARB changes, run `flutter gen-l10n` and commit regenerated localization files.
- After launcher source or generation-rule changes, run `dart run tool/generate_icons.dart` and
  commit the generated platform assets.

## Tests and verification

- Add or update tests at the affected layer. Cover failure paths, rollback, corrupt input, denied
  permissions, DST/time-zone boundaries, and accessibility where relevant.
- While iterating, run the narrowest relevant test. Before handoff for Dart changes, run:

  ```sh
  dart format --output=none --set-exit-if-changed lib test integration_test tool
  flutter analyze
  flutter test
  ```

- Run `flutter test integration_test/creaturely_journey_test.dart` for affected end-to-end flows
  when a simulator or device is available. Run a relevant Android or iOS build for platform-facing
  changes. Report any device, signing, provider-console, integration, or build check that was not
  run.

