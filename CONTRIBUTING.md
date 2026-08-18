# Contributing to Creaturely

Thank you for helping make animal-care records calmer, more private, and more
portable.

## Product boundaries

Every change must preserve these v1 promises:

- Android and iOS, local-first, useful offline, and usable without permissions.
- Any species; never make a dog-specific field or clinical assumption required.
- No account, ads, analytics, crash reporting, hidden traffic, or Vector42
  health-data collection.
- No diagnostic/predictive claims, phone-derived health telemetry, or shipped
  species-wide respiratory thresholds.
- Owner-controlled open backups and exports, with no partial corrupt restore.
- Accessible touch targets, contrast, semantics, text scaling, dark theme, and
  reduced-motion-friendly interactions.
- The approved Creaturely identity in `docs/brand-guidelines.md`; use the
  masters and tokens under `assets/brand` rather than redrawing or recoloring
  the mark.

Use only synthetic animal data in source, tests, screenshots, issues, and pull
requests.

## Development workflow

Use Flutter 3.47.0 / Dart 3.13.0 and Java 17. Start from a focused branch and
keep unrelated generated or editor files out of the change.

```sh
flutter pub get
flutter gen-l10n
dart run build_runner build
dart run tool/generate_icons.dart
dart format lib test integration_test tool
flutter analyze
flutter test
flutter test integration_test/creaturely_journey_test.dart
```

If a table, ARB file, or icon-generation rule changes, commit its regenerated
artifacts. CI reruns generation and fails when the checkout is not reproducible.

Run at least one relevant platform build:

```sh
flutter build apk --debug
flutter build ios --simulator --debug --no-codesign
```

Device-facing changes should also be exercised on physical devices. Include
denied permissions, dark mode, 200% text size, VoiceOver/TalkBack, background
and foreground transitions, local time-zone/DST changes, and notification
rescheduling where relevant.

## Architecture and tests

- Put immutable records and pure rules in `lib/domain`.
- Keep persistence, archives, exports, and file operations in `lib/data`.
- Hide notification, feedback, and cloud APIs behind `lib/platform` adapters.
- Keep UI features small under `lib/ui/features`; route shared application state
  through Riverpod and navigation through go_router.
- Avoid giant screens, repositories, global service locators, and platform calls
  embedded in widgets.

Tests should cover the failure path as carefully as the successful path. Data
format changes need round trips, corrupt/unsupported fixtures, reference and
checksum validation, migration behavior, and rollback tests. Scheduling changes
need explicit IANA zones and DST boundaries. Charts need an accessible table
with parity tests.

## Backup compatibility

Read `docs/BACKUP_FORMAT.md` before touching canonical models, archives, document
storage, or migrations. Never silently reinterpret an existing field or accept
an unknown future schema. Keep fixtures for every supported format and make
restore validation complete before any live write.

## Dependencies and privacy

Prefer small, maintained, open-source packages. Before adding one, inspect its
license, platform implementation, transitive dependencies, permissions, and
network/telemetry behavior. Explain any new platform permission in
`docs/PRIVACY_AND_NETWORK.md` and test the boundary. Never commit secrets,
signing materials, OAuth client secrets, provider credentials, or real backups.

## Pull-request handoff

Describe:

- the keeper-visible outcome;
- product/privacy/accessibility implications;
- generated files;
- tests and platform builds actually run;
- device-only or signing/provider checks still required.

By contributing, you agree that your contribution is licensed under this
repository's GNU GPLv3 license.
