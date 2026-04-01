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
      routerConfig: _router,
    );
  }
}
