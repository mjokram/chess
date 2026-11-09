import 'package:flutter/material.dart';

/// A set of colors for the clock screen.
class ClockTheme {
  const ClockTheme({
    required this.name,
    required this.background,
    required this.activeColor,
    required this.activeText,
    required this.inactiveColor,
    required this.inactiveText,
    required this.accent,
    this.brightness = Brightness.dark,
  });

  final String name;
  final Color background;
  final Color activeColor;
  final Color activeText;
  final Color inactiveColor;
  final Color inactiveText;
  final Color accent;
  final Brightness brightness;

  /// Material theme for buttons, dialogs, and the settings screen.
  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: background,
    );
  }

  static const classic = ClockTheme(
    name: 'Classic',
    background: Color(0xFF1E1E1E),
    activeColor: Color(0xFFFFFFFF),
    activeText: Color(0xFF000000),
    inactiveColor: Color(0xFF424242),
    inactiveText: Color(0xB3FFFFFF),
    accent: Color(0xFF90A4AE),
  );

  static const wood = ClockTheme(
    name: 'Wood',
    background: Color(0xFF2B1D14),
    activeColor: Color(0xFFF0D9B5),
    activeText: Color(0xFF2B1D14),
    inactiveColor: Color(0xFF6F5238),
    inactiveText: Color(0xFFD9C3A0),
    accent: Color(0xFFB58863),
  );

  static const green = ClockTheme(
    name: 'Green',
    background: Color(0xFF1B2A1B),
    activeColor: Color(0xFF769656),
    activeText: Color(0xFFFFFFFF),
    inactiveColor: Color(0xFF34432C),
    inactiveText: Color(0xFFB8C4A8),
    accent: Color(0xFF769656),
  );

  static const ocean = ClockTheme(
    name: 'Ocean Blue',
    background: Color(0xFF0D1B2A),
    activeColor: Color(0xFF4A90E2),
    activeText: Color(0xFFFFFFFF),
    inactiveColor: Color(0xFF1F3A5A),
    inactiveText: Color(0xFF9FB6CF),
    accent: Color(0xFF4A90E2),
  );

  static const purple = ClockTheme(
    name: 'Purple',
    background: Color(0xFF1A1025),
    activeColor: Color(0xFF9C6ADE),
    activeText: Color(0xFFFFFFFF),
    inactiveColor: Color(0xFF3A2A50),
    inactiveText: Color(0xFFC7B6DD),
    accent: Color(0xFF9C6ADE),
  );

  static const light = ClockTheme(
    name: 'Light',
    background: Color(0xFFF2F2F2),
    activeColor: Color(0xFF212121),
    activeText: Color(0xFFFFFFFF),
    inactiveColor: Color(0xFFDADADA),
    inactiveText: Color(0xFF616161),
    accent: Color(0xFF1976D2),
    brightness: Brightness.light,
  );

  static const List<ClockTheme> all = [
    classic,
    wood,
    green,
    ocean,
    purple,
    light,
  ];
}
