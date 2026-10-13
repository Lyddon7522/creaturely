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
  it into app-managed storage. On Android, the documented lost-result recovery
  call recovers only an interrupted image-picker request. The recovered image
  stays on this device and is offered explicitly in photo/document forms; it is
  not silently assigned to an animal or uploaded. Native lost-result data is
  acknowledged only after every recovered image is durably retained; a failed
  local write remains retryable.
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
permission, and conflict errors do not block local journaling. Automatic
recovery failures are visible. Restoring a portable backup preserves this
device's notification and cloud opt-in choices; permission state and automatic
upload settings from another device are not applied.

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

## Local file lifecycle

Imports copy selected bytes into staging before hashing and publishing them.
Pending imports have an in-memory lease until the form saves or closes. Queued
saves acquire a separate lease before waiting, so closing a form cannot let
cleanup delete an attachment referenced by an in-flight save. Files
referenced by animal photos or documents, including archived records, are kept.
Recovered images have a durable local index until the keeper uses them. Reference
collection removes abandoned imports, deleted-record files, and unreachable
restore generations without deleting shared files still in use. Backups and
exports pin their source files while a worker reads them; temporary worker ZIPs
are removed when the operation completes.

Restores preserve a portable safety backup when the current journal is healthy.
If existing attachments are missing or corrupt, a local `.recovery.zip` retains
original metadata and available bytes for repair. This file has the same privacy
sensitivity as the journal. The explicit delete-everything action removes these
safety copies along with migration copies and app-managed attachments.

The unused `printing` native plugin was removed along with the unused direct
`collection` and `cupertino_icons` dependencies. PDF generation still uses the
existing `pdf` package, bundled fonts, and local worker isolates. Compatible
package updates introduce no new app permission, journal network path, or
recovery provider.

The compatible update adds two transitive packages: `objective_c` supplies the
existing Apple path-provider integration, and `yaml_edit` is used by Drift
development tooling. Both use BSD-style licenses. They introduce no new
permission, recovery destination, or journal network operation.
