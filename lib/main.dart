import 'package:emigo/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';

import 'core/config/theme/theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emigo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      home: const AuthScreen(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

