import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';

/// Handles fire-and-forget UI commands. Forms that need a successful result
/// before closing keep their own try/catch and retain the draft on failure.
Future<void> runUiCommand(BuildContext context, Future<void> Function() action) async {
  try {
    await action();
  } on Object {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).operationFailed)));
    }
  }
}
