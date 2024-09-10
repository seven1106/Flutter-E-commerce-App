import 'package:emigo/core/config/theme/app_palette.dart';
import 'package:emigo/features/home/widgets/address_box.dart';
import 'package:emigo/features/home/widgets/products/best_seller_product.dart';
import 'package:emigo/features/home/widgets/products/deal_products.dart';
import 'package:emigo/features/home/widgets/products/new_product.dart';
import 'package:emigo/features/home/widgets/top_categories.dart';
import 'package:emigo/features/wishlist/screens/wishlist_screen.dart';
import 'package:emigo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../widgets/carousel_image.dart';
import '../widgets/products/best_sale_product.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, '/search-screen', arguments: query);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: AppPalette.appBarColor),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.mail_outline,
                color: Colors.black,
                size: 30,
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
                size: 30,
              ),

              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(

                        prefixIcon: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7),
                              bottomLeft: Radius.circular(7),
                            ),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: '  Search...',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              IconButton(

                icon: badges.Badge(
                  badgeContent: Text(
                    user.wishlist.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, WishlistScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                const AddressBox(),
                const TopCategories(),
                const SizedBox(height: 10),
                const CarouselImage(),
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Recommended'),
                      Tab(text: 'New Arrival'),
                      Tab(text: 'Best Seller'),
                      Tab(text: 'Top Deals'),
                    ],
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black38,
                    indicatorColor: Colors.black,
                  ),
                ),
              ]),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            DealOfProducts(),
            NewArrivalProducts(),
            BestSellerProducts(),
            BestSaleProducts(),
          ],
        ),
      ),
    );
  }
}
