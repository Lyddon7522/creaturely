import 'package:flutter/material.dart';

import '../../../domain/models.dart';
import '../../core/widgets.dart';

const String customSpeciesOption = 'Other';

const List<String> commonSpeciesOptions = <String>[
  'Dog',
  'Cat',
  'Bird',
  'Rabbit',
  'Reptile',
  'Horse',
  'Fish',
  customSpeciesOption,
];

const Map<String, List<String>> popularBreedSuggestions = <String, List<String>>{
  'Dog': <String>[
    'Mixed breed',
    'Labrador Retriever',
    'Golden Retriever',
    'German Shepherd',
    'French Bulldog',
    'Poodle',
    'Beagle',
    'Dachshund',
    'Australian Shepherd',
    'Border Collie',
    'Chihuahua',
    'Shih Tzu',
    'Yorkshire Terrier',
    'Boxer',
    'Siberian Husky',
  ],
  'Cat': <String>[
    'Mixed breed',
    'Domestic Shorthair',
    'Domestic Longhair',
    'Maine Coon',
    'Siamese',
    'Ragdoll',
    'Bengal',
    'British Shorthair',
    'Persian',
    'Sphynx',
    'Russian Blue',
    'Abyssinian',
  ],
  'Bird': <String>[
    'Mixed or hybrid',
    'Budgerigar',
    'Cockatiel',
    'African Grey',
    'Canary',
    'Lovebird',
    'Conure',
    'Finch',
    'Macaw',
  ],
  'Rabbit': <String>[
    'Mixed breed',
    'Holland Lop',
    'Mini Rex',
    'Netherland Dwarf',
    'Lionhead',
    'Flemish Giant',
    'English Lop',
  ],
  'Horse': <String>[
    'Mixed breed',
    'Quarter Horse',
    'Thoroughbred',
    'Arabian',
    'Appaloosa',
    'Paint Horse',
    'Warmblood',
    'Morgan',
  ],
  'Reptile': <String>[
    'Mixed or hybrid',
    'Bearded Dragon',
    'Leopard Gecko',
    'Ball Python',
    'Corn Snake',
    'Crested Gecko',
    'Red-eared Slider',
  ],
  'Fish': <String>[
    'Mixed or hybrid',
    'Betta',
    'Goldfish',
    'Guppy',
    'Angelfish',
    'Tetra',
    'Cichlid',
  ],
};

String speciesChoiceFor(String? species) {
  if (species != null && commonSpeciesOptions.contains(species) && species != customSpeciesOption) {
    return species;
  }
  return customSpeciesOption;
}

String resolvedSpecies(String choice, TextEditingController customSpecies) =>
    choice == customSpeciesOption ? customSpecies.text.trim() : choice;

RespiratoryThresholds thresholdsFromControllers({
  required TextEditingController minimum,
  required TextEditingController target,
  required TextEditingController maximum,
}) => RespiratoryThresholds(
  minimum: double.tryParse(minimum.text.trim()),
  target: double.tryParse(target.text.trim()),
  maximum: double.tryParse(maximum.text.trim()),
);

String? optionalNonNegativeNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  final parsed = double.tryParse(value);
  return parsed == null || !parsed.isFinite || parsed < 0 ? 'Use zero or a positive number.' : null;
}

class SpeciesSelector extends StatelessWidget {
  const SpeciesSelector({
    required this.choice,
    required this.customSpecies,
    required this.onChoiceChanged,
    required this.keyPrefix,
    super.key,
  });

  final String choice;
  final TextEditingController customSpecies;
  final ValueChanged<String> onChoiceChanged;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      DropdownButtonFormField<String>(
        key: ValueKey<String>('${keyPrefix}_species'),
        initialValue: choice,
        decoration: const InputDecoration(
          labelText: 'Species *',
          helperText: 'Choose a common species or enter your own',
        ),
        items: commonSpeciesOptions
            .map((value) => DropdownMenuItem<String>(value: value, child: Text(value)))
            .toList(growable: false),
        onChanged: (value) {
          if (value != null) {
            onChoiceChanged(value);
          }
        },
      ),
      if (choice == customSpeciesOption) ...[
        const SizedBox(height: 14),
        TextFormField(
          key: ValueKey<String>('${keyPrefix}_custom_species'),
          controller: customSpecies,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Species name *'),
          validator: (value) => value == null || value.trim().isEmpty ? 'Enter the species.' : null,
        ),
      ],
    ],
  );
}

