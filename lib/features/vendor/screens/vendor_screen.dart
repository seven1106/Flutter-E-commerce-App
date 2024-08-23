import 'package:badges/badges.dart' as badges;
import 'package:emigo/core/config/theme/app_palette.dart';
import 'package:emigo/features/account/screens/account_screen.dart';
import 'package:emigo/features/vendor/screens/product/product_screen.dart';
import 'package:emigo/features/vendor/screens/voucher/voucher_screen.dart';
import 'package:flutter/material.dart';

import 'analtyics_screen.dart';
import 'orders_screen.dart';

class VendorScreen extends StatefulWidget {
  static const String routeName = '/vendor';
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  int _selectedIndex = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  final List<Widget> _widgetOptions = <Widget>[
    const ProductScreen(),
    const AnalyticsScreen(),
    const OrdersScreen(),
    const VouchersScreen(),  // Thêm VoucherScreen ở đây
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppPalette.btnColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          onTap: _onItemTapped,
          backgroundColor: AppPalette.appBarColor,
          items: [
            // HOME
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
              label: 'Home',
            ),
            // ANALYTICS
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? const Icon(Icons.analytics)
                  : const Icon(Icons.analytics_outlined),
              label: 'Analytics',
            ),
            // ORDERS
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? const Icon(Icons.all_inbox)
                  : const Icon(Icons.all_inbox_outlined),
              label: 'Orders',
            ),
            // VOUCHER
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? const Icon(Icons.discount)
                  : const Icon(Icons.discount_outlined),
              label: 'Voucher',
            ),
            // ACCOUNT
            BottomNavigationBarItem(
              icon: _selectedIndex == 4
                  ? const Icon(Icons.person)
                  : const Icon(Icons.person_outline),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}

