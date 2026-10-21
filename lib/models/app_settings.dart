import 'clock_theme.dart';
import 'player.dart';
import 'time_control.dart';

/// User settings: time control, player names, and theme colors.
class AppSettings {
  const AppSettings({
    this.timeControl = const TimeControl(base: Duration(minutes: 5)),
    this.player1Name = 'Player 1',
    this.player2Name = 'Player 2',
    this.theme = ClockTheme.classic,
  });

  final TimeControl timeControl;
  final String player1Name;
  final String player2Name;
  final ClockTheme theme;

  String nameOf(Player player) =>
      player == Player.one ? player1Name : player2Name;

  AppSettings copyWith({
    TimeControl? timeControl,
    String? player1Name,
    String? player2Name,
    ClockTheme? theme,
  }) {
    return AppSettings(
      timeControl: timeControl ?? this.timeControl,
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
      theme: theme ?? this.theme,
    );
  }
}
