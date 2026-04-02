
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wallet_app/app/bloc/theme_bloc.dart';
import 'package:wallet_app/app/bloc/theme_event.dart';
import 'package:wallet_app/app/bloc/theme_state.dart';

class ThemeToggleButton extends StatelessWidget {
  final Color? color;

  const ThemeToggleButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDark =
            themeState.themeMode == ThemeMode.dark ||
            (themeState.themeMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: color ?? Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () => context.read<ThemeBloc>().add(const ThemeToggled()),
          tooltip: 'Toggle Theme',
        );
      },
    );
  }
}
