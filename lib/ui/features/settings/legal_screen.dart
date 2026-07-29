import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/brand.dart';
import '../../core/widgets.dart';

enum LegalPage { privacy, terms, medical, about, license }

class LegalScreen extends StatelessWidget {
  const LegalScreen({required this.page, super.key});

  final LegalPage page;

  @override
  Widget build(BuildContext context) {
    final title = switch (page) {
      LegalPage.privacy => 'Privacy',
      LegalPage.terms => 'Terms',
      LegalPage.medical => 'Medical disclaimer',
      LegalPage.about => 'About Creaturely',
      LegalPage.license => 'GNU GPLv3 license',
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ConstrainedPage(
        maxWidth: 760,
        child: page == LegalPage.license
            ? FutureBuilder<String>(
                future: rootBundle.loadString('LICENSE'),
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
        'Plain-language promise',
        'Vector42 collects no Creaturely data. There is no account, analytics, '
            'advertising, crash-reporting SDK, backend, or proprietary health-data collection.',
      ),
      _section(
        context,
        'On-device journal',
        'Normal operation uses local SQLite and app-managed files. Creaturely does not make '
            'network calls while you browse, record, chart, or edit care.',
      ),
      _section(
        context,
        'Copies you choose',
        'When you explicitly save a backup or share a report, the selected file destination, '
            'app, or cloud provider processes that file under its own terms. Optional recovery snapshots '
            'use private CloudKit on iOS or Google Drive appData on Android only after opt-in.',
      ),
      _section(
        context,
        'Local file integrity',
        'Imported documents stay in app-managed storage. Creaturely uses local checksums to show '
            'when a document is missing or has changed, and converts stored weight values only for '
            'your chosen display unit.',
      ),
      _section(
        context,
        'Your controls',
        'You can export an open backup, restore it, archive individual animals, delete records, '
            'or delete the entire local journal from Data management.',
      ),
    ],
    LegalPage.terms => [
      _section(
        context,
        'Personal journal',
        'Creaturely is free software provided to help one keeper organize information for '
            'animals on one active device. You remain responsible for the accuracy of entries, '
            'backups, medication decisions, and veterinary care.',
      ),
      _section(
        context,
        'No warranty',
        'Creaturely is provided without warranty, to the extent permitted by law, under the '
            'GNU General Public License version 3.',
      ),
      _section(
        context,
        'Local notifications',
        'Operating systems may delay or suppress reminders. Always use the care plan supplied '
            'by your veterinarian and do not rely on Creaturely as the sole medication safeguard.',
      ),
    ],
    LegalPage.medical => [
      const CalmNotice(
        icon: Icons.medical_information_outlined,
        text:
            'Creaturely is a journal, not a diagnostic tool. Measurements and reminders do not '
            'replace advice from a veterinarian.',
        tone: NoticeTone.attention,
      ),
      const SizedBox(height: 18),
      _section(
        context,
        'Owner-supplied ranges',
        'Creaturely ships no species-wide clinical thresholds. Any minimum, target, or maximum '
            'shown was entered by you and should come from a care plan you trust.',
      ),
      _section(
        context,
        'Neutral descriptions',
        'Above, below, and in-range labels compare a measurement only with your saved values. '
            'They are not diagnoses, risk scores, or predictions.',
      ),
      _section(
        context,
        'Manual breathing observations',
        'Breathing entries come from keeper taps. They are not phone-sensor readings and do not '
            'measure heart rate.',
      ),
      _section(
        context,
        'When concerned',
        'Contact a veterinarian or appropriate emergency service when an animal appears unwell '
            'or you are worried. Do not delay care to take or enter a measurement.',
      ),
    ],
    LegalPage.about => [
      const Center(child: CreaturelyLogo(width: 260, header: true)),
      const SizedBox(height: 24),
      _section(
        context,
        'Calm care, made visible.',
        'Creaturely makes everyday pet observations easier to understand, remember, and share.',
      ),
      _section(
        context,
        'Creaturely 1.0',
        'A local-first pet-health journal published by Vector42 for Android and iOS. '
            'Application identifier: com.vector42.creaturely.',
      ),
      _section(
        context,
        'Free and open source',
        'Creaturely is licensed under GNU GPLv3. Source code and issue tracking: '
            'https://github.com/Lyddon7522/Creaturely',
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.balance_outlined),
        title: const Text('Read the GNU GPLv3 license'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => const LegalScreen(page: LegalPage.license)),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.account_tree_outlined),
        title: const Text('Open-source package licenses'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => showLicensePage(
          context: context,
          applicationName: 'Creaturely',
          applicationVersion: '1.0.0',
          applicationLegalese: '© Vector42 • GNU GPLv3',
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
