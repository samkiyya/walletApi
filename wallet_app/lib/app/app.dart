/// {@template wallet_app}
/// Root widget for the CBE Wallet App.
///
/// Configures:
/// - [MaterialApp.router] with GoRouter for declarative navigation
/// - CBE branded light theme
/// - Global app-level settings (title, debug banner)
/// {@endtemplate}
library;

import 'package:flutter/material.dart';

import 'package:wallet_app/app/router.dart';
import 'package:wallet_app/app/theme.dart';

class WalletApp extends StatelessWidget {
  WalletApp({super.key});

  final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CBE Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
