import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models.dart';
import '../../../domain/respiratory_timer.dart';
import '../../../domain/units.dart';
import '../../app_controller.dart';
import '../../core/theme.dart';

class RespiratoryRecordingScreen extends ConsumerStatefulWidget {
  const RespiratoryRecordingScreen({
    required this.animalId,
    this.initialContext = RespiratoryContext.sleeping,
    this.clock,
    super.key,
  });

  final String animalId;
  final RespiratoryContext initialContext;
  final DateTime Function()? clock;

  @override
  ConsumerState<RespiratoryRecordingScreen> createState() => _RespiratoryRecordingScreenState();
}

class _RespiratoryRecordingScreenState extends ConsumerState<RespiratoryRecordingScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  RespiratoryTimerController? _timer;
  Timer? _ticker;
  late final AnimationController _pulse;
  final GlobalKey _recordingSurfaceKey = GlobalKey();
  final GlobalKey _breathButtonKey = GlobalKey();
  late RespiratoryContext _context;
  late int _durationSeconds;
  final TextEditingController _note = TextEditingController();
  Offset? _pulseOrigin;
  bool _pressed = false;
  bool _saving = false;
  bool _interrupted = false;

  DateTime get _now => (widget.clock ?? DateTime.now)();

  @override
  void initState() {
    super.initState();
    _context = widget.initialContext;
    WidgetsBinding.instance.addObserver(this);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
      animationBehavior: AnimationBehavior.preserve,
    );
    _durationSeconds = ref.read(appControllerProvider).snapshot.settings.defaultTimerSeconds;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _pulse.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final timer = _timer;
    if (timer == null) {
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      timer.pause(_now);
      _interrupted = true;
    } else if (state == AppLifecycleState.resumed && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appControllerProvider);
    final animal = state.snapshot.animals.where((value) => value.id == widget.animalId).firstOrNull;
    if (animal == null) {
      return const Scaffold(body: Center(child: Text('Animal not found.')));
    }
    final timer = _timer;
    if (timer == null) {
      return _Setup(
        animal: animal,
        durationSeconds: _durationSeconds,
        context: _context,
        onDurationChanged: (value) => setState(() => _durationSeconds = value),
        onContextChanged: (value) => setState(() => _context = value),
        onStart: _start,
      );
    }
    final snapshot = timer.snapshot(_now);
    final complete =
        snapshot.status == RespiratoryTimerStatus.completed ||
        snapshot.status == RespiratoryTimerStatus.saved;
    final saved = snapshot.status == RespiratoryTimerStatus.saved;
    final paused = snapshot.status == RespiratoryTimerStatus.paused;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return PopScope(
      canPop: snapshot.breathCount == 0 || saved,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          unawaited(_cancel());
        }
      },
      child: Scaffold(
        backgroundColor: CreaturelyColors.darkBackground,
        body: Stack(
          key: _recordingSurfaceKey,
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Semantics(
                container: true,
                label: 'Resting breathing recorder for ${animal.name}',
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Cancel recording',
                            color: CreaturelyColors.white,
                            onPressed: _cancel,
                            icon: const Icon(Icons.close_rounded),
                          ),
                          Expanded(
                            child: Text(
                              '${animal.name} • ${_context.name}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: CreaturelyColors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const Spacer(),
                            Semantics(
                              liveRegion: true,
                              label:
                                  '${snapshot.breathCount} breaths. '
                                  '${_seconds(snapshot.elapsed)} seconds elapsed. '
                                  '${_seconds(snapshot.remaining)} seconds remaining.',
                              child: Column(
                                children: [
                                  Text(
                                    '${snapshot.breathCount}',
                                    key: const ValueKey('breath_count'),
                                    style: const TextStyle(
                                      color: CreaturelyColors.white,
                                      fontSize: 76,
                                      height: 0.95,
                                      fontWeight: FontWeight.w800,
                                      fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    snapshot.breathCount == 1 ? 'breath' : 'breaths',
                                    style: const TextStyle(
                                      color: CreaturelyColors.darkMutedText,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 8,
                              child: LinearProgressIndicator(
                                value:
                                    (snapshot.elapsed.inMilliseconds /
                                            snapshot.targetDuration.inMilliseconds)
                                        .clamp(0, 1),
                                backgroundColor: CreaturelyColors.darkBorder,
                                color: CreaturelyColors.freshMint,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_seconds(snapshot.elapsed).toStringAsFixed(1)} s elapsed',
                                  style: const TextStyle(color: CreaturelyColors.darkMutedText),
                                ),
                                Text(
                                  '${_seconds(snapshot.remaining).toStringAsFixed(1)} s left',
                                  style: const TextStyle(color: CreaturelyColors.darkMutedText),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (!complete && !paused)
                              Semantics(
                                button: true,
                                onTapHint: 'Record one breath',
                                label: 'Record breath',
                                child: GestureDetector(
                                  key: const ValueKey('breath_tap_target'),
                                  onTapDown: _pressBreathButton,
                                  onTapCancel: () => setState(() => _pressed = false),
                                  onTapUp: (_) {
                                    setState(() => _pressed = false);
                                    _recordBreath();
                                  },
                                  child: AnimatedScale(
                                    duration: reduceMotion
                                        ? Duration.zero
                                        : const Duration(milliseconds: 90),
                                    scale: _pressed ? 0.96 : 1,
                                    child: Container(
                                      key: _breathButtonKey,
                                      width: 220,
                                      height: 220,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: CreaturelyColors.freshMint,
                                        border: Border.all(color: CreaturelyColors.white, width: 4),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 20,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.touch_app_rounded,
                                            size: 48,
                                            color: CreaturelyColors.darkOnPrimary,
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            'TAP FOR EACH\nBREATH',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: CreaturelyColors.darkOnPrimary,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              height: 1.15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else if (paused)
                              _PausedPanel(interrupted: _interrupted, onResume: _resume)
                            else
                              _CompletePanel(
                                snapshot: snapshot,
                                note: _note,
                                saving: _saving,
                                thresholds: animal.thresholds,
                                onSave: _save,
                                onRetry: _restart,
                              ),
                            const Spacer(),
                            if (!complete)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    key: const ValueKey('undo_breath'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: CreaturelyColors.white,
                                      side: const BorderSide(color: CreaturelyColors.darkMutedText),
                                    ),
                                    onPressed: snapshot.canUndo ? _undo : null,
                                    icon: const Icon(Icons.undo_rounded),
                                    label: const Text('Undo last'),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    snapshot.status.name,
                                    style: const TextStyle(color: CreaturelyColors.darkMutedText),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: _BreathPulse(
                    animation: _pulse,
                    origin: _pulseOrigin,
                    reduceMotion: reduceMotion,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _start() {
    final controller = RespiratoryTimerController(
      targetDuration: Duration(seconds: _durationSeconds),
      clock: widget.clock,
    )..start(_now);
    setState(() => _timer = controller);
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) {
        return;
      }
      final finished = controller.tick(_now);
      setState(() {});
      if (finished) {
        _ticker?.cancel();
      }
    });
  }

  void _pressBreathButton(TapDownDetails details) {
    final surface = _recordingSurfaceKey.currentContext?.findRenderObject();
    final button = _breathButtonKey.currentContext?.findRenderObject();
    Offset? origin;
    if (surface is RenderBox && surface.hasSize && button is RenderBox && button.hasSize) {
      final buttonCenter = button.localToGlobal(
        Offset(button.size.width / 2, button.size.height / 2),
      );
      origin = surface.globalToLocal(buttonCenter);
    } else if (surface is RenderBox && surface.hasSize) {
      origin = surface.globalToLocal(details.globalPosition);
    }
    setState(() {
      _pressed = true;
      _pulseOrigin = origin ?? details.globalPosition;
    });
  }

  Future<void> _recordBreath() async {
    final timer = _timer!;
    try {
      timer.recordBreath(_now);
    } on StateError {
      return;
    }
    _pulse.duration = MediaQuery.disableAnimationsOf(context)
        ? const Duration(milliseconds: 140)
        : const Duration(milliseconds: 520);
    unawaited(_pulse.forward(from: 0));
    final settings = ref.read(appControllerProvider).snapshot.settings;
    await ref
        .read(recordingFeedbackProvider)
        .breath(haptics: settings.hapticsEnabled, sound: settings.soundEnabled);
    if (mounted) {
      setState(() {});
    }
  }

  void _undo() {
    _timer!.undoLastBreath();
    setState(() {});
  }

  void _resume() {
    _timer!.resume(_now);
    _interrupted = false;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        final complete = _timer!.tick(_now);
        setState(() {});
        if (complete) {
          _ticker?.cancel();
        }
      }
    });
    setState(() {});
  }

  void _restart() {
    _ticker?.cancel();
    setState(() {
      _timer = null;
      _note.clear();
      _interrupted = false;
    });
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    try {
      final animal = ref
          .read(appControllerProvider)
          .snapshot
          .animals
          .firstWhere((value) => value.id == widget.animalId);
      final session = _timer!.buildSession(
        id: ref.read(appControllerProvider.notifier).newId(),
        animalId: animal.id,
        context: _context,
        thresholds: animal.thresholds,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        recordedAt: _now,
      );
      await ref.read(appControllerProvider.notifier).saveRespiratorySession(session);
      if (mounted) {
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _cancel() async {
    final timer = _timer;
    if (timer == null) {
      context.pop();
      return;
    }
    final hasData = timer.snapshot(_now).breathCount > 0;
    var confirmed = !hasData;
    if (hasData) {
      confirmed =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard this recording?'),
              content: const Text('The breaths counted in this session will not be saved.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Keep recording'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard'),
                ),
              ],
            ),
          ) ??
          false;
    }
    if (confirmed && timer.cancel(confirmDataLoss: true) && mounted) {
      context.pop();
    }
  }

  double _seconds(Duration value) => value.inMilliseconds / 1000;
}

class _BreathPulse extends StatelessWidget {
  const _BreathPulse({required this.animation, required this.origin, required this.reduceMotion});

  final Animation<double> animation;
  final Offset? origin;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      if (animation.value == 0 || animation.value == 1) {
        return const SizedBox.shrink(key: ValueKey('breath_pulse_idle'));
      }
      final fade = 1 - Curves.easeIn.transform(animation.value);
      final progress = Curves.easeOutCubic.transform(animation.value);
      return LayoutBuilder(
        key: const ValueKey('breath_pulse_active'),
        builder: (context, constraints) {
          final size = constraints.biggest;
          final pulseOrigin = Offset(
            (origin?.dx ?? size.width / 2).clamp(0, size.width),
            (origin?.dy ?? size.height / 2).clamp(0, size.height),
          );
          final farthestX = math.max(pulseOrigin.dx, size.width - pulseOrigin.dx);
          final farthestY = math.max(pulseOrigin.dy, size.height - pulseOrigin.dy);
          final screenCoveringDiameter =
              2 * math.sqrt(farthestX * farthestX + farthestY * farthestY);
          final expandedDiameter = math.max(220.0, screenCoveringDiameter);
          final diameter = reduceMotion ? 244.0 : 220 + (expandedDiameter - 220) * progress;
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: pulseOrigin.dx - diameter / 2,
                top: pulseOrigin.dy - diameter / 2,
                width: diameter,
                height: diameter,
                child: DecoratedBox(
                  key: const ValueKey('breath_pulse_circle'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CreaturelyColors.freshMint.withValues(alpha: 0.09 * fade),
                    border: Border.all(
                      color: CreaturelyColors.freshMint.withValues(alpha: 0.72 * fade),
                      width: reduceMotion ? 12 : 8,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class _Setup extends StatelessWidget {
  const _Setup({
    required this.animal,
    required this.durationSeconds,
    required this.context,
    required this.onDurationChanged,
    required this.onContextChanged,
    required this.onStart,
  });

  final Animal animal;
  final int durationSeconds;
  final RespiratoryContext context;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<RespiratoryContext> onContextChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Resting breathing')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.air_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                  semanticLabel: 'Breathing',
                ),
                const SizedBox(height: 18),
                Text(
                  'Count ${animal.name}’s breaths',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Wait until ${animal.name} is quietly resting or sleeping. Tap once for '
                  'each rise of the chest. Creaturely uses the actual elapsed time.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                Text('Context', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<RespiratoryContext>(
                  segments: const [
                    ButtonSegment(
                      value: RespiratoryContext.sleeping,
                      label: Text('Sleeping'),
                      icon: Icon(Icons.bedtime_outlined),
                    ),
                    ButtonSegment(
                      value: RespiratoryContext.resting,
                      label: Text('Resting'),
                      icon: Icon(Icons.spa_outlined),
                    ),
                  ],
                  selected: {this.context},
                  onSelectionChanged: (values) => onContextChanged(values.first),
                ),
                const SizedBox(height: 22),
                Text('Timer', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 15, label: Text('15 s')),
                    ButtonSegment(value: 20, label: Text('20 s')),
                    ButtonSegment(value: 30, label: Text('30 s')),
                    ButtonSegment(value: 60, label: Text('60 s')),
                  ],
                  selected: {durationSeconds},
                  onSelectionChanged: (values) => onDurationChanged(values.first),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  key: const ValueKey('start_breathing_session'),
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start counting'),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _PausedPanel extends StatelessWidget {
  const _PausedPanel({required this.interrupted, required this.onResume});

  final bool interrupted;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 420),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: CreaturelyColors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: CreaturelyColors.darkBorder),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.pause_circle_outline_rounded, color: CreaturelyColors.white, size: 46),
        const SizedBox(height: 10),
        Text(
          interrupted ? 'Paused after interruption' : 'Paused',
          style: const TextStyle(
            color: CreaturelyColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Check that the animal is still settled, then continue.',
          textAlign: TextAlign.center,
          style: TextStyle(color: CreaturelyColors.darkMutedText),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: onResume,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Resume'),
        ),
      ],
    ),
  );
}

class _CompletePanel extends StatelessWidget {
  const _CompletePanel({
    required this.snapshot,
    required this.note,
    required this.saving,
    required this.thresholds,
    required this.onSave,
    required this.onRetry,
  });

  final RespiratoryTimerSnapshot snapshot;
  final TextEditingController note;
  final bool saving;
  final RespiratoryThresholds thresholds;
  final VoidCallback onSave;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CreaturelyColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            snapshot.breathCount == 0
                ? 'No breaths counted'
                : '${formatRespiratoryRate(snapshot.ratePerMinute)} breaths/min',
            key: const ValueKey('calculated_rate'),
            style: const TextStyle(
              color: CreaturelyColors.softInk,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          _ThresholdResultStatus(ratePerMinute: snapshot.ratePerMinute, thresholds: thresholds),
          const SizedBox(height: 12),
          TextField(
            controller: note,
            minLines: 1,
            maxLines: 3,
            style: const TextStyle(color: CreaturelyColors.softInk),
            decoration: const InputDecoration(labelText: 'Optional note'),
          ),
          const SizedBox(height: 12),
          const Text(
            'If you are concerned about your animal, contact a veterinarian. '
            'Creaturely does not diagnose conditions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: CreaturelyColors.quietSlate, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: onRetry, child: const Text('Try again')),
              const SizedBox(width: 8),
              FilledButton.icon(
                key: const ValueKey('save_breathing_session'),
                onPressed: snapshot.breathCount == 0 || saving ? null : onSave,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save session'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThresholdResultStatus extends StatelessWidget {
  const _ThresholdResultStatus({required this.ratePerMinute, required this.thresholds});

  final double ratePerMinute;
  final RespiratoryThresholds thresholds;

  @override
  Widget build(BuildContext context) {
    final band = thresholds.describe(ratePerMinute);
    final description = switch (band) {
      ThresholdBand.below =>
        'Below your minimum of ${_thresholdValue(thresholds.minimum!)} breaths/min',
      ThresholdBand.above =>
        'Above your maximum of ${_thresholdValue(thresholds.maximum!)} breaths/min',
      ThresholdBand.inRange when thresholds.minimum != null && thresholds.maximum != null =>
        'Within your saved range of ${_thresholdValue(thresholds.minimum!)}–'
            '${_thresholdValue(thresholds.maximum!)} breaths/min',
      ThresholdBand.inRange when thresholds.minimum != null =>
        'At or above your saved minimum of ${_thresholdValue(thresholds.minimum!)} breaths/min',
      ThresholdBand.inRange when thresholds.maximum != null =>
        'At or below your saved maximum of ${_thresholdValue(thresholds.maximum!)} breaths/min',
      ThresholdBand.inRange => 'Saved target: ${_thresholdValue(thresholds.target!)} breaths/min',
      ThresholdBand.notConfigured => 'No personal range configured',
    };
    final alert = band == ThresholdBand.below || band == ThresholdBand.above;
    final colors = Theme.of(context).colorScheme;
    final foreground = alert ? colors.onErrorContainer : colors.onSurfaceVariant;
    final background = alert ? colors.errorContainer : colors.surfaceContainerHighest;
    final icon = switch (band) {
      ThresholdBand.below || ThresholdBand.above => Icons.warning_amber_rounded,
      ThresholdBand.inRange => Icons.check_circle_outline_rounded,
      ThresholdBand.notConfigured => Icons.info_outline_rounded,
    };
    return Semantics(
      liveRegion: true,
      label: description,
      child: ExcludeSemantics(
        child: Container(
          key: ValueKey(alert ? 'breathing_threshold_alert' : 'breathing_threshold_status'),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: alert ? colors.error : colors.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(icon, color: foreground, size: 22),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  description,
                  key: const ValueKey('breathing_threshold_message'),
                  style: TextStyle(color: foreground, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _thresholdValue(double value) {
    final fixed = value.toStringAsFixed(1);
    return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
  }
}
