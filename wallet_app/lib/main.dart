import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:wallet_app/app/app.dart';
import 'package:wallet_app/di/injection_container.dart';

Future<void> main() async {
  // 1. Ensure Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Hive for offline persistence
  await Hive.initFlutter();
  await Hive.openBox('settings');

  // 3. Register all dependencies (Dio, DataSources, Repos, UseCases, BLoCs)
  await initializeDependencies();

  // 4. Launch the app
  runApp(WalletApp());
}
