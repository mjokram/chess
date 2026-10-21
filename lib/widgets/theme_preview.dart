import 'package:flutter/material.dart';

import '../models/clock_theme.dart';

/// A tiny picture of the clock screen drawn in a theme's colors.
class ThemePreview extends StatelessWidget {
  const ThemePreview({super.key, required this.theme});

  final ClockTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Top player: inactive and rotated, like the real screen.
          Expanded(
            child: _MiniClock(
              color: theme.inactiveColor,
              textColor: theme.inactiveText,
              time: '05:00',
              flipped: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniButton(color: theme.accent),
                const SizedBox(width: 5),
                _MiniButton(color: theme.accent),
              ],
            ),
          ),
          // Bottom player: active, with the glow.
          Expanded(
            child: _MiniClock(
              color: theme.activeColor,
              textColor: theme.activeText,
              time: '04:32',
              glow: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniClock extends StatelessWidget {
  const _MiniClock({
    required this.color,
    required this.textColor,
    required this.time,
    this.flipped = false,
    this.glow = false,
  });

  final Color color;
  final Color textColor;
  final String time;
  final bool flipped;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: glow
            ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: FittedBox(
          child: Text(
            time,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
    return flipped ? RotatedBox(quarterTurns: 2, child: box) : box;
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
