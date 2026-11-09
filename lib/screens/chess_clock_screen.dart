import 'package:flutter/material.dart';

import '../controllers/chess_clock_controller.dart';
import '../controllers/settings_controller.dart';
import '../models/app_settings.dart';
import '../models/player.dart';
import '../widgets/clock_controls.dart';
import '../widgets/player_clock.dart';
import '../widgets/reset_dialog.dart';
import 'settings_screen.dart';

/// Main screen: Player 2 clock (rotated), controls, Player 1 clock.
class ChessClockScreen extends StatefulWidget {
  const ChessClockScreen({super.key, required this.settings});

  final SettingsController settings;

  @override
  State<ChessClockScreen> createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends State<ChessClockScreen>
    with WidgetsBindingObserver {
  late final ChessClockController _clock = ChessClockController(
    initialControl: widget.settings.value.timeControl,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Auto-pause when the app goes to the background.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _clock.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _clock.dispose();
    super.dispose();
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(settings: widget.settings),
      ),
    );
    if (!mounted) return;

    // Apply the time control picked in Settings (only before a game).
    final chosen = widget.settings.value.timeControl;
    if (!_clock.started && _clock.control != chosen) {
      _clock.setTimeControl(chosen);
    }
  }

  Future<void> _onReset() async {
    // No need to confirm once the game is over.
    if (!_clock.finished) {
      final confirmed = await showResetDialog(context);
      if (!confirmed || !mounted) return;
    }
    _clock.reset();
  }

  Widget _clockFor(Player player, AppSettings settings) {
    final c = _clock;
    final isActive = c.active == player && !c.finished;

    String hint = '';
    if (!c.started) hint = 'Tap to start';
    if (isActive && c.running) hint = 'Your move';

    return PlayerClock(
      name: settings.nameOf(player),
      theme: settings.theme,
      time: c.timeFor(player),
      moves: c.movesFor(player),
      progress: c.progressFor(player),
      isActive: isActive,
      isRunning: c.running,
      isLoser: c.loser == player,
      isWinner: c.finished && c.loser != player,
      hint: hint,
      canTap: !c.finished && !c.paused && (!c.started || isActive),
      bonusText: c.lastBonusPlayer == player
          ? '+${c.control.increment.inSeconds}s'
          : null,
      bonusCount: c.bonusCount,
      flipped: player == Player.two,
      onTap: () => c.tapClock(player),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_clock, widget.settings]),
      builder: (context, _) {
        final settings = widget.settings.value;
        return Scaffold(
          backgroundColor: settings.theme.background,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: _clockFor(Player.two, settings)),
                ClockControls(
                  controller: _clock,
                  settings: settings,
                  onSettings: _openSettings,
                  onReset: _onReset,
                ),
                Expanded(child: _clockFor(Player.one, settings)),
              ],
            ),
          ),
        );
      },
    );
  }
}
