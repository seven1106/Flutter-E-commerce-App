import 'package:emigo/core/common/bottom_bar.dart';
import 'package:emigo/features/auth/screens/auth_screen.dart';
import 'package:emigo/features/auth/services/auth_service.dart';
import 'package:emigo/features/vendor/screens/vendor_screen.dart';
import 'package:emigo/providers/user-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/theme/theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emigo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      home: Provider.of<UserProvider>(context).user.token.isEmpty
          ? Provider.of<UserProvider>(context).user.type == 'user'
              ? const BottomBar()
              : const VendorScreen()
          : const AuthScreen(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
