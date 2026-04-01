import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:wallet_app/app/app.dart';
import 'package:wallet_app/core/utils/app_logger.dart';
import 'package:wallet_app/di/injection_container.dart';

Future<void> main() async {
  // 1. Ensure Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('=== CBE Wallet App Starting ===', tag: 'Bootstrap');

  // 2. Preferred orientations — mobile-first layout
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 3. System UI overlay style — transparent status bar for edge-to-edge design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // 4. Initialize Hive for offline persistence
  AppLogger.info('Initializing Hive...', tag: 'Bootstrap');
  await Hive.initFlutter();
  await Hive.openBox('settings');
  AppLogger.info('Hive ready.', tag: 'Bootstrap');

  // 5. Register all dependencies (Dio, DataSources, Repos, UseCases, BLoCs)
  AppLogger.info('Initializing dependencies...', tag: 'Bootstrap');
  await initializeDependencies();
  AppLogger.info('All dependencies registered.', tag: 'Bootstrap');

  AppLogger.info('=== Launching WalletApp ===', tag: 'Bootstrap');

  // 6. Launch the app
  runApp(WalletApp());
}
