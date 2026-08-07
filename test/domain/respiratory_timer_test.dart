import 'package:creaturely/domain/models.dart';
import 'package:creaturely/domain/respiratory_timer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RespiratoryMath', () {
    test('uses actual elapsed milliseconds', () {
      expect(
        RespiratoryMath.ratePerMinute(breathCount: 7, elapsed: const Duration(milliseconds: 15340)),
        closeTo(27.379, 0.001),
      );
    });

    test('rejects negative counts and handles zero elapsed', () {
      expect(
        () => RespiratoryMath.ratePerMinute(breathCount: -1, elapsed: const Duration(seconds: 30)),
        throwsArgumentError,
      );
      expect(RespiratoryMath.ratePerMinute(breathCount: 2, elapsed: Duration.zero), 0);
    });
  });

  group('RespiratoryTimerController', () {
    final start = DateTime.utc(2026, 1, 1, 12);

    test('supports only the four v1 timer choices', () {
      for (final seconds in const <int>[15, 20, 30, 60]) {
        expect(
          () => RespiratoryTimerController(targetDuration: Duration(seconds: seconds)),
          returnsNormally,
        );
      }
      expect(
        () => RespiratoryTimerController(targetDuration: const Duration(seconds: 10)),
        throwsArgumentError,
      );
    });

    test('undo, pause, resume, completion, and single save are deterministic', () {
      final timer = RespiratoryTimerController(targetDuration: const Duration(seconds: 30));
      timer.start(start);
      timer.recordBreath(start.add(const Duration(seconds: 3)));
      timer.recordBreath(start.add(const Duration(seconds: 7)));
      expect(timer.undoLastBreath(), isTrue);
      expect(timer.snapshot(start.add(const Duration(seconds: 10))).breathCount, 1);

      timer.pause(start.add(const Duration(seconds: 12)));
      expect(timer.status, RespiratoryTimerStatus.paused);
      expect(
        timer.snapshot(start.add(const Duration(minutes: 4))).elapsed,
        const Duration(seconds: 12),
      );
      timer.resume(start.add(const Duration(minutes: 4)));
      timer.recordBreath(start.add(const Duration(minutes: 4, seconds: 8)));
      expect(timer.tick(start.add(const Duration(minutes: 4, seconds: 18))), isTrue);

      final snapshot = timer.snapshot();
      expect(snapshot.elapsed, const Duration(seconds: 30));
      expect(snapshot.ratePerMinute, 4);
      final session = timer.buildSession(
        id: 'session',
        animalId: 'animal',
        context: RespiratoryContext.sleeping,
        thresholds: const RespiratoryThresholds(maximum: 30),
        recordedAt: start,
      );
      expect(session.durationMilliseconds, 30000);
      expect(session.breathCount, 2);
      expect(session.ratePerMinute, 4);
      expect(timer.status, RespiratoryTimerStatus.saved);
      expect(
        () => timer.buildSession(
          id: 'duplicate',
          animalId: 'animal',
          context: RespiratoryContext.sleeping,
          thresholds: const RespiratoryThresholds(),
        ),
        throwsStateError,
      );
    });

    test('cancel requires confirmation only when data exists', () {
      final empty = RespiratoryTimerController(targetDuration: const Duration(seconds: 30))
        ..start(start);
      expect(empty.cancel(), isTrue);

      final withData = RespiratoryTimerController(targetDuration: const Duration(seconds: 30))
        ..start(start)
        ..recordBreath(start.add(const Duration(seconds: 2)));
      expect(withData.cancel(), isFalse);
      expect(withData.status, RespiratoryTimerStatus.running);
      expect(withData.cancel(confirmDataLoss: true), isTrue);
      expect(withData.status, RespiratoryTimerStatus.cancelled);
    });

    test('background pause excludes interruption and recovers remaining time', () {
      final timer = RespiratoryTimerController(targetDuration: const Duration(seconds: 20))
        ..start(start)
        ..recordBreath(start.add(const Duration(seconds: 2)))
        ..pause(start.add(const Duration(seconds: 5)));
      timer.resume(start.add(const Duration(hours: 1)));
      expect(
        timer.snapshot(start.add(const Duration(hours: 1, seconds: 10))).elapsed,
        const Duration(seconds: 15),
      );
      expect(timer.tick(start.add(const Duration(hours: 1, seconds: 15))), isTrue);
    });
  });
}
