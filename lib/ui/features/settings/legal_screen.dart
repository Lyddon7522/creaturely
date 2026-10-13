import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_strings.dart';
import '../../core/brand.dart';
import '../../core/widgets.dart';

enum LegalPage { privacy, terms, medical, about, license }

class LegalScreen extends StatelessWidget {
  const LegalScreen({required this.page, super.key});

  final LegalPage page;

  @override
  Widget build(BuildContext context) {
    final title = switch (page) {
      LegalPage.privacy => AppLocalizations.of(context).privacy,
      LegalPage.terms => AppLocalizations.of(context).terms,
      LegalPage.medical => AppLocalizations.of(context).medicalDisclaimer2,
      LegalPage.about => AppLocalizations.of(context).aboutCreaturely,
      LegalPage.license => AppLocalizations.of(context).gnuGPLv3License,
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ConstrainedPage(
        maxWidth: 760,
        child: page == LegalPage.license
            ? FutureBuilder<String>(
                future: rootBundle.loadString(AppLocalizations.of(context).license),
                builder: (context, snapshot) => snapshot.hasData
                    ? SelectableText(snapshot.data!, style: const TextStyle(height: 1.45))
                    : const Center(child: CircularProgressIndicator()),
              )
            : ListView(
                children: [
                  PageHeading(title: title),
                  const SizedBox(height: 18),
                  ..._sections(context),
                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }

  List<Widget> _sections(BuildContext context) => switch (page) {
    LegalPage.privacy => [
      _section(
        context,
        AppLocalizations.of(context).plainLanguagePromise,
        AppLocalizations.of(context).vector42CollectsNoCreaturelyDataThereIsNoAccount,
      ),
      _section(
        context,
        AppLocalizations.of(context).onDeviceJournal,
        AppLocalizations.of(context).normalOperationUsesLocalSQLiteAndAppManagedFiles,
      ),
      _section(
        context,
        AppLocalizations.of(context).copiesYouChoose,
        AppLocalizations.of(context).whenYouExplicitlySaveABackupOrShareA,
      ),
      _section(
        context,
        AppLocalizations.of(context).localFileIntegrity,
        AppLocalizations.of(context).importedDocumentsStayInAppManagedStorageCreaturelyUses,
      ),
      _section(
        context,
        AppLocalizations.of(context).yourControls,
        AppLocalizations.of(context).youCanExportAnOpenBackupRestoreItArchive,
      ),
    ],
    LegalPage.terms => [
      _section(
        context,
        AppLocalizations.of(context).personalJournal,
        AppLocalizations.of(context).creaturelyIsFreeSoftwareProvidedToHelpOneKeeper,
      ),
      _section(
        context,
        AppLocalizations.of(context).noWarranty,
        AppLocalizations.of(context).creaturelyIsProvidedWithoutWarrantyToTheExtentPermitted,
      ),
      _section(
        context,
        AppLocalizations.of(context).notifications,
        AppLocalizations.of(context).operatingSystemsMayDelayOrSuppressRemindersAlwaysUse,
      ),
    ],
    LegalPage.medical => [
      CalmNotice(
        icon: Icons.medical_information_outlined,
        text: AppLocalizations.of(context).medicalDisclaimer,
        tone: NoticeTone.attention,
      ),
      const SizedBox(height: 18),
      _section(
        context,
        AppLocalizations.of(context).ownerSuppliedRanges,
        AppLocalizations.of(context).creaturelyShipsNoSpeciesWideClinicalThresholdsAnyMinimum,
      ),
      _section(
        context,
        AppLocalizations.of(context).neutralDescriptions,
        AppLocalizations.of(context).aboveBelowAndInRangeLabelsCompareAMeasurement,
      ),
      _section(
        context,
        AppLocalizations.of(context).manualBreathingObservations,
        AppLocalizations.of(context).breathingEntriesComeFromKeeperTapsTheyAreNot,
      ),
      _section(
        context,
        AppLocalizations.of(context).whenConcerned,
        AppLocalizations.of(context).contactAVeterinarianOrAppropriateEmergencyServiceWhenAn,
      ),
    ],
    LegalPage.about => [
      const Center(child: CreaturelyLogo(width: 260, header: true)),
      const SizedBox(height: 24),
      _section(
        context,
        AppLocalizations.of(context).calmCareMadeVisible,
        AppLocalizations.of(context)
            .creaturelyMakesEverydayPetObservationsEasierToUnderstandRemember,
      ),
      _section(
        context,
        AppLocalizations.of(context).creaturely10,
        AppLocalizations.of(context).aLocalFirstPetHealthJournalPublishedByVector42,
      ),
      _section(
        context,
        AppLocalizations.of(context).freeAndOpenSource,
        'Creaturely is licensed under GNU GPLv3. Source code and issue tracking: '
        'https://github.com/Lyddon7522/creaturely',
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.balance_outlined),
        title: Text(AppLocalizations.of(context).readTheGNUGPLv3License),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => const LegalScreen(page: LegalPage.license)),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.account_tree_outlined),
        title: Text(AppLocalizations.of(context).openSourcePackageLicenses),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => showLicensePage(
          context: context,
          applicationName: 'Creaturely',
          applicationVersion: '1.0.0',
          applicationLegalese: AppLocalizations.of(context).vector42GNUGPLv3,
        ),
      ),
    ],
    LegalPage.license => const <Widget>[],
  };

  Widget _section(BuildContext context, String title, String body) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(body, style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}
