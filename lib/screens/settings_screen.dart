import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';
import '../models/app_settings.dart';
import '../models/time_control.dart';
import '../widgets/custom_time_dialog.dart';
import '../widgets/player_names_section.dart';
import '../widgets/theme_picker.dart';
import '../widgets/time_control_selector.dart';

/// Time control, player names, and theme colors.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settings});

  final SettingsController settings;

  Future<void> _openCustom(BuildContext context, TimeControl current) async {
    final control = await showCustomTimeDialog(context, current);
    if (control != null) settings.setTimeControl(control);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettings>(
      valueListenable: settings,
      builder: (context, s, _) {
        final control = s.timeControl;
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionTitle(
                title: 'Time control',
                trailing: '${control.label} · ${control.category}',
              ),
              TimeControlSelector(
                presets: TimeControl.presets,
                selected: control,
                onSelected: settings.setTimeControl,
                onCustom: () => _openCustom(context, control),
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Player names'),
              PlayerNamesSection(settings: settings),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Theme colors', trailing: s.theme.name),
              ThemePicker(selected: s.theme, onSelected: settings.setTheme),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

/// Section heading with an optional value shown on the right.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const Spacer(),
          if (trailing != null)
            Text(
              trailing!,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
