import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../platform/notification_service.dart';
import '../../app_controller.dart';
import '../../core/brand.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../animals/animal_profile_fields.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pages = PageController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _customSpecies = TextEditingController();
  final TextEditingController _breed = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _thresholdMin = TextEditingController();
  final TextEditingController _thresholdTarget = TextEditingController();
  final TextEditingController _thresholdMax = TextEditingController();
  int _page = 0;
  String _species = 'Dog';
  bool _disclaimerAccepted = false;
  bool _saving = false;
  NotificationPermissionState _permission = NotificationPermissionState.unknown;

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    _customSpecies.dispose();
    _breed.dispose();
    _age.dispose();
    _thresholdMin.dispose();
    _thresholdTarget.dispose();
    _thresholdMax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  const CreaturelyLogo(width: 164, header: true),
                  const Spacer(),
                  Text('${_page + 1} of 4'),
                ],
              ),
            ),
            LinearProgressIndicator(value: (_page + 1) / 4),
            Expanded(
              child: PageView(
                controller: _pages,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) => setState(() => _page = value),
                children: [
                  _WelcomeStep(privacySummary: l10n.privacySummary),
                  const _BackupStep(),
                  _NotificationStep(permission: _permission, onRequest: _requestNotifications),
                  _AnimalStep(
                    formKey: _form,
                    name: _name,
                    breed: _breed,
                    age: _age,
                    customSpecies: _customSpecies,
                    thresholdMinimum: _thresholdMin,
                    thresholdTarget: _thresholdTarget,
                    thresholdMaximum: _thresholdMax,
                    species: _species,
                    disclaimerAccepted: _disclaimerAccepted,
                    onSpeciesChanged: _changeSpecies,
                    onDisclaimerChanged: (value) => setState(() => _disclaimerAccepted = value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  if (_page > 0)
                    TextButton(
                      onPressed: _saving ? null : () => _showPage(_page - 1),
                      child: const Text('Back'),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    key: _page == 3 ? const ValueKey('finish_onboarding') : null,
                    onPressed: _saving ? null : _next,
                    icon: _saving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(_page == 3 ? Icons.check_rounded : Icons.arrow_forward_rounded),
                    label: Text(_page == 3 ? 'Create journal' : l10n.continueLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestNotifications() async {
    final value = await ref.read(appControllerProvider.notifier).requestNotifications();
    if (mounted) {
      setState(() => _permission = value);
    }
  }

  void _changeSpecies(String value) {
    if (value == _species) {
      return;
    }
    FocusScope.of(context).unfocus();
    _breed.clear();
    setState(() => _species = value);
  }

  Future<void> _showPage(int page) async {
    if (MediaQuery.disableAnimationsOf(context)) {
      _pages.jumpToPage(page);
      return;
    }
    await _pages.animateToPage(
      page,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _next() async {
    if (_page < 3) {
      await _showPage(_page + 1);
      return;
    }
    if (!_form.currentState!.validate() || !_disclaimerAccepted) {
      if (!_disclaimerAccepted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please acknowledge the medical disclaimer.')));
      }
      return;
    }
    final thresholds = thresholdsFromControllers(
      minimum: _thresholdMin,
      target: _thresholdTarget,
      maximum: _thresholdMax,
    );
    if (!thresholds.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review the respiratory-rate values and try again.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final species = resolvedSpecies(_species, _customSpecies);
      await ref
          .read(appControllerProvider.notifier)
          .createAnimal(
            name: _name.text,
            species: species,
            breed: _breed.text,
            approximateAgeMonths: int.tryParse(_age.text),
            thresholds: thresholds,
            completeOnboarding: true,
          );
      if (mounted) {
        context.go('/animals');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.children,
    this.leading,
    super.key,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String body;
  final List<Widget> children;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(CreaturelySpacing.large),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: CreaturelySpacing.maxFormWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child:
                    leading ??
                    Icon(icon, size: 36, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              eyebrow.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 12),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 28),
            ...children,
          ],
        ),
      ),
    ),
  );
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.privacySummary});

  final String privacySummary;

  @override
  Widget build(BuildContext context) => _StepBody(
    icon: Icons.pets_rounded,
    leading: const CreaturelyMark(size: 44),
    eyebrow: 'Welcome',
    title: 'Know their normal.',
    body:
        'Track everyday signs, spot changes, and keep a clearer health history '
        'for every animal in your life.',
    children: [
      CalmNotice(
        icon: Icons.lock_outline_rounded,
        text: privacySummary,
        tone: NoticeTone.supportive,
      ),
      const SizedBox(height: 12),
      const CalmNotice(
        icon: Icons.person_outline_rounded,
        text: 'No account, ads, analytics, or background health-data collection.',
      ),
    ],
  );
}

class _BackupStep extends StatelessWidget {
  const _BackupStep();

  @override
  Widget build(BuildContext context) => const _StepBody(
    icon: Icons.inventory_2_outlined,
    eyebrow: 'Local first',
    title: 'You decide where copies go.',
    body:
        'Your device is the source of truth. You can create an open .creaturely backup '
        'to Files, iCloud Drive, Google Drive, Dropbox, or another provider you choose.',
    children: [
      CalmNotice(
        icon: Icons.cloud_off_outlined,
        text: 'Cloud access is optional. Declining it never limits the journal.',
      ),
      SizedBox(height: 12),
      CalmNotice(
        icon: Icons.restore_rounded,
        text: 'Optional recovery snapshots are backup and restore—not live multi-device sync.',
      ),
    ],
  );
}

class _NotificationStep extends StatelessWidget {
  const _NotificationStep({required this.permission, required this.onRequest});

  final NotificationPermissionState permission;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) => _StepBody(
    icon: Icons.notifications_none_rounded,
    eyebrow: 'Reminders',
    title: 'Helpful, never required.',
    body:
        'Creaturely can schedule medication, breathing, and weight reminders on this device. '
        'You can say no now and change this later.',
    children: [
      if (permission == NotificationPermissionState.denied)
        const CalmNotice(
          icon: Icons.notifications_off_outlined,
          text:
              'Notifications are off. Medication schedules and due doses will still '
              'appear inside Creaturely.',
          tone: NoticeTone.attention,
        )
      else if (permission == NotificationPermissionState.allowed)
        const CalmNotice(
          icon: Icons.check_circle_outline_rounded,
          text: 'Notifications are ready. Individual schedules remain under your control.',
          tone: NoticeTone.supportive,
        )
      else
        FilledButton.tonalIcon(
          key: const ValueKey('request_notifications'),
          onPressed: onRequest,
          icon: const Icon(Icons.notifications_active_outlined),
          label: const Text('Allow reminders'),
        ),
    ],
  );
}

class _AnimalStep extends StatelessWidget {
  const _AnimalStep({
    required this.formKey,
    required this.name,
    required this.breed,
    required this.age,
    required this.customSpecies,
    required this.thresholdMinimum,
    required this.thresholdTarget,
    required this.thresholdMaximum,
    required this.species,
    required this.disclaimerAccepted,
    required this.onSpeciesChanged,
    required this.onDisclaimerChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController breed;
  final TextEditingController age;
  final TextEditingController customSpecies;
  final TextEditingController thresholdMinimum;
  final TextEditingController thresholdTarget;
  final TextEditingController thresholdMaximum;
  final String species;
  final bool disclaimerAccepted;
  final ValueChanged<String> onSpeciesChanged;
  final ValueChanged<bool> onDisclaimerChanged;

  @override
  Widget build(BuildContext context) => _StepBody(
    key: const ValueKey('onboarding_animal_step'),
    icon: Icons.favorite_outline_rounded,
    eyebrow: 'First animal',
    title: 'Who are you caring for?',
    body: 'Only a name and species are needed. Add or change anything else later.',
    children: [
      Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              key: const ValueKey('onboarding_animal_name'),
              controller: name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Enter a name.' : null,
            ),
            const SizedBox(height: 14),
            SpeciesSelector(
              choice: species,
              customSpecies: customSpecies,
              keyPrefix: 'onboarding',
              onChoiceChanged: onSpeciesChanged,
            ),
            const SizedBox(height: 14),
            BreedAutocompleteField(controller: breed, species: species, keyPrefix: 'onboarding'),
            const SizedBox(height: 14),
            TextFormField(
              controller: age,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Approximate age in months (optional)'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return null;
                }
                final parsed = int.tryParse(value);
                return parsed == null || parsed < 0 ? 'Enter a whole number of months.' : null;
              },
            ),
            const SizedBox(height: 20),
            RespiratoryThresholdFields(
              minimum: thresholdMinimum,
              target: thresholdTarget,
              maximum: thresholdMaximum,
              keyPrefix: 'onboarding',
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              key: const ValueKey('accept_disclaimer'),
              value: disclaimerAccepted,
              onChanged: (value) => onDisclaimerChanged(value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('I understand this is a journal, not veterinary care.'),
              subtitle: Text(AppLocalizations.of(context).medicalDisclaimer),
            ),
          ],
        ),
      ),
    ],
  );
}
