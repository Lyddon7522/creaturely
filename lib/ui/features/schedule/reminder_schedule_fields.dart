import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models.dart';
import '../../../l10n/app_strings.dart';
import '../../core/widgets.dart';

class ReminderScheduleFields extends StatelessWidget {
  const ReminderScheduleFields({
    required this.recurrence,
    required this.weekdays,
    required this.times,
    required this.keyPrefix,
    required this.onRecurrence,
    required this.onWeekday,
    required this.onAddTime,
    required this.onRemoveTime,
    super.key,
  });

  final ReminderRecurrence recurrence;
  final Set<int> weekdays;
  final List<LocalClockTime> times;
  final String keyPrefix;
  final ValueChanged<ReminderRecurrence> onRecurrence;
  final void Function(int, bool) onWeekday;
  final VoidCallback onAddTime;
  final ValueChanged<LocalClockTime> onRemoveTime;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DropdownButtonFormField<ReminderRecurrence>(
        initialValue: recurrence,
        decoration: InputDecoration(labelText: AppLocalizations.of(context).repeat),
        items: [
          DropdownMenuItem(
            value: ReminderRecurrence.daily,
            child: Text(AppLocalizations.of(context).everyDay),
          ),
          DropdownMenuItem(
            value: ReminderRecurrence.selectedWeekdays,
            child: Text(AppLocalizations.of(context).selectedWeekdays),
          ),
        ],
        onChanged: (value) {
          if (value != null) onRecurrence(value);
        },
      ),
      if (recurrence == ReminderRecurrence.selectedWeekdays) ...[
        const SizedBox(height: 14),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var day = 1; day <= 7; day++)
              FilterChip(
                key: ValueKey('${keyPrefix}_weekday_$day'),
                label: Text(
                  DateFormat.E(Localizations.localeOf(context).toLanguageTag())
                      .format(DateTime(2026, 6, day)),
                ),
                selected: weekdays.contains(day),
                onSelected: (value) => onWeekday(day, value),
              ),
          ],
        ),
      ],
      const SizedBox(height: 22),
      SectionHeading(
        AppLocalizations.of(context).reminderTimes,
        trailing: TextButton.icon(
          key: ValueKey('add_${keyPrefix}_time'),
          onPressed: onAddTime,
          icon: const Icon(Icons.add_alarm_rounded),
          label: Text(AppLocalizations.of(context).addTime),
        ),
      ),
      if (times.isEmpty)
        Text(AppLocalizations.of(context).addAtLeastOneTime)
      else
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final time in times)
              InputChip(
                key: ValueKey('${keyPrefix}_time_${time.encoded}'),
                label: Text(_formatTime(context, time)),
                deleteButtonTooltipMessage: AppLocalizations.of(context)
                    .remove(_formatTime(context, time)),
                onDeleted: () => onRemoveTime(time),
              ),
          ],
        ),
    ],
  );

  String _formatTime(BuildContext context, LocalClockTime time) =>
      MaterialLocalizations.of(context)
          .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute));
}
