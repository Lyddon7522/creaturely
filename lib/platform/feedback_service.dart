import 'package:flutter/services.dart';

abstract interface class RecordingFeedback {
  Future<void> breath({required bool haptics, required bool sound});
}

class SystemRecordingFeedback implements RecordingFeedback {
  const SystemRecordingFeedback();

  @override
  Future<void> breath({required bool haptics, required bool sound}) async {
    if (haptics) {
      await HapticFeedback.lightImpact();
    }
    if (sound) {
      await SystemSound.play(SystemSoundType.click);
    }
  }
}

class NoopRecordingFeedback implements RecordingFeedback {
  const NoopRecordingFeedback();

  @override
  Future<void> breath({required bool haptics, required bool sound}) async {}
}
