import 'package:badges/badges.dart' as badges;
import 'package:emigo/core/config/theme/app_palette.dart';
import 'package:emigo/features/account/screens/account_screen.dart';
import 'package:emigo/features/vendor/screens/product/product_screen.dart';
import 'package:flutter/material.dart';

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
    const Text(
      'AnalyticsScreen',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    const Text(
      'OrdersScreen',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
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
            iconSize: double.parse('30'),
            onTap: (index) {
              _onItemTapped(index);
            },
            backgroundColor: AppPalette.appBarColor,
            items: [
              // HOME
              BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? const Icon(Icons.home)
                    : const Icon(
                        Icons.home_outlined,
                      ),
                label: 'Home',
              ),
              // SEARCH
              BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? const Icon(Icons.analytics)
                    : const Icon(
                        Icons.analytics_outlined,
                      ),
                label: 'AnalyticsScreen',
              ),
              // CART
              BottomNavigationBarItem(
                icon: badges.Badge(
                  // badgeContent: Text(userCartLen.toString()),
                  position: badges.BadgePosition.topEnd(top: -4, end: -4),
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 1),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    curve: Curves.fastOutSlowIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  child: _selectedIndex == 2
                      ? const Icon(Icons.all_inbox)
                      : const Icon(
                          Icons.all_inbox_outlined,
                        ),
                ),
                label: 'OrdersScreen',
              ),
              // ACCOUNT
              BottomNavigationBarItem(
                icon: _selectedIndex == 3
                    ? const Icon(Icons.person)
                    : const Icon(
                        Icons.person_outlined,
                      ),
                label: 'Account',
              ),
            ],
          ),
        ));
  }
}
