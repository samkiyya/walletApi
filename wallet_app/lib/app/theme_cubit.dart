library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _boxName = 'settings';
  static const _themeKey = 'theme_mode';

  ThemeCubit() : super(_loadTheme());

  static ThemeMode _loadTheme() {
    // If the box isn't open, default to system
    if (!Hive.isBoxOpen(_boxName)) return ThemeMode.system;
    
    final box = Hive.box(_boxName);
    final savedTheme = box.get(_themeKey) as String?;
    
    if (savedTheme == 'light') return ThemeMode.light;
    if (savedTheme == 'dark') return ThemeMode.dark;
    
    // Fallback to system if nothing is saved
    return ThemeMode.system;
  }

  void setTheme(ThemeMode mode) {
    if (Hive.isBoxOpen(_boxName)) {
      if (mode == ThemeMode.system) {
        Hive.box(_boxName).delete(_themeKey);
      } else {
        Hive.box(_boxName).put(_themeKey, mode.name);
      }
    }
    emit(mode);
  }

  /// Toggles the theme prioritizing direct user preference over system
  void toggleTheme(BuildContext context) {
    if (state == ThemeMode.system) {
      // If currently system, resolve what system is right now and explicitly switch to the opposite
      final brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        setTheme(ThemeMode.light);
      } else {
        setTheme(ThemeMode.dark);
      }
    } else if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}
