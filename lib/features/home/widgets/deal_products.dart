
import 'package:emigo/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/loader.dart';
import '../../product/screens/product_detail_screen.dart';
import '../services/home_services.dart';

class DealOfProducts extends StatefulWidget {
  const DealOfProducts({Key? key}) : super(key: key);

  @override
  State<DealOfProducts> createState() => _DealOfProductsState();
}

class _DealOfProductsState extends State<DealOfProducts> {
  ProductModel? product;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    product = await homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Loader()
        : product!.name.isEmpty
        ? const SizedBox()
        : GestureDetector(
      onTap: navigateToDetailScreen,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 10, top: 15),
            child: const Text(
              'Deal of the day',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Image.network(
            product!.images[0],
            height: 235,
            fit: BoxFit.fitHeight,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.topLeft,
            child: const Text(
              '\$100',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding:
            const EdgeInsets.only(left: 15, top: 5, right: 40),
            child: const Text(
              'Seven',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: product!.images
                  .map(
                    (e) => Image.network(
                  e,
                  fit: BoxFit.fitWidth,
                  width: 100,
                  height: 100,
                ),
              )
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ).copyWith(left: 15),
            alignment: Alignment.topLeft,
            child: Text(
              'See all deals',
              style: TextStyle(
                color: Colors.cyan[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}