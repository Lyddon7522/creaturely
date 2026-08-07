import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/models.dart';

class AnimalAvatar extends StatelessWidget {
  const AnimalAvatar({required this.animal, this.radius = 28, super.key});

  final Animal animal;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final path = animal.photoPath;
    final hasPhoto = path != null && File(path).existsSync();
    final scheme = Theme.of(context).colorScheme;
    final visual = _visualFor(animal.species);
    final accent = switch (visual.accent) {
      _AnimalAccent.primary => scheme.primary,
      _AnimalAccent.secondary => scheme.secondary,
      _AnimalAccent.tertiary => scheme.tertiary,
    };
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = Color.alphaBlend(
      accent.withValues(alpha: dark ? 0.3 : 0.16),
      scheme.surfaceContainerLowest,
    );
    final secondaryBackground = Color.alphaBlend(
      scheme.primary.withValues(alpha: dark ? 0.14 : 0.07),
      background,
    );
    final foreground = Color.lerp(accent, scheme.onSurface, dark ? 0.12 : 0.22)!;
    final diameter = radius * 2;

    return Semantics(
      image: true,
      label: '${animal.name}, ${animal.species}',
      child: ExcludeSemantics(
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: dark ? 0.42 : 0.2)),
            gradient: hasPhoto
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [background, secondaryBackground],
                  ),
          ),
          clipBehavior: Clip.antiAlias,
          child: hasPhoto
              ? Image.file(File(path), fit: BoxFit.cover)
              : Center(
                  child: FaIcon(
                    visual.icon,
                    key: ValueKey<String>('animal_avatar_icon_${animal.id}'),
                    color: foreground,
                    size: radius * (radius < 18 ? 0.9 : 0.94),
                  ),
                ),
        ),
      ),
    );
  }

  static _AnimalIconVisual _visualFor(String species) {
    final value = species.toLowerCase();
    if (_containsAny(value, const ['dog', 'canine', 'puppy'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.dog, _AnimalAccent.secondary);
    }
    if (_containsAny(value, const ['cat', 'feline', 'kitten'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.cat, _AnimalAccent.primary);
    }
    if (_containsAny(value, const ['bird', 'parrot', 'chicken', 'duck', 'finch', 'canary'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.dove, _AnimalAccent.tertiary);
    }
    if (_containsAny(value, const ['fish', 'koi', 'betta', 'goldfish'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.fish, _AnimalAccent.tertiary);
    }
    if (_containsAny(value, const ['axolotl', 'frog', 'toad', 'amphibian', 'newt'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.frog, _AnimalAccent.primary);
    }
    if (_containsAny(value, const ['horse', 'pony'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.horseHead, _AnimalAccent.secondary);
    }
    if (_containsAny(value, const ['cow', 'cattle'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.cow, _AnimalAccent.secondary);
    }
    if (_containsAny(value, const ['otter'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.otter, _AnimalAccent.primary);
    }
    if (_containsAny(value, const ['hippo', 'hippopotamus'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.hippo, _AnimalAccent.tertiary);
    }
    if (_containsAny(value, const ['spider', 'arachnid'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.spider, _AnimalAccent.primary);
    }
    if (_containsAny(value, const ['snake', 'worm'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.worm, _AnimalAccent.primary);
    }
    if (_containsAny(value, const ['lizard', 'gecko', 'reptile'])) {
      return const _AnimalIconVisual(FontAwesomeIcons.dragon, _AnimalAccent.primary);
    }
    return const _AnimalIconVisual(FontAwesomeIcons.paw, _AnimalAccent.secondary);
  }

  static bool _containsAny(String value, Iterable<String> options) => options.any(value.contains);
}

enum _AnimalAccent { primary, secondary, tertiary }

class _AnimalIconVisual {
  const _AnimalIconVisual(this.icon, this.accent);

  final FaIconData icon;
  final _AnimalAccent accent;
}
