import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'presentation/screens/splash_screen.dart';

class LovePoemsApp extends StatelessWidget {
  const LovePoemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love Poems',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
