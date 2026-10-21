import 'package:flutter/material.dart';

import '../models/clock_theme.dart';
import 'theme_preview.dart';

/// Grid of theme preview cards. Tap one to select it.
class ThemePicker extends StatelessWidget {
  const ThemePicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ClockTheme selected;
  final ValueChanged<ClockTheme> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 330 ? 2 : 3;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.6,
          children: [
            for (final theme in ClockTheme.all)
              _ThemeCard(
                theme: theme,
                selected: theme.name == selected.name,
                onTap: () => onSelected(theme),
              ),
          ],
        );
      },
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  final ClockTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.0 : 0.95,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 3 : 1,
            ),
          ),
          child: Column(
            children: [
              Expanded(child: ThemePreview(theme: theme)),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selected) ...[
                    Icon(Icons.check_circle, size: 16, color: scheme.primary),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      theme.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
