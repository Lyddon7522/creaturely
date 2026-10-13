import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/models.dart';
import '../domain/units.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/model_labels.dart';
import 'document_storage.dart';

enum PetExportFormat { pdf, csv, zip }

class PetExportService {
  const PetExportService();

  Future<Uint8List> build({
    required PetExportFormat format,
    required CreaturelySnapshot snapshot,
    required String animalId,
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> selectedDocumentIds,
    Map<String, Uint8List> attachmentBytes = const {},
    String locale = 'en',
  }) async {
    final regular = format == PetExportFormat.csv
        ? null
        : await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final bold = format == PetExportFormat.csv
        ? null
        : await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    return Isolate.run(
      () => _build(
        format: format,
        snapshot: snapshot,
        animalId: animalId,
        startDate: startDate,
        endDate: endDate,
        selectedDocumentIds: selectedDocumentIds,
        attachmentBytes: attachmentBytes,
        locale: locale,
        regularFont: regular,
        boldFont: bold,
      ),
    );
  }

  Future<Uint8List> _build({
    required PetExportFormat format,
    required ByteData? regularFont,
    required ByteData? boldFont,
    required CreaturelySnapshot snapshot,
    required String animalId,
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> selectedDocumentIds,
    required Map<String, Uint8List> attachmentBytes,
    String locale = 'en',
  }) async {
    await initializeDateFormatting(locale);
    final localStart = DateTime(startDate.year, startDate.month, startDate.day);
    final localEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999, 999);
    final startUtc = localStart.toUtc();
    final endUtc = localEnd.toUtc();
    final animal = snapshot.animals.singleWhere((value) => value.id == animalId);
    final sessions =
        snapshot.respiratorySessions
            .where(
              (value) => value.animalId == animalId && _inside(value.recordedAt, startUtc, endUtc),
            )
            .toList(growable: false)
          ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final medications = snapshot.medications
        .where(
          (value) =>
              value.animalId == animalId &&
              compareCalendarDates(value.startDate, endDate) <= 0 &&
              (value.endDate == null || compareCalendarDates(value.endDate!, startDate) >= 0),
        )
        .toList(growable: false);
    final medicationIds = medications.map((value) => value.id).toSet();
    final schedules = snapshot.medicationSchedules
        .where((value) => medicationIds.contains(value.medicationId))
        .toList(growable: false);
    final doses =
        snapshot.doseLedger
            .where((value) => value.animalId == animalId && _inside(value.dueAt, startUtc, endUtc))
            .toList(growable: false)
          ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final health =
        snapshot.healthRecords
            .where(
              (value) => value.animalId == animalId && _inside(value.occurredAt, startUtc, endUtc),
            )
            .toList(growable: false)
          ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final documents = snapshot.documents
        .where(
          (value) =>
              value.animalId == animalId &&
              calendarDateIsWithin(value.documentDate, startDate, endDate),
        )
        .toList(growable: false);
    final selectedDocuments = documents
        .where((document) => selectedDocumentIds.contains(document.id))
        .toList(growable: false);

