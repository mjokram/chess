import 'package:flutter/material.dart';

import '../utils/time_format.dart';

/// The content inside a clock: name, big time, progress bar, moves, hint.
class ClockFace extends StatelessWidget {
  const ClockFace({
    super.key,
    required this.label,
    required this.time,
    required this.moves,
    required this.progress,
    required this.hint,
    required this.color,
    this.showTrophy = false,
  });

  final String label;
  final Duration time;
  final int moves;
  final double progress;
  final String hint;
  final Color color;
  final bool showTrophy;

  @override
  Widget build(BuildContext context) {
    final small = TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showTrophy) ...[
              Icon(Icons.emoji_events, color: color, size: 20),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: small,
              ),
            ),
          ],
        ),
        Expanded(
          child: FittedBox(
            child: Text(
              formatTime(time),
              style: TextStyle(
                color: color,
                fontSize: 100,
                fontWeight: FontWeight.bold,
                // Equal-width digits so numbers don't jiggle.
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            color: color,
            backgroundColor: color.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Moves: $moves', style: small.copyWith(fontSize: 13)),
            const Spacer(),
            AnimatedOpacity(
              opacity: hint.isEmpty ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: Text(hint, style: small.copyWith(fontSize: 13)),
            ),
          ],
        ),
      ],
    );
  }
}
