/// {@template theme_state}
/// State emitted by [ThemeBloc].
///
/// Wraps [ThemeMode] in an Equatable class matching the sealed-state
/// pattern used throughout the application.
/// {@endtemplate}
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  /// Factory for the initial state, defaulting to system theme.
  const ThemeState.initial() : themeMode = ThemeMode.system;

  @override
  List<Object?> get props => [themeMode];
}
