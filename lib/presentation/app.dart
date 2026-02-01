import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/encryption_service.dart';
import '../core/services/database_service.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

/// メインアプリケーション
class KokosidApp extends StatelessWidget {
  const KokosidApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Kokosid',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        locale: const Locale('ja', 'JP'),
        supportedLocales: const [
          Locale('ja', 'JP'),
          Locale('en', 'US'),
        ],
      );
}
