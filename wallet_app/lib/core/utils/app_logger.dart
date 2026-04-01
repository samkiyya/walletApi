/// {@template app_logger}
/// Centralized, structured application logger.
///
/// Architecture rule: No `print()` calls anywhere in the codebase.
/// All log output MUST flow through [AppLogger].
///
/// Log levels (in order of severity):
/// - [debug]   → Verbose dev-only information
/// - [info]    → Normal flow milestones (network, navigation)
/// - [warning] → Non-fatal anomalies (cache miss, retry)
/// - [error]   → Failures and exceptions
/// {@endtemplate}
library;

import 'package:flutter/foundation.dart';

/// ANSI color codes only render in terminals that support them (Android Studio,
/// VS Code integrated terminal, macOS/Linux. Excluded on Windows plain cmd).
class AppLogger {
  AppLogger._();

  static const _tag = 'CBEWallet';

  // ── Log Level Guards ──────────────────────────────────────────────

  /// Verbose developer information. Stripped entirely in release builds.
  static void debug(String message, {String? tag}) {
    if (!kDebugMode) return;
    _log('🐛', 'DEBUG', tag ?? _tag, message);
  }

  /// Normal operational milestones. Stripped in release builds.
  static void info(String message, {String? tag}) {
    if (!kDebugMode) return;
    _log('ℹ️ ', 'INFO ', tag ?? _tag, message);
  }

  /// Non-fatal anomalies. Visible in debug & profile builds.
  static void warning(String message, {String? tag, Object? error}) {
    if (kReleaseMode) return;
    _log('⚠️ ', 'WARN ', tag ?? _tag, message);
    if (error != null) _log('⚠️ ', 'WARN ', tag ?? _tag, '  ↳ $error');
  }

  /// Failures and exceptions. Always visible in all build modes.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('🔴', 'ERROR', tag ?? _tag, message);
    if (error != null) _log('🔴', 'ERROR', tag ?? _tag, '  ↳ $error');
    if (stackTrace != null && kDebugMode) {
      debugPrintStack(stackTrace: stackTrace, label: '  Stack');
    }
  }

  // ── Network-Specific Helpers ──────────────────────────────────────

  /// Logs an outgoing HTTP request cleanly.
  static void request(String method, String path, {Object? body}) {
    if (!kDebugMode) return;
    _log('🌐', 'REQ  ', 'Network', '[$method] $path');
    if (body != null) _log('🌐', 'REQ  ', 'Network', '  ↳ $body');
  }

  /// Logs an HTTP response cleanly.
  static void response(
    int statusCode,
    String path, {
    Object? body,
    Duration? duration,
  }) {
    if (!kDebugMode) return;
    final durationStr = duration != null
        ? ' (${duration.inMilliseconds}ms)'
        : '';
    final icon = statusCode < 400 ? '✅' : '❌';
    _log(icon, 'RES  ', 'Network', '[$statusCode] $path$durationStr');
    if (body != null) _log(icon, 'RES  ', 'Network', '  ↳ $body');
  }

  // ── Core Output ───────────────────────────────────────────────────

  static void _log(String icon, String level, String tag, String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint('$icon [$timestamp][$level][$tag] $message');
  }
}