    final csv = format == PetExportFormat.pdf
        ? Uint8List(0)
        : Uint8List.fromList(
            utf8.encode(
              _csv(
                sessions: sessions,
                medications: medications,
                schedules: schedules,
                doses: doses,
                health: health,
                documents: documents,
              ),
            ),
          );
    if (format == PetExportFormat.csv) return csv;
    final pdf = await _pdf(
      regularFont: regularFont!,
      boldFont: boldFont!,
      animal: animal,
      sessions: sessions,
      medications: medications,
      doses: doses,
      health: health,
      documents: documents,
      startDate: startDate,
      endDate: endDate,
      locale: locale,
    );
    if (format == PetExportFormat.pdf) return pdf;
    final temporary = await Directory.systemTemp.createTemp('creaturely-export-');
    final output = File(path.join(temporary.path, 'summary.zip'));
    final encoder = ZipFileEncoder();
    var opened = false;
    try {
      encoder.create(output.path);
      opened = true;
      encoder.addArchiveFile(ArchiveFile.bytes('creaturely-summary.pdf', pdf));
      encoder.addArchiveFile(ArchiveFile.bytes('creaturely-raw-data.csv', csv));
      for (final document in selectedDocuments) {
        final entryPath =
            'documents/${_safeName(document.title)}-${document.checksumSha256.substring(0, 8)}${_extensionForMediaType(document.mediaType)}';
        final bytes = attachmentBytes[document.checksumSha256];
        if (bytes != null) {
          if (bytes.length != document.byteLength ||
              sha256.convert(bytes).toString() != document.checksumSha256) {
            throw const FormatException('A selected attachment failed checksum validation.');
          }
          encoder.addArchiveFile(ArchiveFile.bytes(entryPath, bytes));
        } else {
          final file = File(document.storedPath);
          if (await file.length() != document.byteLength ||
              await DocumentStorage.checksumFile(file) != document.checksumSha256) {
            throw const FormatException('A selected attachment failed checksum validation.');
          }
          await encoder.addFile(file, entryPath);
        }
      }
      await encoder.close();
      opened = false;
      return await output.readAsBytes();
    } finally {
      if (opened) await encoder.close();
      await temporary.delete(recursive: true);
    }
  }

  String _csv({
    required List<RespiratorySession> sessions,
    required List<Medication> medications,
    required List<MedicationSchedule> schedules,
    required List<DoseLedgerEntry> doses,
    required List<HealthRecord> health,
    required List<CareDocument> documents,
  }) {
    const headers = <String>[
      'record_type',
      'timestamp_utc_or_date',
      'name_or_context',
      'raw_value',
      'canonical_unit',
      'display_or_entered_unit',
      'duration_ms',
      'raw_breath_count',
      'calculated_rate_per_minute',
      'status',
      'note',
      'administered_at_utc',
      'intended_local_time',
      'time_zone_id',
      'threshold_minimum',
      'threshold_target',
      'threshold_maximum',
      'medication_form',
      'dose_amount',
      'dose_unit',
      'instructions',
      'prescriber',
      'start_date',
      'end_date',
      'schedule_kind',
      'schedule_details',
      'checksum_sha256',
      'media_type',
      'document_category',
      'expiry_date',
      'medication_strength',
      'pharmacy',
      'prescription_number',
      'refills_remaining',
      'next_refill_date',
    ];
    final rows = <List<Object?>>[headers];

    void addRow(Map<String, Object?> values) {
      rows.add(headers.map((header) => values[header]).toList(growable: false));
    }

    final medicationNames = <String, String>{
      for (final medication in medications) medication.id: medication.name,
    };
    for (final session in sessions) {
      addRow(<String, Object?>{
        'record_type': 'respiratory_session',
        'timestamp_utc_or_date': session.recordedAt.toUtc().toIso8601String(),
        'name_or_context': session.context.name,
        'raw_value': session.breathCount,
        'canonical_unit': 'breaths',
        'display_or_entered_unit': 'breaths/minute',
        'duration_ms': session.durationMilliseconds,
        'raw_breath_count': session.breathCount,
        'calculated_rate_per_minute': session.ratePerMinute,
        'status': session.thresholdSnapshot.describe(session.ratePerMinute).name,
        'note': session.note,
        'threshold_minimum': session.thresholdSnapshot.minimum,
        'threshold_target': session.thresholdSnapshot.target,
        'threshold_maximum': session.thresholdSnapshot.maximum,
      });
    }
    for (final medication in medications) {
      addRow(<String, Object?>{
        'record_type': 'medication',
        'timestamp_utc_or_date': calendarDateToIso8601(medication.startDate),
        'name_or_context': medication.name,
        'raw_value': medication.doseAmount,
        'canonical_unit': medication.doseUnit,
        'display_or_entered_unit': medication.form,
        'status': medication.active ? 'active' : 'inactive',
        'note': medication.notes,
        'medication_form': medication.form,
        'medication_strength': medication.strength,
        'dose_amount': medication.doseAmount,
        'dose_unit': medication.doseUnit,
        'instructions': medication.instructions,
        'prescriber': medication.prescriber,
        'pharmacy': medication.pharmacy,
        'prescription_number': medication.prescriptionNumber,
        'refills_remaining': medication.refillsRemaining,
        'next_refill_date': medication.nextRefillDate == null
            ? null
            : calendarDateToIso8601(medication.nextRefillDate!),
        'start_date': calendarDateToIso8601(medication.startDate),
        'end_date': medication.endDate == null ? null : calendarDateToIso8601(medication.endDate!),
      });
    }
    for (final schedule in schedules) {
      addRow(<String, Object?>{
        'record_type': 'medication_schedule',
        'timestamp_utc_or_date': schedule.updatedAt.toUtc().toIso8601String(),
        'name_or_context': medicationNames[schedule.medicationId],
        'display_or_entered_unit': schedule.kind.name,
        'status': schedule.enabled ? 'enabled' : 'disabled',
        'intended_local_time': schedule.times.map((time) => time.encoded).join('|'),
        'time_zone_id': schedule.timeZoneId,
        'schedule_kind': schedule.kind.name,
        'schedule_details': _scheduleDetails(schedule),
      });
    }
    for (final dose in doses) {
      addRow(<String, Object?>{
        'record_type': 'medication_dose',
        'timestamp_utc_or_date': dose.dueAt.toUtc().toIso8601String(),
        'name_or_context': medicationNames[dose.medicationId] ?? 'Medication dose',
        'display_or_entered_unit': dose.timeZoneId,
        'status': dose.status.name,
        'note': dose.note,
        'administered_at_utc': dose.administeredAt?.toUtc().toIso8601String(),
        'intended_local_time': dose.intendedLocalTime,
        'time_zone_id': dose.timeZoneId,
      });
    }
    for (final record in health) {
      addRow(<String, Object?>{
        'record_type': record.kind.name,
        'timestamp_utc_or_date': record.occurredAt.toUtc().toIso8601String(),
        'name_or_context': record.title,
        'raw_value': record.canonicalValue,
        'canonical_unit': record.canonicalUnit,
        'display_or_entered_unit': record.enteredUnit,
        'note': record.note,
      });
    }
    for (final document in documents) {
      addRow(<String, Object?>{
        'record_type': 'document',
        'timestamp_utc_or_date': calendarDateToIso8601(document.documentDate),
        'name_or_context': document.title,
        'raw_value': document.checksumSha256,
        'canonical_unit': document.mediaType,
        'display_or_entered_unit': document.category.name,
        'note': document.notes,
        'checksum_sha256': document.checksumSha256,
        'media_type': document.mediaType,
        'document_category': document.category.name,
        'expiry_date': document.expiryDate == null
            ? null
            : calendarDateToIso8601(document.expiryDate!),
      });
    }
    return '${rows.map((row) => row.map(_escapeCsv).join(',')).join('\r\n')}\r\n';
  }

  Future<Uint8List> _pdf({
    required ByteData regularFont,
    required ByteData boldFont,
    required Animal animal,
    required List<RespiratorySession> sessions,
    required List<Medication> medications,
    required List<DoseLedgerEntry> doses,
    required List<HealthRecord> health,
    required List<CareDocument> documents,
    required DateTime startDate,
    required DateTime endDate,
    required String locale,
  }) async {
    final strings = lookupAppLocalizations(
      AppLocalizations.supportedLocales.firstWhere(
        (value) => value.languageCode == Intl.shortLocale(locale),
        orElse: () => AppLocalizations.supportedLocales.first,
      ),
    );
    final output = pw.Document(
      // Keeping streams uncompressed makes the open report independently
      // inspectable and simplifies deterministic archive validation.
      compress: false,
      title: strings.pdfTitle(animal.name),
      author: 'Creaturely by Vector42',
      subject: strings.pdfSubject,
      keywords: strings.pdfKeywords,
    );
    final dates = DateFormat.yMMMd(locale);
    final sessionsSummary = sessions.isEmpty
        ? null
        : TrendSummary.fromValues(sessions.map((value) => value.ratePerMinute));
    final completedDoses = doses.where((value) => value.status != DoseStatus.unrecorded).length;
    final givenDoses = doses.where((value) => value.status == DoseStatus.given).length;
    final regular = pw.Font.ttf(regularFont);
    final bold = pw.Font.ttf(boldFont);
    output.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            strings.pdfPage(context.pageNumber, context.pagesCount),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ),
        build: (context) => <pw.Widget>[
          pw.Text(
            animal.name,
            style: const pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '${animal.species}${animal.breed == null ? '' : ' - ${animal.breed}'}',
            style: const pw.TextStyle(fontSize: 13, color: PdfColors.grey700),
          ),
          pw.Text(strings.pdfRange(dates.format(startDate), dates.format(endDate))),
          pw.SizedBox(height: 16),
          _section(strings.careSummary),
          pw.Bullet(
            text: sessionsSummary == null
                ? strings.noBreathingSessionsInRange
                : strings.pdfBreathingSummary(
                    sessionsSummary.count,
                    formatRespiratoryRate(sessionsSummary.latest),
                    formatRespiratoryRate(sessionsSummary.minimum),
                    formatRespiratoryRate(sessionsSummary.maximum),
                  ),
          ),
          pw.Bullet(
            text: strings.pdfActiveMedications(medications.where((value) => value.active).length),
          ),
          pw.Bullet(text: strings.pdfGivenDoses(givenDoses, completedDoses)),
          pw.Bullet(text: strings.pdfHealthCount(health.length)),
          if (sessions.isNotEmpty) ...<pw.Widget>[
            _section(strings.respiratoryRate),
            pw.TableHelper.fromTextArray(
              headers: <String>[
                strings.recorded,
                strings.context,
                strings.breaths,
                strings.elapsed,
                strings.rate,
                strings.note,
              ],
              data: sessions
                  .map(
                    (value) => <String>[
                      DateFormat.yMd(locale).add_jm().format(value.recordedAt.toLocal()),
                      strings.respiratoryContext(value.context),
                      '${value.breathCount}',
                      strings.pdfSeconds((value.durationMilliseconds / 1000).toStringAsFixed(1)),
                      strings.pdfRate(formatRespiratoryRate(value.ratePerMinute)),
                      value.note ?? '',
                    ],
                  )
                  .toList(growable: false),
              headerStyle: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ],
          if (medications.isNotEmpty) ...<pw.Widget>[
            _section(strings.medications),
            ...medications.map(
              (value) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Text(
                  [
                    '${value.name} - ${value.doseAmount} ${value.doseUnit}, ${value.form}',
                    value.instructions,
                    if (value.strength != null) strings.pdfStrength(value.strength!),
                    '${strings.pdfFrom(dates.format(value.startDate))}${value.endDate == null ? '' : ' ${strings.pdfThrough(dates.format(value.endDate!))}'}',
                    if (value.prescriber != null) strings.pdfPrescriber(value.prescriber!),
                    if (value.pharmacy != null) strings.pdfPharmacy(value.pharmacy!),
                    if (value.prescriptionNumber != null)
                      strings.pdfPrescription(value.prescriptionNumber!),
                    if (value.refillsRemaining != null) strings.pdfRefills(value.refillsRemaining!),
                    if (value.nextRefillDate != null)
                      strings.pdfNextRefill(dates.format(value.nextRefillDate!)),
                    if (value.notes != null) strings.pdfNotes(value.notes!),
                    if (!value.active) strings.inactive,
                  ].where((text) => text.isNotEmpty).join('. '),
                ),
              ),
            ),
          ],
          if (health.isNotEmpty) ...<pw.Widget>[
            _section(strings.healthRecords),
            ...health.map(
              (value) => pw.Bullet(
                text:
                    '${dates.format(value.occurredAt.toLocal())}: ${value.title}'
                    '${value.canonicalValue == null ? '' : ' - ${value.canonicalValue} ${value.canonicalUnit ?? ''}'}'
                    '${value.note == null ? '' : '. ${value.note}'}',
              ),
            ),
          ],
          if (documents.isNotEmpty) ...<pw.Widget>[
            _section(strings.includedDocuments),
            ...documents.map(
              (value) => pw.Bullet(
                text:
                    '${value.title} (${strings.documentCategory(value.category)}, '
                    '${dates.format(value.documentDate)})',
              ),
            ),
          ],
          pw.SizedBox(height: 18),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.teal50,
              border: pw.Border.all(color: PdfColors.teal300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Text(strings.pdfDisclaimer, style: const pw.TextStyle(fontSize: 9)),
          ),
        ],
      ),
    );
    return output.save();
  }

  pw.Widget _section(String title) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
    child: pw.Text(title, style: const pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
  );

  bool _inside(DateTime value, DateTime start, DateTime end) =>
      !value.isBefore(start) && !value.isAfter(end);

  String _escapeCsv(Object? value) {
    final string = value?.toString() ?? '';
    if (string.contains(',') || string.contains('"') || string.contains('\n')) {
      return '"${string.replaceAll('"', '""')}"';
    }
    return string;
  }

  String _safeName(String value) {
    final normalized = value
        .replaceAll(RegExp(r'[^A-Za-z0-9._ -]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-');
    return normalized.isEmpty ? 'document' : normalized;
  }

  String _extensionForMediaType(String mediaType) => switch (mediaType) {
    'application/pdf' => '.pdf',
    'image/png' => '.png',
    'image/gif' => '.gif',
    'image/heic' || 'image/heif' => '.heic',
    'image/webp' => '.webp',
    _ => '.jpg',
  };

  String _scheduleDetails(MedicationSchedule schedule) => switch (schedule.kind) {
    ScheduleKind.interval =>
      'every ${schedule.intervalHours} hours'
          '${schedule.times.isEmpty ? '' : ' from ${schedule.times.first.encoded}'}',
    ScheduleKind.daily => schedule.times.map((time) => time.encoded).join('|'),
    ScheduleKind.selectedWeekdays =>
      'weekdays=${(schedule.weekdays.toList()..sort()).join('|')};'
          'times=${schedule.times.map((time) => time.encoded).join('|')}',
  };
}

class TemporaryExportFile {
  const TemporaryExportFile({required this.directory, required this.file});
  final Directory directory;
  final File file;

  static Future<TemporaryExportFile> write(
    Directory temporaryRoot,
    Uint8List bytes,
    PetExportFormat format,
  ) async {
    final directory = await temporaryRoot.createTemp('creaturely-export-');
    final file = File(path.join(directory.path, 'creaturely-summary.${format.name}'));
    try {
      await file.writeAsBytes(bytes, flush: true);
      return TemporaryExportFile(directory: directory, file: file);
    } on Object {
      await directory.delete(recursive: true);
      rethrow;
    }
  }

  Future<void> cleanup() async {
    if (await directory.exists()) await directory.delete(recursive: true);
  }
}
