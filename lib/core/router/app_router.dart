import 'package:emigo/core/common/user_screen.dart';
import 'package:emigo/features/home/screens/home_screen.dart';
import 'package:emigo/features/home/screens/product_category.dart';
import 'package:emigo/features/product/screens/product_detail_screen.dart';
import 'package:emigo/features/search/screen/search_screen.dart';
import 'package:emigo/features/vendor/screens/product/add_product_screen.dart';
import 'package:emigo/features/vendor/screens/vendor_screen.dart';
import 'package:emigo/models/product_model.dart';
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
        return _materialRoute(const UserScreen());
      case '/vendor':
        return _materialRoute(const VendorScreen());
      case '/add-product':
        return _materialRoute(const AddProductScreen());
      case '/product-category':
        return _materialRoute(ProductCategory(category: settings.arguments as String));
      case '/search-screen':
        return _materialRoute(SearchScreen(searchQuery: settings.arguments as String));
      case '/product-details':
        return _materialRoute(ProductDetailScreen(product: settings.arguments as ProductModel));
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
