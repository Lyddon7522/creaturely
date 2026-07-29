import 'dart:io';
import 'dart:typed_data';

import 'package:creaturely/app.dart';
import 'package:creaturely/data/database.dart';
import 'package:creaturely/data/document_storage.dart';
import 'package:creaturely/domain/models.dart';
import 'package:creaturely/platform/cloud_recovery_bridge.dart';
import 'package:creaturely/platform/document_save_service.dart';
import 'package:creaturely/platform/external_link_service.dart';
import 'package:creaturely/platform/feedback_service.dart';
import 'package:creaturely/platform/notification_service.dart';
import 'package:creaturely/platform/time_zone_service.dart';
import 'package:creaturely/ui/app_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class WidgetHarness {
  WidgetHarness._({
    required this.database,
    required this.documents,
    required this.temporaryDirectory,
    required this.container,
  });

  final AppDatabase database;
  final DocumentStorage documents;
  final Directory temporaryDirectory;
  final ProviderContainer container;

  static Future<WidgetHarness> create({
    CreaturelySnapshot? snapshot,
    NotificationPermissionState permission = NotificationPermissionState.denied,
    RecordingFeedback feedback = const NoopRecordingFeedback(),
    DocumentSaveService? documentSaver,
    ExternalLinkService? externalLinks,
  }) async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.UTC);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    if (snapshot != null) {
      await database.replaceWith(snapshot);
    }
    final temporaryDirectory = Directory.systemTemp.createTempSync('creaturely-widget-');
    final documents = DocumentStorage.openSync(Directory('${temporaryDirectory.path}/attachments'));
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        documentStorageProvider.overrideWith((ref) async => documents),
        reminderServiceProvider.overrideWithValue(NoopReminderService(permission: permission)),
        timeZoneServiceProvider.overrideWithValue(const _UtcTimeZoneService()),
        recordingFeedbackProvider.overrideWithValue(feedback),
        cloudRecoveryBridgeProvider.overrideWithValue(const _OfflineCloudBridge()),
        if (documentSaver != null) documentSaveServiceProvider.overrideWithValue(documentSaver),
        if (externalLinks != null) externalLinkServiceProvider.overrideWithValue(externalLinks),
      ],
    );
    return WidgetHarness._(
      database: database,
      documents: documents,
      temporaryDirectory: temporaryDirectory,
      container: container,
    );
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const CreaturelyApp()),
    );
    await pumpFrames(tester);
  }

  static Future<void> pumpFrames(
    WidgetTester tester, {
    int count = 12,
    Duration step = const Duration(milliseconds: 50),
  }) async {
    for (var index = 0; index < count; index++) {
      await tester.pump(step);
    }
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await database.close();
    if (temporaryDirectory.existsSync()) {
      temporaryDirectory.deleteSync(recursive: true);
    }
  }
}

class _UtcTimeZoneService implements TimeZoneService {
  const _UtcTimeZoneService();

  @override
  Future<String?> configure() async {
    tz.setLocalLocation(tz.UTC);
    return null;
  }
}

class _OfflineCloudBridge implements CloudRecoveryBridge {
  const _OfflineCloudBridge();

  @override
  Future<CloudRecoveryState> authorize() async => CloudRecoveryState.offline;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<Uint8List> download(String id) async => Uint8List(0);

  @override
  Future<List<CloudSnapshotInfo>> list() async => const <CloudSnapshotInfo>[];

  @override
  Future<CloudRecoveryState> status() async => CloudRecoveryState.offline;

  @override
  Future<void> upload(String id, Uint8List bytes, DateTime createdAt) async {}
}
