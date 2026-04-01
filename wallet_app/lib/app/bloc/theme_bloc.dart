/// {@template theme_bloc}
/// Manages the application's visual theme mode (light / dark / system).
///
/// Persists user preference to Hive `settings` box so the chosen
/// theme survives app restarts. Falls back to [ThemeMode.system]
/// when no preference is stored.
///
/// Follows the same `Bloc<Event, State>` architecture as
/// [WalletBloc] and [TransactionBloc].
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:wallet_app/app/bloc/theme_event.dart';
import 'package:wallet_app/app/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _boxName = 'settings';
  static const _themeKey = 'theme_mode';

  ThemeBloc() : super(ThemeState(themeMode: _loadPersistedTheme())) {
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeChanged>(_onThemeChanged);
  }

  // ── Persistence ─────────────────────────────────────────────────────

  /// Loads the persisted theme from Hive synchronously.
  /// Returns [ThemeMode.system] if nothing is stored.
  static ThemeMode _loadPersistedTheme() {
    if (!Hive.isBoxOpen(_boxName)) return ThemeMode.system;

    final box = Hive.box(_boxName);
    final saved = box.get(_themeKey) as String?;

    if (saved == 'light') return ThemeMode.light;
    if (saved == 'dark') return ThemeMode.dark;

    return ThemeMode.system;
  }

  /// Writes the theme mode to Hive for persistence.
  void _persist(ThemeMode mode) {
    if (!Hive.isBoxOpen(_boxName)) return;

    final box = Hive.box(_boxName);
    if (mode == ThemeMode.system) {
      box.delete(_themeKey);
    } else {
      box.put(_themeKey, mode.name);
    }
  }

  // ── Event Handlers ──────────────────────────────────────────────────

  void _onThemeToggled(ThemeToggled event, Emitter<ThemeState> emit) {
    final current = state.themeMode;
    late final ThemeMode next;

    if (current == ThemeMode.system) {
      // Resolve system to explicit, then flip.
      // Default to dark if we can't determine platform brightness.
      next = ThemeMode.dark;
    } else if (current == ThemeMode.light) {
      next = ThemeMode.dark;
    } else {
      next = ThemeMode.light;
    }

    _persist(next);
    emit(ThemeState(themeMode: next));
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    _persist(event.mode);
    emit(ThemeState(themeMode: event.mode));
  }
}
