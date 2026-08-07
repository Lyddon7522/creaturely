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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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
