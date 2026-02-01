import 'package:flutter/material.dart';
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
