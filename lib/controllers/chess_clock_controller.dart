import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/player.dart';
import '../models/time_control.dart';

/// Holds all the chess clock logic. The UI only reads from it.
class ChessClockController extends ChangeNotifier {
  static const Duration _tick = Duration(milliseconds: 100);

  TimeControl _control;
  final Map<Player, Duration> _time = {};
  final Map<Player, int> _moves = {};
  Player? _active; // null = game not started
  Player? _loser; // set when someone runs out of time
  Player? _lastBonusPlayer; // who got the latest increment
  int _bonusCount = 0; // changes every increment, used to replay the animation
  bool _paused = false;
  bool _disposed = false;
  Timer? _timer;

  ChessClockController({TimeControl? initialControl})
    : _control = initialControl ?? TimeControl.defaultControl {
    _restore();
  }

  // ---------- Getters for the UI ----------

  TimeControl get control => _control;
  Player? get active => _active;
  Player? get loser => _loser;
  Player? get lastBonusPlayer => _lastBonusPlayer;
  int get bonusCount => _bonusCount;
  bool get paused => _paused;
  bool get started => _active != null;
  bool get finished => _loser != null;
  bool get running => started && !_paused && !finished;

  Duration timeFor(Player p) => _time[p] ?? Duration.zero;
  int movesFor(Player p) => _moves[p] ?? 0;

  /// 1.0 = full starting time, 0.0 = no time left.
  double progressFor(Player p) {
    final total = _control.base.inMilliseconds;
    if (total <= 0) return 0;
    return (timeFor(p).inMilliseconds / total).clamp(0.0, 1.0).toDouble();
  }

  // ---------- Actions ----------

  /// Start button: Player 1 moves first, so Player 1's clock runs.
  void start() {
    if (started) return;
    _active = Player.one;
    _startTimer();
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void tapClock(Player player) {
    if (finished || _paused) return;

    // First tap starts the opponent's clock.
    if (!started) {
      _active = player.opponent;
      _startTimer();
      HapticFeedback.mediumImpact();
      notifyListeners();
      return;
    }

    // Only the running clock can be pressed.
    if (player != _active) return;

    _moves[player] = movesFor(player) + 1;
    _applyIncrement(player);
    _active = player.opponent;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void pause() {
    if (!running) return;
    _paused = true;
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (!_paused || finished) return;
    _paused = false;
    _startTimer();
    notifyListeners();
  }

  void togglePause() => _paused ? resume() : pause();

  void reset() {
    _timer?.cancel();
    _restore();
    notifyListeners();
  }

  void setTimeControl(TimeControl control) {
    if (started) return; // no changes during a game
    _control = control;
    reset();
  }

  // ---------- Internal ----------

  void _applyIncrement(Player player) {
    final increment = _control.increment;
    if (increment <= Duration.zero) return;
    _time[player] = timeFor(player) + increment;
    _lastBonusPlayer = player;
    _bonusCount++;
  }

  void _restore() {
    for (final p in Player.values) {
      _time[p] = _control.base;
      _moves[p] = 0;
    }
    _active = null;
    _loser = null;
    _lastBonusPlayer = null;
    _paused = false;
  }

  void _startTimer() {
    _timer?.cancel(); // never allow two timers
    _timer = Timer.periodic(_tick, (_) => _countDown());
  }

  void _countDown() {
    final player = _active;
    if (_disposed || player == null || !running) return;

    _time[player] = timeFor(player) - _tick;
    if (timeFor(player) <= Duration.zero) {
      _time[player] = Duration.zero;
      _loser = player;
      _timer?.cancel();
      HapticFeedback.vibrate();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
