import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';
import '../../product/services/product_services.dart';
import '../services/wishlist_services.dart';

class WishlistProduct extends StatefulWidget {
  final int productId;

  const WishlistProduct({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<WishlistProduct> createState() => _WishlistProductState();
}

class _WishlistProductState extends State<WishlistProduct> {
  final WishlistServices wishlistServices = WishlistServices();
  final ProductServices productDetailsServices =
  ProductServices();
  void removeFromWishlist(ProductModel product) {
    wishlistServices.removeFromWishlist(
      context: context,
      product: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productWishList = context.watch<UserProvider>().user.wishlist[widget.productId];
    final product = ProductModel.fromMap(productWishList['product']);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/product-details',
            arguments: product);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Image.network(
                  product.images[0],
                  fit: BoxFit.contain,
                  height: 135,
                  width: 135,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeFromWishlist(product),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
