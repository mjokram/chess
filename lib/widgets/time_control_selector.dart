import 'package:flutter/material.dart';

import '../models/time_control.dart';

/// Preset chips that wrap onto new lines, plus a Custom chip.
class TimeControlSelector extends StatelessWidget {
  const TimeControlSelector({
    super.key,
    required this.presets,
    required this.selected,
    required this.onSelected,
    required this.onCustom,
  });

  final List<TimeControl> presets;
  final TimeControl selected;
  final ValueChanged<TimeControl> onSelected;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) {
    final isCustom = !presets.contains(selected);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final control in presets)
          ChoiceChip(
            label: Text(control.label),
            selected: control == selected,
            onSelected: (_) => onSelected(control),
          ),
        ChoiceChip(
          avatar: const Icon(Icons.tune, size: 18),
          label: Text(isCustom ? 'Custom ${selected.label}' : 'Custom'),
          selected: isCustom,
          onSelected: (_) => onCustom(),
        ),
      ],
    );
  }
}