class BreedAutocompleteField extends StatelessWidget {
  const BreedAutocompleteField({
    required this.controller,
    required this.species,
    required this.keyPrefix,
    super.key,
  });

  final TextEditingController controller;
  final String species;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final suggestions = popularBreedSuggestions[species] ?? const <String>[];
    if (suggestions.isEmpty) {
      return TextFormField(
        key: ValueKey<String>('${keyPrefix}_breed'),
        controller: controller,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Breed or variety (optional)',
          helperText: 'Free-form entry; multiple breeds are welcome',
        ),
      );
    }

    return KeyedSubtree(
      key: ValueKey<String>('${keyPrefix}_${species}_breed_suggestions'),
      child: DropdownMenu<String>(
        key: ValueKey<String>('${keyPrefix}_breed'),
        controller: controller,
        requestFocusOnTap: true,
        enableFilter: true,
        enableSearch: true,
        expandedInsets: EdgeInsets.zero,
        menuHeight: 260,
        textInputAction: TextInputAction.next,
        label: const Text('Breed or variety (optional)'),
        helperText: 'Choose a suggestion or type any breed or mix',
        dropdownMenuEntries: suggestions
            .map((option) => DropdownMenuEntry<String>(value: option, label: option))
            .toList(growable: false),
      ),
    );
  }
}

class RespiratoryThresholdFields extends StatelessWidget {
  const RespiratoryThresholdFields({
    required this.minimum,
    required this.target,
    required this.maximum,
    required this.keyPrefix,
    super.key,
  });

  final TextEditingController minimum;
  final TextEditingController target;
  final TextEditingController maximum;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    String? validateMinimum(String? value) {
      final numericError = optionalNonNegativeNumber(value);
      if (numericError != null) {
        return numericError;
      }
      final thresholds = thresholdsFromControllers(
        minimum: minimum,
        target: target,
        maximum: maximum,
      );
      return thresholds.isMinimumOrdered
          ? null
          : "Minimum respiratory rate can't be higher than target or maximum.";
    }

    String? validateTarget(String? value) {
      final numericError = optionalNonNegativeNumber(value);
      if (numericError != null) {
        return numericError;
      }
      final thresholds = thresholdsFromControllers(
        minimum: minimum,
        target: target,
        maximum: maximum,
      );
      return thresholds.isTargetOrdered
          ? null
          : "Target respiratory rate can't be higher than maximum or lower than minimum.";
    }

    String? validateMaximum(String? value) {
      final numericError = optionalNonNegativeNumber(value);
      if (numericError != null) {
        return numericError;
      }
      final thresholds = thresholdsFromControllers(
        minimum: minimum,
        target: target,
        maximum: maximum,
      );
      return thresholds.isMaximumOrdered
          ? null
          : "Maximum respiratory rate can't be lower than target or minimum.";
    }

    final fields = <Widget>[
      _ThresholdField(
        key: ValueKey<String>('${keyPrefix}_threshold_minimum'),
        controller: minimum,
        label: 'Minimum',
        validator: validateMinimum,
      ),
      _ThresholdField(
        key: ValueKey<String>('${keyPrefix}_threshold_target'),
        controller: target,
        label: 'Target',
        validator: validateTarget,
      ),
      _ThresholdField(
        key: ValueKey<String>('${keyPrefix}_threshold_maximum'),
        controller: maximum,
        label: 'Maximum',
        validator: validateMaximum,
      ),
    ];
    final useRow = MediaQuery.textScalerOf(context).scale(1) <= 1.4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeading('Resting respiratory rate'),
        const CalmNotice(
          icon: Icons.info_outline_rounded,
          text:
              'Optional. Only enter values supplied by you or your veterinarian. '
              'Creaturely does not provide species-wide clinical defaults.',
        ),
        const SizedBox(height: 14),
        Text(
          'All values use breaths/min. Leave any field blank if it is unknown.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            if (useRow && constraints.maxWidth >= 600) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < fields.length; index++) ...[
                    Expanded(child: fields[index]),
                    if (index < fields.length - 1) const SizedBox(width: 10),
                  ],
                ],
              );
            }
            return Column(
              children: [
                for (var index = 0; index < fields.length; index++) ...[
                  fields[index],
                  if (index < fields.length - 1) const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ThresholdField extends StatelessWidget {
  const _ThresholdField({
    required this.controller,
    required this.label,
    required this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(labelText: label, hintText: '0', errorMaxLines: 3),
    validator: validator,
  );
}
