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

import 'package:wallet_app/app/bloc/theme_bloc.dart';
import 'package:wallet_app/app/bloc/theme_state.dart';
import 'package:wallet_app/app/router.dart';
import 'package:wallet_app/app/theme.dart';

class WalletApp extends StatelessWidget {
  WalletApp({super.key});

  final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'CBE Wallet',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
