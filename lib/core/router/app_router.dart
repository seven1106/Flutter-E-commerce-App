import 'package:emigo/core/common/bottom_bar.dart';
import 'package:emigo/features/home/screens/home_screen.dart';
import 'package:emigo/features/vendor/screens/product/add_product_screen.dart';
import 'package:emigo/features/vendor/screens/vendor_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screens/auth_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthScreen.routeName:
        return _materialRoute(const AuthScreen());
      case HomeScreen.routeName:
        return _materialRoute(const HomeScreen());
      case '/bottomBar':
        return _materialRoute(const BottomBar());
      case '/vendor':
        return _materialRoute(const VendorScreen());
      case '/add-product':
        return _materialRoute(const AddProductScreen());
      default:
        return _materialRoute(Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ));
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
