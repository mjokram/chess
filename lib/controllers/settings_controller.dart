import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../models/clock_theme.dart';
import '../models/player.dart';
import '../models/time_control.dart';

/// Holds the current settings and tells the app when they change.
class SettingsController extends ValueNotifier<AppSettings> {
  SettingsController() : super(const AppSettings());

  void setTimeControl(TimeControl control) {
    value = value.copyWith(timeControl: control);
  }

  void setName(Player player, String name) {
    final clean = name.trim().isEmpty ? player.defaultName : name.trim();
    value = player == Player.one
        ? value.copyWith(player1Name: clean)
        : value.copyWith(player2Name: clean);
  }

  void setTheme(ClockTheme theme) {
    value = value.copyWith(theme: theme);
  }
}
