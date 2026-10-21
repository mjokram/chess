import 'package:flutter/material.dart';

/// Returns true only if the user confirms the reset.
Future<bool> showResetDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.restart_alt),
      title: const Text('Reset game?'),
      content: const Text(
        'Both clocks and move counters will go back to the starting time.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  return result ?? false;
}
