import 'package:emigo/core/common/user_screen.dart';
import 'package:emigo/features/address/screens/address_screen.dart';
import 'package:emigo/features/home/screens/home_screen.dart';
import 'package:emigo/features/home/screens/product_category.dart';
import 'package:emigo/features/product/screens/product_detail_screen.dart';
import 'package:emigo/features/search/screen/search_screen.dart';
import 'package:emigo/features/vendor/screens/product/add_product_screen.dart';
import 'package:emigo/features/vendor/screens/vendor_screen.dart';
import 'package:emigo/models/order.dart';
import 'package:emigo/models/product_model.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/cart/screens/checkout_screen.dart';
import '../../features/order_details/screens/order_details.dart';
import '../../features/vendor/screens/orders_screen.dart';
import '../../features/vendor/screens/product/edit_product.dart';
import '../../features/vendor/screens/voucher/add_voucher.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';

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
      case '/edit-product':
        return _materialRoute(
            EditProductScreen(product: settings.arguments as ProductModel));
      case '/product-category':
        return _materialRoute(
            ProductCategory(category: settings.arguments as String));
      case '/search-screen':
        return _materialRoute(
            SearchScreen(searchQuery: settings.arguments as String));
      case '/product-details':
        return _materialRoute(
            ProductDetailScreen(product: settings.arguments as ProductModel));
      case '/address':
        return _materialRoute(
            const AddressScreen());
      case '/order-details':
        return _materialRoute(
            OrderDetailScreen(order: settings.arguments as OrderModel));
        case '/order-screen':
        return _materialRoute(
            const OrdersScreen());
        case '/add-voucher':
        return _materialRoute(
            const AddVoucherScreen());
        case '/checkout':
        return _materialRoute(
             CheckoutScreen(totalAmount: settings.arguments as String,));
        case '/wishlist':
        return _materialRoute(
            const WishlistScreen());
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
