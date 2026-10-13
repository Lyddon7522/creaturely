# Audit remediation record

Implemented September 7, 2026. The repository remains local-first and supports
the existing portable backup format. No destructive journal reset was performed.

## Changes against the audit

| Finding | Implemented behavior |
| --- | --- |
| Medication horizon | Initialization and resume replenish 90 days of occurrences, including gaps after long absences, without replacing recorded history or existing occurrence IDs. |
| Notification startup | Cold-launch details are consumed once. Actions wait for the journal and navigation; medication body taps open the corresponding medication. |
| Failed breathing saves | Session construction is side-effect-free. Persistence must succeed before the timer becomes saved; retries reuse the recording ID and timestamps. Elapsed time uses a monotonic clock. |
| Restore ordering | Validated files are flushed into an isolated generation before SQLite references commit. Old paths survive either side of an interruption. Missing or corrupt current attachments produce a repair safety bundle instead of blocking a valid restore. |
| Reminder lifecycle | Archived animals are filtered, animal edits resynchronize reminders, synchronization is serialized, and failures are visible with retry. Pending notifications are reconciled individually. |
| State ownership and reads | Legacy Riverpod APIs are removed. Focused Notifier/AsyncNotifier controllers and disposable, filtered Drift query providers replace the global reload pipeline. Full backup/export snapshots use a read transaction. |
| Immutable state | Models copy collections into unmodifiable lists/sets, query results are unmodifiable, and validated archive contents are exposed read-only. |
| Validation and failures | IANA zones and required versioned collections are validated. Forms retain failed drafts, UI commands surface errors, and picker/share/clipboard calls use adapters. Android lost-image results are retained locally for explicit selection. |
| Archive/export cost and ownership | Archive validation, PDF creation, archive hashing and ZIP compression run in workers. Production archives stream source files. Exports build only the requested format. File leases and reference collection protect shared files and remove abandoned imports and unreachable generations. |
| Operational tests | Added failed-save retry, monotonic timing, horizon/resume, cold notification, synchronization failure/order, restore interruption/damage/concurrency, attachment ownership, and query-isolation regressions. Date-sensitive timeline/schedule tests use fixed clocks and target occurrences directly. |
| Localization and dead code | UI, notification, timeline, enum and PDF presentation copy uses ARB resources. Removed unused direct dependencies and the migration planner/unused projection methods. Shared reminder recurrence and date/time editing controls replace duplicate implementations. |
| Maintenance and deployment | Flutter is pinned to 3.47.2. Compatible dependency updates remove the site advisories. Both Azure token paths register masking before export to subsequent steps. Stable brand URLs require revalidation. The required Kotlin compatibility setting remains. |

The state-management decision and controller/query boundaries are documented in
[ARCHITECTURE.md](ARCHITECTURE.md). Riverpod is retained for shared dependencies,
queries and commands; StatefulWidgets retain local drafts and interaction. A
BLoC, Cubit, or Provider migration would add churn without resolving an
additional demonstrated problem.

The large-journal regression uses 5,000 synthetic breathing records and a Drift
query interceptor. A breathing save performs no settings, medication, or dose
ledger reads and produces no unrelated settings/medication emissions.

Restore interruption tests use real SQLite files, inject failure immediately
before or after commit, reopen the database, and verify every referenced file
is readable. They establish ordering under those injected failures; they are
not a power-loss or storage-hardware certification.

## Verification on September 7, 2026

Verification uses Flutter 3.47.2 and its bundled Dart 3.13.2. Generated Drift and
localization files reproduce without a diff. Formatting, static analysis, the
unit/widget suite, platform builds, site verification and dependency audit are
run locally. Integration journeys use fresh temporary iOS and Android devices
with synthetic data; these devices are removed after the checks.

| Check | Result |
| --- | --- |
| Dart formatting | Passed; 100 files, no changes required. |
| Flutter analysis | Passed; no issues. |
| Unit/widget tests | 142 passed. |
| Drift and localization generation | Reproduces the generated files in the working tree without differences. |
| Android debug build | Passed. |
| iOS simulator build | Passed. |
| iOS integration journey | 2 passed on a fresh iPhone 17 / iOS 26.5 simulator. |
| Android integration journey | 2 passed on a fresh Pixel 10 Pro / Android 16 emulator. |
| Site checks, tests and build | Passed; 4 Node tests and static-output verification. |
| npm dependency audit | Passed; zero vulnerabilities. |

The temporary simulator and emulator were shut down and removed after testing.
The Android build still reports the expected `flutter_timezone` Kotlin
compatibility warning; removing that setting remains dependent on the plugin's
support for built-in Kotlin.

## Second skeptical review on October 13, 2026

Reviewed the complete remediation and the second-pass changes separately against
an untouched starting snapshot of the working tree. Additional correctness
issues were found and fixed; passing analysis alone had not exposed them.

