# Creaturely architecture and state ownership

Creaturely keeps SQLite as the local source of truth. Riverpod owns shared
dependencies, asynchronous queries, and feature commands. StatefulWidgets own
form drafts, tabs, animation controllers, scrolling, and transient interaction.

## Riverpod decision

Keep Riverpod. Animal selection, settings, schedules, restored records, and
permission state affect several routes. Provider overrides let tests replace
databases, clocks, notifications, media, feedback, and cloud adapters. Moving to
another package would not improve persistence or lifecycle correctness by itself.

| Option | Decision |
| --- | --- |
| Riverpod | Retained for shared dependencies, queries, lifecycle and commands. |
| BLoC/Cubit | Viable for explicit workflows, but a migration would add churn without fixing a demonstrated gap. |
| Provider/ChangeNotifier | Viable observation and injection; no demonstrated benefit over the existing Riverpod integration. |
| StatefulWidget/setState | Retained for widget-local drafts and interaction, with controllers disposed by the owning widget. |

All providers are manually declared using stable `Notifier`, `AsyncNotifier`,
`StreamProvider`, `FutureProvider`, and `Provider` APIs. There are no
`StateNotifierProvider` or `flutter_riverpod/legacy.dart` imports. The project
does not add a model generator, service locator, or generic use-case layer.

This follows [Riverpod's migration guidance](https://riverpod.dev/docs/whats_new)
and [Flutter's architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations).

## Ownership

- `lib/domain/`: immutable records, validation, recurrence, dose transitions,
  unit conversion, retention, and monotonic breathing timing. Recurrence rules
  share `CalendarReminder` and `CalendarReminderEngine`; display copy stays out
  of the scheduling rules.
- `lib/data/`: typed repository operations, filtered Drift queries, consistent
  snapshots, attachment ownership, archives, restore, and export workers.
- `lib/platform/`: notifications, image/file picking, lost-image recovery,
  sharing, file saving, time-zone lookup, feedback, and optional cloud recovery.
- `lib/ui/state/`: animal, settings, care, recovery, reminder synchronization,
  and media controllers. Commands serialize their writes and expose loading
  and error state. The application controller owns only initialization, resume,
  queued notification navigation/actions, and opted-in automatic recovery.
- `lib/ui/`: feature views and local form drafts. Presentation strings come
  from ARB resources, including enum labels, reminders, and PDF reports. CSV
  column names and stored enum names remain stable machine-readable values.

## Query and command boundaries

Views subscribe to animal-filtered table streams through `journalViewProvider`.
The immutable `JournalView` contains only the tables used by its feature.
`JournalView` and `CareData` are read models with no serialization API; neither
can be mistaken for a complete portable snapshot. Scoped forms query their
animal directly and do not subscribe to global animal selection. The dashboard
reads only its latest breathing measurement with a SQL limit. Query failures
show an explicit error and retry action. Parameterized query providers dispose
when unused. Equal Drift rows suppress duplicate feature emissions after
unrelated animal updates. The app theme selects only the theme preference.

A routine breathing or health save writes its affected tables; it does not read
every journal table, scan the dose ledger, or republish a global snapshot.
Backups and exports explicitly load a full snapshot inside a read transaction.
Settings changes and dose read/modify/write commands use database transactions,
including updates invoked by notifications. Settings commands update the current
preferences so overlapping changes do not overwrite each other's fields.

Medication horizon maintenance runs at initialization/resume and relevant
schedule changes. It fills absent occurrences through 90 days, including a gap
after a long absence, preserves existing occurrence IDs and recorded history,
and marks overdue rows with one SQL update. Indexed medication/time and
status/time lookups avoid repeatedly reading the entire ledger. Time-zone
rebasing preserves completed history before replacing future intent.

Notifications serialize synchronization and read current care data when queued
work starts. Archived animals are excluded consistently. Obsolete pending
reminders are removed individually; synchronization failures surface with retry
while journal saves remain usable. Cold-launch details are read once and queued
until initialization and navigation are ready. Stale actions for removed or
archived animals are ignored. Failed actions remain queued for explicit retry,
with a separate error from reminder synchronization. Duplicate status actions
preserve the original administration time.

Breathing uses a monotonic elapsed clock; wall time supplies journal timestamps.
Building a session does not consume it. The recording retains its ID and data
across failed writes and marks itself saved only after persistence succeeds.
Recorder setup waits for persisted timer preferences. Restart, cancel and note
editing are disabled during a save, and missing native feedback does not discard
counted breaths. Committed writes and restores remain successful if their
provider is disposed or optional follow-up maintenance fails.

The application controller owns opted-in automatic recovery, including visible
failure state. The recovery manager serializes overlapping snapshot requests
and uses an injectable clock to enforce its daily automatic interval.

See [the backup format](BACKUP_FORMAT.md) for generation-based restore ordering
and [the privacy boundary](PRIVACY_AND_NETWORK.md) for file ownership and data
exits. Release device checks are tracked in [RELEASING.md](RELEASING.md).
