import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app_controller.dart';
import 'animal_avatar.dart';
import 'brand.dart';
import 'theme.dart';

export 'animal_avatar.dart';

const double compactVerticalViewportBreakpoint = 600;

bool usesCompactVerticalLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).height < compactVerticalViewportBreakpoint;

class ConstrainedPage extends StatelessWidget {
  const ConstrainedPage({
    required this.child,
    this.maxWidth = CreaturelySpacing.maxContentWidth,
    this.padding = const EdgeInsets.all(CreaturelySpacing.medium),
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(padding: padding, child: child),
    ),
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading({required this.title, this.subtitle, this.action, super.key});

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final compact = usesCompactVerticalLayout(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: compact
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.headlineMedium,
              ),
              if (subtitle != null) ...[
                SizedBox(height: compact ? 2 : 6),
                Text(
                  subtitle!,
                  maxLines: compact ? 1 : null,
                  overflow: compact ? TextOverflow.ellipsis : null,
                  style:
                      (compact
                              ? Theme.of(context).textTheme.bodyMedium
                              : Theme.of(context).textTheme.bodyLarge)
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
        if (action != null) const SizedBox(width: 16),
        ?action,
      ],
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 10),
    child: Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        ?trailing,
      ],
    ),
  );
}

enum QuickActionTone { primary, accent, primaryTonal, secondaryTonal, neutral }

@immutable
class QuickActionItem {
  const QuickActionItem({
    required this.key,
    required this.icon,
    required this.label,
    required this.semanticLabel,
    required this.tone,
    required this.onTap,
  });

  final Key key;
  final IconData icon;
  final String label;
  final String semanticLabel;
  final QuickActionTone tone;
  final VoidCallback onTap;
}

class QuickActionRail extends StatelessWidget {
  const QuickActionRail({required this.actions, this.maxWidth = 680, super.key});

