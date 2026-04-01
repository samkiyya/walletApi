/// {@template cbe_app_bar}
/// A consistent, standardized [AppBar] for the CBE design system.
///
/// Use this for inner pages that don't need a large hero section.
/// Automatically includes the global theme toggle button.
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:wallet_app/core/presentation/widgets/theme_toggle_button.dart';

class CbeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showThemeToggle;

  const CbeAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showThemeToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        ...?actions,
        if (showThemeToggle) const ThemeToggleButton(),
        const SizedBox(width: 8), // Standard trailing padding
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
