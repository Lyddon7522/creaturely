# Privacy and network boundary

Creaturely is designed so a keeper can use the complete health journal without
an account or network connection.

## What Vector42 collects

Nothing from Creaturely. The app contains:

- no Vector42 backend or account;
- no advertising SDK;
- no analytics or product-event SDK;
- no crash-reporting or remote logging SDK;
- no proprietary health-data collection;
- no normal-operation HTTP, socket, WebView, or tracking client in Dart.

Animal profiles, measurements, medications, health observations, dose status,
documents, settings, and identifiers remain in local SQLite/app-managed storage
unless the keeper explicitly chooses an export, backup destination, or optional
recovery provider.

## Explicit data exits

Only keeper-initiated or keeper-configured actions may give data to another
process or provider:

- The native share sheet receives a temporary PDF, CSV, or ZIP selected by the
  keeper. Creaturely removes its temporary copy after the share interaction
  returns.
- The system file/document provider saves a `.creaturely` backup or a PDF, CSV,
  or ZIP pet export, and supplies a backup/document the keeper selects. iCloud
  Drive, Google Drive, Dropbox, Files, or another provider may process that
  choice under its own terms.
- Camera/gallery import reads only media the keeper grants or selects and copies
  it into app-managed storage.
- The Settings links for source code and bug reports open a GitHub HTTPS URL in
  the keeper's chosen external browser. Creaturely sends no journal data in
  that URL; copied technical details contain only app version, platform, OS
  version, and locale.
- Optional iOS recovery writes validated `.creaturely` archives to the user's
  private CloudKit database.
- Optional Android recovery writes validated archives to Google Drive's hidden
  `appDataFolder` under the least-privilege `drive.appdata` OAuth scope.

Recovery is backup/restore, not multi-device live sync. Local SQLite remains the
source of truth during ordinary use. Provider signed-out, offline, quota,
permission, and conflict errors do not block local journaling.

## Platform network declarations

Android declares `INTERNET` and `ACCESS_NETWORK_STATE` because its explicit
Google Drive bridge uses the Drive REST API. The Flutter/Dart journaling layer
does not invoke that bridge unless recovery was opted into or the keeper chooses
a recovery action.

iOS declares a CloudKit entitlement for the private recovery bridge. The bridge
is idle during ordinary journal use.

System components and operating systems may perform their own services
(backups, notification delivery, store checks, certificate checks, etc.);
Creaturely neither receives that provider data nor routes it to Vector42.

## Repository controls

- `test/platform/privacy_notifications_test.dart` scans normal application
  sources for Dart network clients, analytics, telemetry, ad, and crash SDKs.
- Dependency review should reject packages that add undeclared tracking or
  normal-operation traffic.
- Any future network feature must be explicit, optional, documented here,
  mediated by a testable adapter, and must not make the local journal dependent
  on a remote service.
- Logs, fixtures, issues, and pull requests must use synthetic data. Never
  commit a keeper's real `.creaturely` archive, health record, photo, or
  document.

## Security scope

Creaturely validates checksums and archive relationships to detect corruption
and make restore atomic. Those checksums are integrity tools, not encryption or
authentication. Device passcodes, OS app-data protection, full-disk encryption,
and private provider encryption are the appropriate protection boundaries for
v1. Do not describe a `.creaturely` file as encrypted unless its destination
actually encrypts it.
