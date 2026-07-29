# Creaturely

Creaturely is a calm, local-first health journal for any animal. It helps one
keeper record care for multiple animals on one active Android or iOS device,
without an account, advertising, analytics, or a health-data backend.

Creaturely is published by **Vector42**, uses the application identifier
`com.vector42.creaturely`, and is free software under the
[GNU GPL version 3](LICENSE).

**Know their normal.** Creaturely’s visual identity pairs calm clinical
confidence with everyday warmth. The approved logos, launcher master, color
tokens, and export-ready assets live in the [brand asset index](assets/brand/README.md);
implementation and usage rules are in the [brand guidelines](docs/brand-guidelines.md).

Pet health reports embed the Apache-2.0-licensed Roboto fonts stored under
`assets/fonts`; their license is bundled and registered in the in-app
open-source license view.

> Creaturely is a journal, not a diagnostic tool. Measurements and reminders do
> not replace advice from a veterinarian.

## Product principles

- **The animal comes first.** Species-neutral profiles and humane language avoid
  defining an animal by a condition.
- **Local is the source of truth.** SQLite and app-managed files are sufficient
  for every normal journaling feature.
- **Copies belong to the keeper.** Open `.creaturely` backups, CSV, PDF, and ZIP
  exports use system document and share surfaces.
- **Cloud recovery is optional, private, and not sync.** A keeper may explicitly
  enable private CloudKit or Google Drive appData snapshots. Local data always
  wins during ordinary use.
- **No hidden data flow.** Vector42 collects no Creaturely data. There is no
  account, backend, analytics, ad, or crash-reporting SDK.
- **No invented medicine.** Respiratory ranges are keeper- or
  veterinarian-supplied; Creaturely ships no species-wide clinical defaults,
  diagnoses, predictions, or phone-derived health telemetry.

## What v1 includes

- Onboarding for local storage, optional backup, notification choice, medical
  disclaimer, and the first animal.
- Profiles for any species, including custom species and breeds, photos,
  approximate age, weight, notes, archive state, and generic identifiers such
  as microchips, tags, bands, and tattoos.
- Manual resting or sleeping respiratory sessions using 15, 20, 30, or
  60-second timers. Rates use actual elapsed time and sessions support undo,
  interruption recovery, haptic/sound preferences, and owner-supplied ranges.
- Medication records, interval/daily/weekday schedules with local-time intent,
  local reminders, notification actions, and a dose ledger for given, skipped,
  missed, and unrecorded doses.
- A unified Schedule destination for medication doses, keeper-configured
  resting/sleeping breathing checks, and weight-check reminders.
- Weigh-ins, allergies, conditions/body issues, custom observations, imported
  images/PDFs, checksum validation, expiry metadata, and visible
  missing/corrupt-file states.
- A lazily rendered, filtered per-animal timeline plus respiratory, weight, and
  medication-history trends for 7/30/90 days, one year, custom ranges, or all
  time, with accessible measurement tables.
- Pet health PDF summaries, CSV raw data, and ZIP packages with selected
  original documents can be saved through the system document provider or
  shared, with automatic cleanup of temporary share files.
- Fully validated, atomic backup restore with a recoverable safety snapshot.

## Supported platforms and toolchain

- Flutter **3.44.8** (stable)
- Dart **3.12.2**
- Android API **24+**; compile/target SDK supplied by Flutter (API 36 in the
  current toolchain); Java 17
- iOS **13+**
- Android and iOS only. A web target is intentionally not present.

Install Flutter, an Android SDK with accepted licenses, and Android Studio's
Java 17 runtime for Android work. iOS builds require macOS, a full supported
Xcode installation, an available simulator runtime, and Apple signing for
device/release archives. This project uses Flutter's Swift Package Manager
integration; there is no application Podfile.

```sh
flutter --version
flutter doctor -v
flutter pub get
flutter gen-l10n
dart run build_runner build
dart format lib/data/database.g.dart
dart run tool/generate_icons.dart
```

Generated Drift and localization files, and generated launcher icons, are
committed so releases are reproducible. Regenerate them after changing database
tables, ARB resources, or the icon generator.

## Run, test, and build

```sh
# Select a connected Android emulator/device or iOS simulator.
flutter devices
flutter run

# Required local verification.
dart format --output=none --set-exit-if-changed lib test integration_test tool
flutter analyze
flutter test
# Requires a connected Android/iOS device or simulator.
flutter test integration_test/creaturely_journey_test.dart

# Platform builds.
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
flutter build ios --simulator --debug --no-codesign
```

