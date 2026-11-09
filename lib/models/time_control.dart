/// Base time + increment. Example: 5+3 = 5 minutes, +3 seconds per move.
class TimeControl {
  const TimeControl({required this.base, this.increment = Duration.zero});

  final Duration base;
  final Duration increment;

  /// Short label like "5+3" or "2:30+1".
  String get label {
    final minutes = base.inMinutes;
    final seconds = base.inSeconds % 60;
    final baseText = seconds == 0
        ? '$minutes'
        : '$minutes:${seconds.toString().padLeft(2, '0')}';
    return '$baseText+${increment.inSeconds}';
  }

  /// Same idea Lichess uses: base seconds + 40 x increment.
  String get category {
    final estimate = base.inSeconds + 40 * increment.inSeconds;
    if (estimate < 180) return 'Bullet';
    if (estimate < 480) return 'Blitz';
    if (estimate < 1500) return 'Rapid';
    return 'Classical';
  }

  static TimeControl _preset(int minutes, int increment) {
    return TimeControl(
      base: Duration(minutes: minutes),
      increment: Duration(seconds: increment),
    );
  }

  static final List<TimeControl> presets = [
    _preset(1, 0),
    _preset(2, 1),
    _preset(3, 0),
    _preset(3, 2),
    _preset(5, 0),
    _preset(5, 3),
    _preset(10, 0),
    _preset(10, 5),
    _preset(15, 10),
    _preset(30, 0),
  ];

  /// 5+0 Blitz.
  static TimeControl get defaultControl => presets[4];

  @override
  bool operator ==(Object other) =>
      other is TimeControl &&
      other.base == base &&
      other.increment == increment;

  @override
  int get hashCode => Object.hash(base, increment);
}
