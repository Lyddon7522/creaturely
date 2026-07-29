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
  RespiratoryTimerController({required this.targetDuration, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now {
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
  final List<DateTime> _breaths = <DateTime>[];

  RespiratoryTimerStatus _status = RespiratoryTimerStatus.ready;
  DateTime? _runStartedAt;
  Duration _elapsedBeforeRun = Duration.zero;
  Duration? _completedElapsed;

  RespiratoryTimerStatus get status => _status;

  RespiratoryTimerSnapshot snapshot([DateTime? at]) {
    final elapsed = _elapsed(at ?? _clock());
    return RespiratoryTimerSnapshot(
      status: _status,
      targetDuration: targetDuration,
      elapsed: elapsed,
      breathCount: _breaths.length,
      canUndo: _breaths.isNotEmpty && _status != RespiratoryTimerStatus.saved,
    );
  }

  void start([DateTime? at]) {
    if (_status != RespiratoryTimerStatus.ready) {
      throw StateError('A respiratory timer can only be started once.');
    }
    _runStartedAt = at ?? _clock();
    _status = RespiratoryTimerStatus.running;
  }

  void recordBreath([DateTime? at]) {
    final now = at ?? _clock();
    _completeIfDue(now);
    if (_status != RespiratoryTimerStatus.running) {
      throw StateError('Breaths can only be recorded while the timer is running.');
    }
    _breaths.add(now);
  }

  bool undoLastBreath() {
    if (_breaths.isEmpty || _status == RespiratoryTimerStatus.saved) {
      return false;
    }
    _breaths.removeLast();
    return true;
  }

  void pause([DateTime? at]) {
    if (_status != RespiratoryTimerStatus.running) {
      return;
    }
    final now = at ?? _clock();
    _elapsedBeforeRun += now.difference(_runStartedAt!);
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
    _runStartedAt = at ?? _clock();
    _status = RespiratoryTimerStatus.running;
  }

  bool tick([DateTime? at]) => _completeIfDue(at ?? _clock());

  void finish([DateTime? at]) {
    if (_status != RespiratoryTimerStatus.running && _status != RespiratoryTimerStatus.paused) {
      throw StateError('Only an active timer can finish.');
    }
    final elapsed = _elapsed(at ?? _clock());
    if (elapsed <= Duration.zero) {
      throw StateError('A zero-length session cannot be completed.');
    }
    _completedElapsed = elapsed;
    _runStartedAt = null;
    _status = RespiratoryTimerStatus.completed;
  }

  bool cancel({bool confirmDataLoss = false}) {
    if (_status == RespiratoryTimerStatus.saved) {
      return false;
    }
    if (_breaths.isNotEmpty && !confirmDataLoss) {
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
    if (elapsed <= Duration.zero || _breaths.isEmpty) {
      throw StateError('A respiratory session needs elapsed time and at least one breath.');
    }
    final now = recordedAt ?? _clock();
    _status = RespiratoryTimerStatus.saved;
    return RespiratorySession(
      id: id,
      animalId: animalId,
      createdAt: now.toUtc(),
      updatedAt: now.toUtc(),
      recordedAt: now.toUtc(),
      durationMilliseconds: elapsed.inMilliseconds,
      breathCount: _breaths.length,
      ratePerMinute: RespiratoryMath.ratePerMinute(breathCount: _breaths.length, elapsed: elapsed),
      context: context,
      note: note,
      thresholdSnapshot: thresholds,
    );
  }

  Duration _elapsed(DateTime at) {
    if (_completedElapsed != null) {
      return _completedElapsed!;
    }
    if (_runStartedAt == null) {
      return _elapsedBeforeRun;
    }
    final running = at.difference(_runStartedAt!);
    return running.isNegative ? _elapsedBeforeRun : _elapsedBeforeRun + running;
  }

  bool _completeIfDue(DateTime at) {
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
