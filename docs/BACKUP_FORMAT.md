# Creaturely backup format

This document specifies the open `.creaturely` format used by Creaturely v1.
The format is designed for keeper-controlled portability and full validation,
not live multi-device synchronization.

## Container

A `.creaturely` file is a ZIP archive. Format version 1 contains:

```text
manifest.json
data.json
attachments/
  <lowercase SHA-256>.blob
```

ZIP entry paths must be relative and must not contain `..` components. ZIP CRC
validation must succeed before any payload is trusted.

## `manifest.json`

The manifest is UTF-8 JSON:

```json
{
  "format": "creaturely-backup",
  "formatVersion": 1,
  "schemaVersion": 4,
  "createdAt": "2026-07-28T18:00:00.000Z",
  "dataFile": "data.json",
  "dataChecksumSha256": "<64 lowercase hexadecimal characters>",
  "attachments": [
    {
      "checksumSha256": "<64 lowercase hexadecimal characters>",
      "archivePath": "attachments/<checksum>.blob",
      "byteLength": 12345
    }
  ]
}
```

- `format` identifies Creaturely backups.
- `formatVersion` versions the archive/container contract independently of the
  data schema. Creaturely v1 accepts exactly format version 1.
- `schemaVersion` must match the version inside `data.json`. Current writers
  emit data schema version 4. Readers accept schemas 2 and 3 after complete
  archive/checksum validation. Schema 2 gains empty respiratory- and
  weight-reminder collections; schema 3 gains an empty weight-reminder
  collection. Unknown older or newer schemas are rejected.
- `createdAt` is an ISO-8601 UTC instant.
- `dataChecksumSha256` is the SHA-256 of the exact uncompressed `data.json`
  bytes.
- `attachments` is an inventory of every unique attachment blob. Repeated
  documents with identical bytes share one entry.

Unknown future fields may be ignored, but required fields must be present and
well typed. A reader must not treat a malformed manifest as an empty backup.

## `data.json`

`data.json` is UTF-8 JSON generated from Creaturely's canonical domain model.
The root object contains:

```text
schemaVersion
exportedAt
animals
identifiers
respiratorySessions
respiratoryReminders
weightReminders
medications
medicationSchedules
doseLedger
healthRecords
documents
settings
```

Records use stable UUID strings. Health-owned records carry an `animalId`.
Created/updated and event instants are ISO-8601 timestamps. Local medication
scheduling intent is preserved separately through the chosen wall-clock time,
selected weekdays or interval, and IANA time-zone identifier; readers must not
infer recurring wall time by repeatedly adding 24-hour UTC durations.

Weight is stored canonically in kilograms even when the keeper displays pounds.
Respiratory sessions preserve actual elapsed milliseconds, raw breath count,
calculated breaths per minute, context, note, and the threshold snapshot used at
recording time. Respiratory reminders preserve context, recurrence, selected
weekdays, local wall-clock times, and the IANA time-zone identifier. Weight
reminders preserve the same recurring local-time intent without an observation
context. Export/display units never replace canonical raw values.

Each document entry includes a portable `storedPath` pointing at its archive
blob, SHA-256 checksum, byte length, media type, metadata, and an optional
expiry date. A restoring implementation remaps this portable path to a new
app-managed local path; it must never install an archive path as a live
filesystem path.

Animal profile photos are also stored as content-addressed blobs. During backup,
an animal's local `photoPath` is rewritten to
`attachments/<sha256>.blob`; during restore it is checksum-validated and
remapped to a new app-managed local path. Profile photos and documents with
identical bytes share one inventory/blob entry.

Object keys and list order are deterministic for a given Creaturely snapshot.
Numbers and strings use Dart/JSON representations; non-finite numbers are not
valid. Readers must validate types and required relationships.

## Validation and atomic restore

Before changing live data, a conforming Creaturely restore performs all of the
following:

1. Decode the ZIP with CRC verification and reject unsafe entry paths.
2. Parse the manifest and require a recognized format and supported format/data
   schema version.
3. Verify the exact `data.json` SHA-256.
4. Decode every typed record, reject undeclared archive files, and verify the
   manifest/data schema versions agree.
5. Verify record invariants and unique IDs. Every health record must reference
   an existing animal; medication schedules and dose entries must also
   reference matching parent records.
6. Verify every inventory blob exists, has the declared byte length and SHA-256,
   and is referenced consistently by documents.
7. Stage every attachment in temporary app-managed storage.
8. Create a recoverable `.creaturely` safety snapshot of the current journal.
9. Replace the database as one transaction and commit the staged file swap.
10. If either side fails, restore the previous database and file set. Never
    leave a partially imported journal.

Validation failure must be visible to the keeper and must leave the current
journal untouched.

## Compatibility policy

- Writers emit the current format and data schema.
- Readers reject an unknown archive format version or a data schema newer than
  they implement.
- Schema migrations are explicit and covered by fixtures/tests.
- A future compatible reader may migrate older canonical JSON only after full
  archive/checksum validation.
- Encryption is deliberately outside this container format. A keeper may save
  it to an encrypted device or provider; optional recovery relies on private
  provider storage and provider-managed encryption. Creaturely does not invent
  a custom account or key-recovery protocol.

## MIME and extension

The portable filename extension is `.creaturely`. Until a dedicated media type
is registered, implementations may save or transfer it as `application/zip`
while preserving the extension.

This specification is part of the GPLv3 Creaturely source and may be implemented
by other free/open tools.
