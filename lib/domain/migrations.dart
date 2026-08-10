class MigrationStep {
  const MigrationStep(this.fromVersion, this.toVersion, this.description);

  final int fromVersion;
  final int toVersion;
  final String description;
}

class MigrationPlanner {
  const MigrationPlanner();

  List<MigrationStep> plan(int fromVersion, int toVersion) {
    if (fromVersion < 1 || toVersion < fromVersion || toVersion > 5) {
      throw UnsupportedError('Unsupported schema migration $fromVersion → $toVersion.');
    }
    final steps = <MigrationStep>[];
    if (fromVersion == 1 && toVersion >= 2) {
      steps.add(
        const MigrationStep(
          1,
          2,
          'Add document expiry/reminder metadata and explicit scheduling time-zone intent.',
        ),
      );
    }
    if (fromVersion <= 2 && toVersion >= 3) {
      steps.add(
        const MigrationStep(2, 3, 'Add keeper-configured resting respiratory-rate reminders.'),
      );
    }
    if (fromVersion <= 3 && toVersion >= 4) {
      steps.add(
        const MigrationStep(
          3,
          4,
          'Add recurring weight-check reminders and retire document reminder scheduling.',
        ),
      );
    }
    if (fromVersion <= 4 && toVersion >= 5) {
      steps.add(
        const MigrationStep(
          4,
          5,
          'Add optional medication strength, prescription and refill details.',
        ),
      );
    }
    return steps;
  }
}
