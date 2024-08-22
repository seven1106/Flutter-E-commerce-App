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
  List<ProductModel> productList = [];
  final HomeServices homeServices = HomeServices();
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    fetchTopRatedProducts();
  }

  void fetchTopRatedProducts() async {
    productList = await homeServices.fetchTopRatedProducts(context: context);
    setState(() {});
  }

  void navigateToDetailScreen(ProductModel product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return productList.isEmpty
        ? const Loader()
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
                ),
                itemCount: productList.length,
                itemBuilder: (context, index) {
          final product = productList[index];
          return GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTap: () => navigateToDetailScreen(product),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      product.images[0],
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text('${product.quantity} Sold'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${product.price}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
                },
              ),
        );
  }
}