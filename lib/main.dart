import 'package:flutter/material.dart';

import 'controllers/settings_controller.dart';
import 'models/app_settings.dart';
import 'screens/chess_clock_screen.dart';

void main() => runApp(ChessTimerApp(settings: SettingsController()));

class ChessTimerApp extends StatelessWidget {
  const ChessTimerApp({super.key, required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    // Rebuilds the whole app theme when the user picks new colors.
    return ValueListenableBuilder<AppSettings>(
      valueListenable: settings,
      builder: (context, value, _) {
        return MaterialApp(
          title: 'Chess Timer',
          debugShowCheckedModeBanner: false,
          theme: value.theme.toThemeData(),
          home: ChessClockScreen(settings: settings),
        );
      },
    );
  }
}
