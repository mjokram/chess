import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';
import '../models/player.dart';

/// Two text fields for renaming Player 1 and Player 2.
class PlayerNamesSection extends StatefulWidget {
  const PlayerNamesSection({super.key, required this.settings});

  final SettingsController settings;

  @override
  State<PlayerNamesSection> createState() => _PlayerNamesSectionState();
}

class _PlayerNamesSectionState extends State<PlayerNamesSection> {
  late final TextEditingController _player1 = TextEditingController(
    text: widget.settings.value.player1Name,
  );
  late final TextEditingController _player2 = TextEditingController(
    text: widget.settings.value.player2Name,
  );

  @override
  void dispose() {
    _player1.dispose();
    _player2.dispose();
    super.dispose();
  }

  Widget _field(TextEditingController controller, Player player, String hint) {
    return TextField(
      controller: controller,
      maxLength: 16,
      decoration: InputDecoration(
        labelText: '${player.defaultName} name',
        helperText: hint,
        prefixIcon: const Icon(Icons.person_outline),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) => widget.settings.setName(player, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field(_player1, Player.one, 'Bottom clock'),
        const SizedBox(height: 8),
        _field(_player2, Player.two, 'Top clock'),
      ],
    );
  }
}
