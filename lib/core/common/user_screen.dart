import 'package:badges/badges.dart' as badges;
import 'package:emigo/core/config/theme/app_palette.dart';
import 'package:emigo/features/account/screens/account_screen.dart';
import 'package:emigo/features/home/screens/home_screen.dart';
import 'package:emigo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/cart/screens/cart_screen.dart';

class UserScreen extends StatefulWidget {
  static const String routeName = '/bottomBar';

  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _selectedIndex = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const Text(
      'Search',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    const CartScreen(),
    const AccountScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLength = context.watch<UserProvider>().user.cart.length;
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
                    ? const Icon(Icons.search)
                    : const Icon(
                        Icons.search_outlined,
                      ),
                label: 'Search',
              ),
              // CART
              BottomNavigationBarItem(
                icon: badges.Badge(
                  badgeContent: Text(userCartLength.toString()),
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 1),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    curve: Curves.fastOutSlowIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  child: _selectedIndex == 2
                      ? const Icon(Icons.shopping_cart)
                      : const Icon(
                          Icons.shopping_cart_outlined,
                        ),
                ),
                label: 'Cart',
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
