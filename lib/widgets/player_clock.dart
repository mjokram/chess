import 'package:flutter/material.dart';

import '../models/clock_theme.dart';
import 'clock_face.dart';
import 'increment_popup.dart';
import 'pressable.dart';

/// One player's tappable clock. [flipped] rotates it 180 degrees.
class PlayerClock extends StatelessWidget {
  const PlayerClock({
    super.key,
    required this.name,
    required this.theme,
    required this.time,
    required this.moves,
    required this.progress,
    required this.isActive,
    required this.isRunning,
    required this.isLoser,
    required this.isWinner,
    required this.hint,
    required this.canTap,
    required this.onTap,
    this.bonusText,
    this.bonusCount = 0,
    this.flipped = false,
  });

  final String name;
  final ClockTheme theme;
  final Duration time;
  final int moves;
  final double progress;
  final bool isActive;
  final bool isRunning;
  final bool isLoser;
  final bool isWinner;
  final String hint;
  final bool canTap;
  final VoidCallback onTap;
  final String? bonusText;
  final int bonusCount;
  final bool flipped;

  ({Color bg, Color fg}) _colors() {
    if (isLoser) return (bg: Colors.red.shade900, fg: Colors.white);
    if (!isActive) return (bg: theme.inactiveColor, fg: theme.inactiveText);

    if (time < const Duration(seconds: 10)) {
      // Flash between two reds every half second while running.
      final flash = isRunning && time.inMilliseconds % 1000 < 500;
      return (bg: flash ? Colors.red.shade700 : Colors.red, fg: Colors.white);
    }
    return (bg: theme.activeColor, fg: theme.activeText);
  }

  String get _label {
    if (isLoser) return '$name - TIME OUT';
    if (isWinner) return '$name WINS';
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors();

    final clock = Pressable(
      enabled: canTap,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive && !isLoser
              ? [
                  BoxShadow(
                    color: colors.bg.withValues(alpha: 0.5),
                    blurRadius: 24,
                    spreadRadius: 1,
                  ),
                ]
              : const [],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClockFace(
              label: _label,
              time: time,
              moves: moves,
              progress: progress,
              hint: hint,
              color: colors.fg,
              showTrophy: isWinner,
            ),
            if (bonusText != null)
              Positioned(
                top: 0,
                right: 0,
                child: IncrementPopup(
                  key: ValueKey(bonusCount),
                  text: bonusText!,
                  color: colors.fg,
                ),
              ),
          ],
        ),
      ),
    );

    return flipped ? RotatedBox(quarterTurns: 2, child: clock) : clock;
  }
}
