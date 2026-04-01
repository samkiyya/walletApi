/// {@template theme_event}
/// Events for [ThemeBloc].
///
/// Follows the sealed-class pattern established by [WalletEvent]
/// and [TransactionEvent] in the existing BLoC architecture.
/// {@endtemplate}
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Toggles the theme between light and dark.
///
/// If the current mode is [ThemeMode.system], resolves to the
/// opposite of the current platform brightness before toggling.
final class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

/// Sets an explicit [ThemeMode].
///
/// Used when the user picks a specific mode from a settings menu.
final class ThemeChanged extends ThemeEvent {
  final ThemeMode mode;

  const ThemeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}