  final List<QuickActionItem> actions;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final labelScale = MediaQuery.textScalerOf(context).scale(14) / 14;
            final useIconLeadingLayout = constraints.maxWidth < 340 || labelScale > 1.3;
            if (useIconLeadingLayout) {
              return _buildIconLeadingLayout(context, constraints.maxWidth);
            }
            return _buildScrollableLayout(context, constraints.maxWidth);
          },
        ),
      ),
    );
  }

  Widget _buildIconLeadingLayout(BuildContext context, double availableWidth) {
    const spacing = 8.0;
    final columns = availableWidth < 280 ? 1 : 2;
    final width = (availableWidth - (spacing * (columns - 1))) / columns;
    return Wrap(
      key: const ValueKey<String>('quick_actions_grid'),
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final action in actions)
          SizedBox(
            width: width,
            child: _QuickActionButton(
              key: action.key,
              action: action,
              iconLeading: true,
              iconStyle: _iconStyle(context, action.tone),
            ),
          ),
      ],
    );
  }

  Widget _buildScrollableLayout(BuildContext context, double availableWidth) {
    const spacing = 8.0;
    final visibleActionCount = actions.length < 4 ? actions.length : 4;
    final showsOverflowHint = actions.length > visibleActionCount;
    final nextActionPeek = showsOverflowHint ? 40.0 : 0.0;
    final spacingCount = (visibleActionCount - 1) + (showsOverflowHint ? 1 : 0);
    final preferredWidth =
        (availableWidth - nextActionPeek - (spacing * spacingCount)) / visibleActionCount;
    final actionWidth = preferredWidth.clamp(80.0, 104.0).toDouble();
    return SizedBox(
      height: 94,
      child: SingleChildScrollView(
        key: const ValueKey<String>('quick_actions_scroll'),
        scrollDirection: Axis.horizontal,
        child: Row(
          key: const ValueKey<String>('quick_actions_row'),
          children: [
            for (var index = 0; index < actions.length; index++) ...[
              if (index > 0) const SizedBox(width: spacing),
              SizedBox(
                width: actionWidth,
                child: _QuickActionButton(
                  key: actions[index].key,
                  action: actions[index],
                  iconLeading: false,
                  iconStyle: _iconStyle(context, actions[index].tone),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  ({Color foreground, BoxDecoration decoration}) _iconStyle(
    BuildContext context,
    QuickActionTone tone,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(CreaturelyRadii.standard);
    return switch (tone) {
      QuickActionTone.primary => (
        foreground: CreaturelyColors.white,
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CreaturelyColors.deepTeal, CreaturelyColors.vitalTeal],
          ),
          boxShadow: [
            BoxShadow(
              color: CreaturelyColors.vitalTeal.withValues(alpha: 0.24),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
      ),
      QuickActionTone.accent => (
        foreground: scheme.onSecondary,
        decoration: BoxDecoration(
          color: scheme.secondary,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: scheme.secondary.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
      QuickActionTone.primaryTonal => (
        foreground: scheme.onPrimaryContainer,
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: radius,
          border: Border.all(color: scheme.primary.withValues(alpha: 0.16)),
        ),
      ),
      QuickActionTone.secondaryTonal => (
        foreground: scheme.onSecondaryContainer,
        decoration: BoxDecoration(
          color: scheme.secondaryContainer,
          borderRadius: radius,
          border: Border.all(color: scheme.secondary.withValues(alpha: 0.16)),
        ),
      ),
      QuickActionTone.neutral => (
        foreground: scheme.onSurfaceVariant,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: radius,
          border: Border.all(color: scheme.outlineVariant),
        ),
      ),
    };
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.action,
    required this.iconLeading,
    required this.iconStyle,
    super.key,
  });

  final QuickActionItem action;
  final bool iconLeading;
  final ({Color foreground, BoxDecoration decoration}) iconStyle;

  @override
  Widget build(BuildContext context) => _TactileSurface(
    semanticLabel: action.semanticLabel,
    onTap: action.onTap,
    child: iconLeading ? _buildIconLeading(context) : _buildIconAbove(context),
  );

  Widget _buildIconAbove(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 94),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _QuickActionIcon(
            icon: action.icon,
            foreground: iconStyle.foreground,
            decoration: iconStyle.decoration,
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: 17,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                action.label,
                maxLines: 1,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildIconLeading(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 68),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Row(
        children: [
          _QuickActionIcon(
            icon: action.icon,
            foreground: iconStyle.foreground,
            decoration: iconStyle.decoration,
            size: 48,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              action.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _QuickActionIcon extends StatelessWidget {
  const _QuickActionIcon({
    required this.icon,
    required this.foreground,
    required this.decoration,
    this.size = 52,
  });

  final IconData icon;
  final Color foreground;
  final BoxDecoration decoration;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: DecoratedBox(
      decoration: decoration,
      child: SizedBox.square(
        dimension: size,
        child: Icon(icon, color: foreground, size: 24),
      ),
    ),
  );
}

class _TactileSurface extends StatefulWidget {
  const _TactileSurface({required this.semanticLabel, required this.onTap, required this.child});

  final String semanticLabel;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_TactileSurface> createState() => _TactileSurfaceState();
}

class _TactileSurfaceState extends State<_TactileSurface> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final radius = BorderRadius.circular(CreaturelyRadii.standard);
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      onTap: widget.onTap,
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1,
        duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: radius,
            onTap: widget.onTap,
            onHighlightChanged: (value) {
              if (_pressed != value) {
                setState(() => _pressed = value);
              }
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '$title. $body',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final boundedHeight = constraints.hasBoundedHeight;
        final compact = boundedHeight && constraints.maxHeight < 260;
        final content = Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: EdgeInsets.all(compact ? 12 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 10 : 18),
                      child: Icon(
                        icon,
                        size: compact ? 26 : 38,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 8 : 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: compact ? 4 : 8),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  if (action != null) ...[SizedBox(height: compact ? 8 : 20), action!],
                ],
              ),
            ),
          ),
        );
        if (!boundedHeight) {
          return content;
        }
        return SingleChildScrollView(
          primary: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: content,
          ),
        );
      },
    ),
  );
}

class CalmNotice extends StatelessWidget {
  const CalmNotice({
    required this.icon,
    required this.text,
    this.tone = NoticeTone.neutral,
    super.key,
  });

  final IconData icon;
  final String text;
  final NoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (tone) {
      NoticeTone.neutral => (scheme.surfaceContainerHighest, scheme.onSurface),
      NoticeTone.supportive => (scheme.primaryContainer, scheme.onPrimaryContainer),
      NoticeTone.attention => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
    };
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: foreground),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text, style: TextStyle(color: foreground, height: 1.4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum NoticeTone { neutral, supportive, attention }

class AnimalPicker extends ConsumerWidget {
  const AnimalPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final animal = state.selectedAnimal;
    if (animal == null) {
      return const SizedBox.shrink();
    }
    final compact = usesCompactVerticalLayout(context);
    return MenuAnchor(
      builder: (context, controller, child) => Semantics(
        button: true,
        label: 'Selected animal: ${animal.name}. Change animal.',
        child: TextButton.icon(
          onPressed: () => controller.isOpen ? controller.close() : controller.open(),
          style: compact
              ? TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  minimumSize: const Size(48, 40),
                )
              : null,
          icon: AnimalAvatar(animal: animal, radius: compact ? 13 : 15),
          label: Text(animal.name),
          iconAlignment: IconAlignment.start,
        ),
      ),
      menuChildren: [
        for (final option in state.activeAnimals)
          MenuItemButton(
            onPressed: () => ref.read(appControllerProvider.notifier).selectAnimal(option.id),
            leadingIcon: AnimalAvatar(animal: option, radius: 13),
            child: Text(option.name),
          ),
        const Divider(),
        MenuItemButton(
          onPressed: () => context.push('/animal/new'),
          leadingIcon: const Icon(Icons.add_rounded),
          child: const Text('Add animal'),
        ),
      ],
    );
  }
}

class SettingsAction extends StatelessWidget {
  const SettingsAction({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Settings',
    onPressed: () => context.push('/settings'),
    icon: const Icon(Icons.settings_outlined),
  );
}

class LoadingPane extends StatelessWidget {
  const LoadingPane({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Semantics(
        container: true,
        label: 'Loading Creaturely',
        child: const ExcludeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CreaturelyMark(size: 64), SizedBox(height: 20), CircularProgressIndicator()],
          ),
        ),
      ),
    ),
  );
}