| Area | Additional fixes |
| --- | --- |
| Riverpod lifetime | Dependencies are captured before asynchronous work, and publication checks `ref.mounted`. Committed saves and restores remain successful when their provider is disposed or optional maintenance fails. Notification initialization is cached and explicitly retried. |
| Query ownership and failure | Scoped forms ignore global selection. Queries wait for an animal before subscribing to its records. The dashboard reads one latest breathing row instead of the full history. Failed reads show an error with explicit retry, including at startup. `JournalView` and `CareData` expose immutable render/care collections rather than partial portable snapshots. |
| Notification actions | Duplicate status actions preserve administration timestamps. Dose edits can clear notes. Read/modify/write operations use transactions. Failed startup actions stay queued for explicit retry and have their own error message. A native `false` initialization result is treated as a failure, and permission-request failures no longer overwrite settings as though the keeper declined. |
| Recorder | Setup waits for the persisted timer default. Restart, cancel and note editing are disabled while saving. Save completion uses the original timer, and failed native feedback does not lose breath counts. |
| Attachment ownership | Pending commands lease files before entering their queue and share the file lock with reference collection. Imports hash the staged copy, acquire a lease only after successful cleanup, and retain native lost-image results until every image has been durably stored. Erasing the journal clears recovered-image state and leases. |
| Restore and archives | Restore preserves this device's notification and cloud choices. Validated archives own their attachment bytes; modifying an uncompressed input buffer cannot change the validated result. |
| Recovery and export | Recovery settings use transactional deltas and one error/loading wrapper. Automatic recovery belongs to the application controller, exposes failures, and serializes snapshot requests. Export requests capture their animal, dates, format and documents before waiting, disable editing during work, avoid late native sheets after disposal, and always clear busy state even if cleanup fails. |
| Simplification | Removed empty recurrence-engine wrappers, the unused `MedicationLedger`, an unused timer finish method, stale localization messages, repeated recovery handlers and repeated form-loading code. Reminder validation shares pure helpers. Archived weight records are excluded from active trends. Remaining sentence fragments and plural labels use ARB messages. |
| Maintenance | Refreshed compatible site dependencies for the newer advisories reported on this date. Updated the documented Dart patch version to match Flutter 3.47.2. |

Regression coverage exercises disposal after commit, failed initialization and
explicit retry, duplicate and failed notification actions, overlapping snapshot
requests, failed identifier/settings saves, picker/export completion after a
screen closes, attachment save/cleanup races, stored timer defaults, unavailable
feedback, archived data, device opt-outs on restore, and archive-buffer aliasing.
The archive-aliasing test and the initial lifecycle regressions reproduced their
failures before the corresponding fixes.

| Check | Second-review result |
| --- | --- |
| Toolchain | Flutter 3.47.2 / Dart 3.13.2. |
| Dart formatting | Passed; 104 files, no changes required. |
| Flutter analysis | Passed; no issues. |
| Unit/widget tests | 167 passed. |
| Drift and localization generation | Reproduces the working-tree files without differences after formatting. |
| Android debug build | Passed. |
| iOS simulator build | Passed. |
| iOS integration journey | 2 passed on a temporary iPhone 17 / iOS 26.5 simulator. |
| Android integration journey | 2 passed on a temporary Android 16 emulator using the installed API 36.1 image. |
| Site checks, tests and build | Passed; 4 Node tests and static-output verification, using Node 24.19.0. |
| npm dependency audit | Passed; zero vulnerabilities. |
| Final diff checks | No whitespace errors or legacy Riverpod providers. Removed verified dead code; localization resources have no unused messages. |

Temporary test devices were removed after verification. The physical-device and
authenticated-provider checks below remain release requirements; these automated
results do not establish those behaviors. No release, signing, deployment or
destructive journal reset was performed.

## Preparing the GitHub PR stack on October 13, 2026

Integrated the audit work with current `main`, preserving dependency, build-tool,
and integration-test fixes merged since the original branch. Resolved the Dart
and site lockfile overlaps, regenerated Drift and localization files, and
rechecked formatting, analysis, all 167 unit/widget tests, and the site build
and four site tests. A fresh site dependency install and audit report zero
vulnerabilities. Android debug and iOS simulator builds also passed on this integrated code.
Simulator journeys above record the completed audit verification before this
integration and were not rerun after it.

The stack separates site/deployment maintenance, the coupled mobile correctness
and Riverpod migration, and architecture/audit/release documentation. Workflow
PR branch filters cover stack members targeting another feature branch. The
stack targets current `main` and does not merge or release the app.

## Release checks requiring devices or provider access

Complete physical-device notification delivery/actions, Android activity-loss
picker recovery, VoiceOver/TalkBack and other physical accessibility checks,
and authenticated CloudKit/Google Drive recovery before release. Simulator
integration covers native bootstrap and the core journal journey; notification
actions have adapter tests and attachment import/recovery ownership has data-layer tests,
but this does not establish physical-device behavior or provider-console setup.

See [RELEASING.md](RELEASING.md) for the release checklist,
[BACKUP_FORMAT.md](BACKUP_FORMAT.md) for restore/recovery semantics, and
[PRIVACY_AND_NETWORK.md](PRIVACY_AND_NETWORK.md) for local file ownership and
data exits. Signing, store delivery, and deployment were not performed.
