import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

class CalendarDateField extends StatelessWidget {
  const CalendarDateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.emptyLabel,
    this.onClear,
    this.clearTooltip,
    super.key,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final String? emptyLabel;
  final VoidCallback? onClear;
  final String? clearTooltip;

  @override
  Widget build(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: label),
    child: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  value == null
                      ? emptyLabel ?? AppLocalizations.of(context).chooseDate
                      : MaterialLocalizations.of(context).formatMediumDate(value!),
                ),
              ),
            ),
          ),
        ),
        if (onClear != null)
          IconButton(
            tooltip: clearTooltip ?? AppLocalizations.of(context).clearDate,
            onPressed: onClear,
            icon: const Icon(Icons.clear_rounded),
          ),
      ],
    ),
  );
}