The tests cover respiratory timing and lifecycle behavior, thresholds, lossless
unit conversion, DST-aware recurrence, dose-ledger transitions, retention,
migrations, database round trips, corrupt/unsupported restore rejection,
rollback, export contents and cleanup, onboarding, denied permissions,
species-neutral profiles, timeline filtering, chart/table parity, document
failure states, medication rescheduling, themes, text scaling, contrast, and
screen-reader semantics. A source-level privacy test guards against normal Dart
network clients and telemetry packages.

## Architecture

Creaturely uses a feature-oriented Flutter architecture:

```text
lib/
  domain/    immutable models and pure timing, recurrence, trend, unit,
             migration, and retention rules
  data/      Drift/SQLite, repositories, document storage, backup/restore,
             cloud-snapshot coordination, and pet health exports
  platform/  notification, feedback, and native cloud-recovery adapters
  ui/        Riverpod application state, go_router navigation, design system,
             and small feature screens
```

Drift/SQLite is the local source of truth. Stable UUIDs and created/updated
timestamps travel through the domain and open backup model. Platform APIs sit
behind adapters so pure rules and destructive restore behavior can be tested
without a device.

The database schema is explicitly versioned. Before opening an existing
database for migration, Creaturely keeps recoverable pre-open SQLite snapshots.
Restore validates an entire archive and stages attachments before changing
either the database or file store.

See [the open backup format](docs/BACKUP_FORMAT.md) and
[the privacy/network boundary](docs/PRIVACY_AND_NETWORK.md).

## Platform configuration

### Notifications

Android declares notification boot/action receivers and uses inexact scheduling
so the app remains useful when exact-alarm access is restricted. Android 13+
notification permission is requested only from onboarding/settings. iOS uses
actionable categories and a rolling window of at most 60 medication, breathing,
and weight-check reminders. Every schedule edit rebuilds pending reminders from
stable IDs to avoid duplicates.

Notifications are an aid, not a sole medication safeguard: operating systems
may delay or suppress them.

### Android private Google Drive recovery

The native bridge stores archives only in the signed-in user's hidden Drive
`appDataFolder`, using the least-privilege
`https://www.googleapis.com/auth/drive.appdata` scope. A release owner must:

1. Enable the Google Drive API in a Google Cloud project.
2. Configure an Android OAuth client for `com.vector42.creaturely` and every
   release signing-certificate SHA fingerprint.
3. Complete any required OAuth consent-screen configuration.
4. Validate authorization, upload, list, download, quota, offline, conflict,
   retention, and restore paths using release-signed builds.

No client secret or `google-services.json` is required or committed by this
bridge. Android's network permission exists only for explicitly enabled
recovery; ordinary journaling does not invoke the bridge.

### iOS private CloudKit recovery

The repository declares the CloudKit entitlement and container placeholder
`iCloud.com.vector42.creaturely`. In the release Apple Developer account:

1. Assign the correct development team and enable iCloud/CloudKit for the app
   identifier `com.vector42.creaturely`.
2. Create or select the matching container and update the entitlement if the
   production container differs.
3. In CloudKit, deploy the private-database record type
   `CreaturelyRecoverySnapshot` with fields `backup` (Asset), `createdAt`
   (Date/Time), and `byteLength` (Int64) to Production.
4. Validate signed-out, denied, offline, quota, conflict, retention, and atomic
   restore behavior using development and distribution-signed builds.

Do not commit signing credentials, provisioning profiles, private keys, or
provider-console secrets.

## Release prerequisites

Before publishing 1.0:

- Create or rename the public repository to
  [`Lyddon7522/Creaturely`](https://github.com/Lyddon7522/Creaturely), then
  update the local Git remote after the GitHub-side rename succeeds.
- Configure release signing for both platforms. Android currently uses debug
  signing only to make local release-mode development possible.
- Revisit Flutter's temporary legacy-Kotlin compatibility switch after
  `flutter_local_notifications`, `file_picker`, `flutter_timezone`, and
  `share_plus` all support Flutter's built-in Kotlin mode.
- Complete store metadata, privacy disclosures, screenshots, accessibility
  checks, and the platform recovery setup above.
- Exercise notification actions, DST/time-zone changes, background recovery,
  file providers, share sheets, camera/gallery permissions, and cloud errors on
  physical devices.
- Verify a production-signed backup created on each platform restores on the
  other platform, and retain fixtures for every supported backup version.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md). Changes must preserve the local-first,
species-neutral, no-telemetry, non-diagnostic product boundaries. Issues and
contributions should never include real animal health data or private backup
files. Bugs can be reported through the in-app Settings link or the repository's
structured GitHub issue form.
