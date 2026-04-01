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

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wallet_app/app/router.dart';
import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/app/theme_cubit.dart';

class WalletApp extends StatelessWidget {
  WalletApp({super.key});

  final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'CBE Wallet',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
