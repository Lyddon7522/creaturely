import 'models.dart';

enum RespiratoryTimerStatus { ready, running, paused, completed, cancelled, saved }

class RespiratoryTimerSnapshot {
  const RespiratoryTimerSnapshot({
    required this.status,
    required this.targetDuration,
    required this.elapsed,
    required this.breathCount,
    required this.canUndo,
  });

  final RespiratoryTimerStatus status;
  final Duration targetDuration;
  final Duration elapsed;
  final int breathCount;
  final bool canUndo;

  Duration get remaining {
    final value = targetDuration - elapsed;
    return value.isNegative ? Duration.zero : value;
  }

  double get ratePerMinute =>
      RespiratoryMath.ratePerMinute(breathCount: breathCount, elapsed: elapsed);
}

class RespiratoryMath {
  const RespiratoryMath._();

  static double ratePerMinute({required int breathCount, required Duration elapsed}) {
    if (breathCount < 0) {
      throw ArgumentError.value(breathCount, 'breathCount', 'Cannot be negative.');
    }
    if (elapsed <= Duration.zero || breathCount == 0) {
      return 0;
    }
    return breathCount * Duration.millisecondsPerMinute / elapsed.inMilliseconds;
  }
}

class RespiratoryTimerController {
  RespiratoryTimerController({
    required this.targetDuration,
    DateTime Function()? clock,
    Duration Function()? elapsedClock,
  }) : _clock = clock ?? DateTime.now,
       _elapsedClock = elapsedClock ?? _stopwatchClock() {
    if (!const <int>[15, 20, 30, 60].contains(targetDuration.inSeconds)) {
      throw ArgumentError.value(
        targetDuration,
        'targetDuration',
        'Creaturely supports 15, 20, 30, or 60 seconds.',
      );
    }
  }

  final Duration targetDuration;
  final DateTime Function() _clock;
  final Duration Function() _elapsedClock;
  int _breathCount = 0;

  RespiratoryTimerStatus _status = RespiratoryTimerStatus.ready;
  Duration? _runStartedAt;
  Duration _elapsedBeforeRun = Duration.zero;
  Duration? _completedElapsed;

  RespiratoryTimerStatus get status => _status;

  RespiratoryTimerSnapshot snapshot([DateTime? at]) {
    final elapsed = _elapsed(_tickAt(at));
    return RespiratoryTimerSnapshot(
      status: _status,
      targetDuration: targetDuration,
      elapsed: elapsed,
      breathCount: _breathCount,
      canUndo: _breathCount > 0 && _status != RespiratoryTimerStatus.saved,
    );
  }

  void start([DateTime? at]) {
    if (_status != RespiratoryTimerStatus.ready) {
      throw StateError('A respiratory timer can only be started once.');
    }
    _runStartedAt = _tickAt(at);
    _status = RespiratoryTimerStatus.running;
  }

  void recordBreath([DateTime? at]) {
    final now = _tickAt(at);
    _completeIfDue(now);
    if (_status != RespiratoryTimerStatus.running) {
      throw StateError('Breaths can only be recorded while the timer is running.');
    }
    _breathCount++;
  }

  bool undoLastBreath() {
    if (_breathCount == 0 || _status == RespiratoryTimerStatus.saved) {
      return false;
    }
    _breathCount--;
    return true;
  }

  void pause([DateTime? at]) {
    if (_status != RespiratoryTimerStatus.running) {
      return;
    }
    final now = _tickAt(at);
    _elapsedBeforeRun = _elapsed(now);
    _runStartedAt = null;
    _status = RespiratoryTimerStatus.paused;
  }

  void resume([DateTime? at]) {
    if (_status != RespiratoryTimerStatus.paused) {
      return;
    }
    if (_elapsedBeforeRun >= targetDuration) {
      _completedElapsed = _elapsedBeforeRun;
      _status = RespiratoryTimerStatus.completed;
      return;
    }
    _runStartedAt = _tickAt(at);
    _status = RespiratoryTimerStatus.running;
  }

  bool tick([DateTime? at]) => _completeIfDue(_tickAt(at));

  bool cancel({bool confirmDataLoss = false}) {
    if (_status == RespiratoryTimerStatus.saved) {
      return false;
    }
    if (_breathCount > 0 && !confirmDataLoss) {
      return false;
    }
    _runStartedAt = null;
    _status = RespiratoryTimerStatus.cancelled;
    return true;
  }

  RespiratorySession buildSession({
    required String id,
    required String animalId,
    required RespiratoryContext context,
    required RespiratoryThresholds thresholds,
    String? note,
    DateTime? recordedAt,
  }) {
    if (_status != RespiratoryTimerStatus.completed) {
      throw StateError('Complete the timer before saving.');
    }
    final elapsed = _completedElapsed!;
    if (elapsed <= Duration.zero || _breathCount == 0) {
      throw StateError('A respiratory session needs elapsed time and at least one breath.');
    }
    final now = recordedAt ?? _clock();
    return RespiratorySession(
      id: id,
      animalId: animalId,
      createdAt: now.toUtc(),
      updatedAt: now.toUtc(),
      recordedAt: now.toUtc(),
      durationMilliseconds: elapsed.inMilliseconds,
      breathCount: _breathCount,
      ratePerMinute: RespiratoryMath.ratePerMinute(breathCount: _breathCount, elapsed: elapsed),
      context: context,
      note: note,
      thresholdSnapshot: thresholds,
    );
  }

  /// Call only after persistence succeeds. Building a draft never consumes it.
  void markSaved() {
    if (_status != RespiratoryTimerStatus.completed) {
      throw StateError('Only a completed recording can be marked saved.');
    }
    _status = RespiratoryTimerStatus.saved;
  }

  static Duration Function() _stopwatchClock() {
    final stopwatch = Stopwatch()..start();
    return () => stopwatch.elapsed;
  }

  // Explicit timestamps remain useful for deterministic simulations. Production
  // calls omit them and use a monotonic clock, independent of clock corrections.
  Duration _tickAt(DateTime? at) =>
      at == null ? _elapsedClock() : Duration(microseconds: at.microsecondsSinceEpoch);

  Duration _elapsed(Duration at) {
    if (_completedElapsed != null) {
      return _completedElapsed!;
    }
    if (_runStartedAt == null) {
      return _elapsedBeforeRun;
    }
    final running = at - _runStartedAt!;
    return running.isNegative ? _elapsedBeforeRun : _elapsedBeforeRun + running;
  }

  bool _completeIfDue(Duration at) {
    if (_status != RespiratoryTimerStatus.running) {
      return _status == RespiratoryTimerStatus.completed;
    }
    final elapsed = _elapsed(at);
    if (elapsed < targetDuration) {
      return false;
    }
    _completedElapsed = elapsed;
    _runStartedAt = null;
    _status = RespiratoryTimerStatus.completed;
    return true;
  }
}
