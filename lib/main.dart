import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/database_service.dart';
import 'core/services/encryption_service.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // サービスの初期化
  final encryptionService = EncryptionService();
  final databaseService = DatabaseService();

  await encryptionService.initialize();
  await databaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<EncryptionService>.value(value: encryptionService),
        Provider<DatabaseService>.value(value: databaseService),
      ],
      child: const KokosidApp(),
    ),
  );
}
