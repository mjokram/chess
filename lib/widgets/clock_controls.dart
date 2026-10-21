import 'package:flutter/material.dart';

import '../controllers/chess_clock_controller.dart';
import '../models/app_settings.dart';

/// Middle bar: status text, plus setup or in-game buttons.
class ClockControls extends StatelessWidget {
  const ClockControls({
    super.key,
    required this.controller,
    required this.settings,
    required this.onSettings,
    required this.onReset,
  });

  final ChessClockController controller;
  final AppSettings settings;
  final VoidCallback onSettings;
  final VoidCallback onReset;

  String _statusText() {
    final c = controller;
    if (c.finished) return '${settings.nameOf(c.loser!.opponent)} WINS!';
    if (c.paused) return 'PAUSED';
    if (c.started) return "${settings.nameOf(c.active!)}'s turn";
    return 'Ready';
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusText();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              status,
              key: ValueKey(status),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.started ? _gameButtons() : _setupButtons(),
          ),
        ],
      ),
    );
  }

  Widget _setupButtons() {
    final control = controller.control;
    return Wrap(
      key: const ValueKey('setup'),
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        // Tapping the current time control opens Settings to change it.
        ActionChip(
          avatar: const Icon(Icons.timer_outlined, size: 18),
          label: Text('${control.label} · ${control.category}'),
          onPressed: onSettings,
        ),
        IconButton.filledTonal(
          onPressed: onSettings,
          tooltip: 'Settings',
          icon: const Icon(Icons.settings),
        ),
        FilledButton.icon(
          onPressed: controller.start,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start'),
        ),
      ],
    );
  }

  Widget _gameButtons() {
    return Row(
      key: const ValueKey('game'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!controller.finished) ...[
          IconButton.filled(
            onPressed: controller.togglePause,
            iconSize: 28,
            tooltip: controller.paused ? 'Resume' : 'Pause',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                controller.paused ? Icons.play_arrow : Icons.pause,
                key: ValueKey(controller.paused),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        IconButton.filledTonal(
          onPressed: onReset,
          iconSize: 28,
          tooltip: 'Reset',
          icon: const Icon(Icons.restart_alt),
        ),
      ],
    );
  }
}
