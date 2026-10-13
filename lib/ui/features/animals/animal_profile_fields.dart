import 'package:flutter/material.dart';

import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../core/widgets.dart';

final String customSpeciesOption = appStrings.other;

final List<String> commonSpeciesOptions = <String>[
  appStrings.dog,
  appStrings.cat,
  appStrings.bird,
  appStrings.rabbit,
  appStrings.reptile,
  appStrings.horse,
  appStrings.fish,
  customSpeciesOption,
];

final Map<String, List<String>> popularBreedSuggestions = <String, List<String>>{
  appStrings.dog: <String>[
    appStrings.mixedBreed,
    appStrings.labradorRetriever,
    appStrings.goldenRetriever,
    appStrings.germanShepherd,
    appStrings.frenchBulldog,
    appStrings.poodle,
    appStrings.beagle,
    appStrings.dachshund,
    appStrings.australianShepherd,
    appStrings.borderCollie,
    appStrings.chihuahua,
    appStrings.shihTzu,
    appStrings.yorkshireTerrier,
    appStrings.boxer,
    appStrings.siberianHusky,
  ],
  appStrings.cat: <String>[
    appStrings.mixedBreed,
    appStrings.domesticShorthair,
    appStrings.domesticLonghair,
    appStrings.maineCoon,
    appStrings.siamese,
    appStrings.ragdoll,
    appStrings.bengal,
    appStrings.britishShorthair,
    appStrings.persian,
    appStrings.sphynx,
    appStrings.russianBlue,
    appStrings.abyssinian,
  ],
  appStrings.bird: <String>[
    appStrings.mixedOrHybrid,
    appStrings.budgerigar,
    appStrings.cockatiel,
    appStrings.africanGrey,
    appStrings.canary,
    appStrings.lovebird,
    appStrings.conure,
    appStrings.finch,
    appStrings.macaw,
  ],
  appStrings.rabbit: <String>[
    appStrings.mixedBreed,
    appStrings.hollandLop,
    appStrings.miniRex,
    appStrings.netherlandDwarf,
    appStrings.lionhead,
    appStrings.flemishGiant,
    appStrings.englishLop,
  ],
  appStrings.horse: <String>[
    appStrings.mixedBreed,
    appStrings.quarterHorse,
    appStrings.thoroughbred,
    appStrings.arabian,
    appStrings.appaloosa,
    appStrings.paintHorse,
    appStrings.warmblood,
    appStrings.morgan,
  ],
  appStrings.reptile: <String>[
    appStrings.mixedOrHybrid,
    appStrings.beardedDragon,
    appStrings.leopardGecko,
    appStrings.ballPython,
    appStrings.cornSnake,
    appStrings.crestedGecko,
    appStrings.redEaredSlider,
  ],
  appStrings.fish: <String>[
    appStrings.mixedOrHybrid,
    appStrings.betta,
    appStrings.goldfish,
    appStrings.guppy,
    appStrings.angelfish,
    appStrings.tetra,
    appStrings.cichlid,
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
  return parsed == null || !parsed.isFinite || parsed < 0
      ? appStrings.useZeroOrAPositiveNumber
      : null;
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
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).species,
          helperText: AppLocalizations.of(context).chooseACommonSpeciesOrEnterYourOwn,
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
          decoration: InputDecoration(labelText: AppLocalizations.of(context).speciesName),
          validator: (value) => value == null || value.trim().isEmpty
              ? AppLocalizations.of(context).enterTheSpecies
              : null,
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
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).breedOrVarietyOptional,
          helperText: AppLocalizations.of(context).freeFormEntryMultipleBreedsAreWelcome,
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
        label: Text(AppLocalizations.of(context).breedOrVarietyOptional),
        helperText: AppLocalizations.of(context).chooseASuggestionOrTypeAnyBreedOrMix,
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
          : AppLocalizations.of(context).minimumRespiratoryRateCanTBeHigherThanTarget;
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
          : AppLocalizations.of(context).targetRespiratoryRateCanTBeHigherThanMaximum;
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
          : AppLocalizations.of(context).maximumRespiratoryRateCanTBeLowerThanTarget;
    }

    final fields = <Widget>[
      _ThresholdField(
        key: ValueKey<String>('${keyPrefix}_threshold_minimum'),
        controller: minimum,
        label: AppLocalizations.of(context).minimum,
        validator: validateMinimum,
      ),
      _ThresholdField(
        key: ValueKey<String>('${keyPrefix}_threshold_target'),
        controller: target,
        label: AppLocalizations.of(context).target,
        validator: validateTarget,
      ),
      _ThresholdField(
        key: ValueKey<String>('${keyPrefix}_threshold_maximum'),
        controller: maximum,
        label: AppLocalizations.of(context).maximum,
        validator: validateMaximum,
      ),
    ];
    final useRow = MediaQuery.textScalerOf(context).scale(1) <= 1.4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(AppLocalizations.of(context).restingRespiratoryRate),
        CalmNotice(
          icon: Icons.info_outline_rounded,
          text: AppLocalizations.of(context).optionalOnlyEnterValuesSuppliedByYouOrYour,
        ),
        const SizedBox(height: 14),
        Text(
          AppLocalizations.of(context).allValuesUseBreathsMinLeaveAnyFieldBlank,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
