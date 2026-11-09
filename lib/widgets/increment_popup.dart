import 'package:flutter/material.dart';

/// A "+3s" label that floats up and fades out.
/// Give it a new key each time to replay the animation.
class IncrementPopup extends StatelessWidget {
  const IncrementPopup({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
      builder: (context, t, child) {
        return Opacity(
          opacity: 1 - t,
          child: Transform.translate(offset: Offset(0, -20 * t), child: child),
        );
      },
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
