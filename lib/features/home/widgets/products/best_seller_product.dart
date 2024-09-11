import 'package:emigo/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/loader.dart';
import '../../../product/screens/product_detail_screen.dart';
import '../../../vendor/widgets/product_entity.dart';
import '../../services/home_services.dart';

class BestSellerProducts extends StatefulWidget {
  const BestSellerProducts({Key? key}) : super(key: key);

  @override
  State<BestSellerProducts> createState() => _BestSellerProductsState();
}

class _BestSellerProductsState extends State<BestSellerProducts> {
  List<ProductModel> productList = [];
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    productList = await homeServices.fetchBestSellerProducts(context: context);
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
    final screenWidth = MediaQuery.of(context).size.width;
    return productList.isEmpty
        ? const Loader()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Top Picks For You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: productList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth < 600
                  ? 2
                  : screenWidth < 1000
                  ? 3
                  : 4,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final productData = productList[index];
              return InkWell(
                onTap: () {
                  navigateToDetailScreen(productData);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ProductEntity(
                              image: productData.images[0],
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  '-${((productData.price - productData.discountPrice) / productData.price * 100).toInt()}%',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productData.name,
                              style: const TextStyle(color: Colors.black87, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '\$${productData.discountPrice}',
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '\$${productData.price}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.shopping_cart, color: Colors.blueAccent, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${productData.sellCount.toInt()} sold',
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
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