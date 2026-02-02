import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/app_config_service.dart';
import 'core/services/database_service.dart';
import 'core/services/encryption_service.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 環境変数の初期化（.env.local を優先）
  final appConfig = AppConfigService();
  await appConfig.initialize();

  // サービスの初期化
  final encryptionService = EncryptionService();
  final databaseService = DatabaseService();

  await encryptionService.initialize();
  await databaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppConfigService>.value(value: appConfig),
        Provider<EncryptionService>.value(value: encryptionService),
        Provider<DatabaseService>.value(value: databaseService),
      ],
      child: const KokosidApp(),
    ),
  );
}
