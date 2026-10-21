import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/time_control.dart';

/// Opens the dialog. Returns the new TimeControl, or null if cancelled.
Future<TimeControl?> showCustomTimeDialog(
  BuildContext context,
  TimeControl current,
) {
  return showDialog<TimeControl>(
    context: context,
    builder: (_) => CustomTimeDialog(initial: current),
  );
}

class CustomTimeDialog extends StatefulWidget {
  const CustomTimeDialog({super.key, required this.initial});

  final TimeControl initial;

  @override
  State<CustomTimeDialog> createState() => _CustomTimeDialogState();
}

class _CustomTimeDialogState extends State<CustomTimeDialog> {
  static const List<int> _quickIncrements = [0, 1, 2, 3, 5, 10];

  late final TextEditingController _minutes = TextEditingController(
    text: '${widget.initial.base.inMinutes}',
  );
  late final TextEditingController _seconds = TextEditingController(
    text: '${widget.initial.base.inSeconds % 60}',
  );
  late final TextEditingController _increment = TextEditingController(
    text: '${widget.initial.increment.inSeconds}',
  );

  @override
  void dispose() {
    _minutes.dispose();
    _seconds.dispose();
    _increment.dispose();
    super.dispose();
  }

  /// Returns null when the input is not valid.
  TimeControl? _parse() {
    final m = int.tryParse(_minutes.text) ?? 0;
    final s = int.tryParse(_seconds.text) ?? 0;
    final i = int.tryParse(_increment.text) ?? 0;
    if (m > 180 || s > 59 || i > 60) return null;
    if (m == 0 && s == 0) return null;
    return TimeControl(
      base: Duration(minutes: m, seconds: s),
      increment: Duration(seconds: i),
    );
  }

  Widget _field(TextEditingController controller, String label, String help) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) => setState(() {}), // refresh the preview
      decoration: InputDecoration(
        labelText: label,
        helperText: help,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parsed = _parse();
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Custom Time'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _field(_minutes, 'Minutes', '0-180')),
                const SizedBox(width: 12),
                Expanded(child: _field(_seconds, 'Seconds', '0-59')),
              ],
            ),
            const SizedBox(height: 12),
            _field(
              _increment,
              'Increment (sec)',
              'Added after each move, 0-60',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                for (final inc in _quickIncrements)
                  ActionChip(
                    label: Text('+$inc'),
                    onPressed: () => setState(() => _increment.text = '$inc'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              parsed == null
                  ? 'Enter a valid time.'
                  : 'Preview: ${parsed.label} · ${parsed.category}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: parsed == null ? scheme.error : scheme.primary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: parsed == null
              ? null
              : () => Navigator.of(context).pop(parsed),
          child: const Text('Set'),
        ),
      ],
    );
  }
}
