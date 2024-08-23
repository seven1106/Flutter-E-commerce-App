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
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Top Picks For You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return GestureDetector(
                onTap: () => navigateToDetailScreen(product),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            product.images[0],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                Text(
                                  ' ${product.ratings.length > 0 ? (product.ratings.map((r) => r.rating).reduce((a, b) => a + b) / product.ratings.length).toStringAsFixed(1) : 'N/A'}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  ' (${product.ratings.length})',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}