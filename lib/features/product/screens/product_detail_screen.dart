import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:emigo/core/common/custom_button.dart';
import 'package:emigo/features/search/screen/search_screen.dart';
import 'package:emigo/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../wishlist/services/wishlist_services.dart';
import '../services/product_services.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final ProductModel product;
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductServices productServices = ProductServices();
  double avgRating = 0;
  double myRating = 0;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final WishlistServices wishlistServices = WishlistServices();

  @override
  void initState() {
    super.initState();
    if (widget.product.ratings.isNotEmpty) {
      double totalRating = 0;
      for (var rating in widget.product.ratings) {
        totalRating += rating.rating;
      }
      avgRating = totalRating / widget.product.ratings.length;
    }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    if (widget.product.quantity > 0) {
      productServices.addToCart(context: context, product: widget.product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added to cart'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product out of stock'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void addToWishlist() {
    productServices.addToWishlist(context: context, product: widget.product);

  }
  void removeFromWishlist(ProductModel product) {
    wishlistServices.removeFromWishlist(
      context: context,
      product: product,
    );
  }
  @override
  Widget build(BuildContext context) {
    final productWishList = context.watch<UserProvider>().user.wishlist;
    bool isWishlisted = false;
 for (var product in productWishList) {
        log('product: ${product}');
      if (product['product']['_id'] == widget.product.id) {
        isWishlisted = true;
        break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
              icon: isWishlisted
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              color: isWishlisted ? Colors.red : null,
              onPressed: () {
                if (isWishlisted) {
                  removeFromWishlist(widget.product);
                } else {
                  addToWishlist();
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider(
                  items: widget.product.images.map((i) {
                    return Builder(
                      builder: (BuildContext context) => Image.network(
                        i,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    aspectRatio: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  carouselController: _controller,
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        widget.product.images.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                              .withOpacity(_current == entry.key ? 0.9 : 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.discountPrice}',
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${(widget.product.price).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Quantity: ${widget.product.quantity.toInt()}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.product.sellCount.toInt()} sold',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Size'),
                  Wrap(
                    spacing: 8,
                    children: ['S', 'M', 'L', 'XL'].map((size) {
                      return ChoiceChip(
                        label: Text(size),
                        selectedColor: Colors.white24,
                        selected: false,
                        onSelected: (bool selected) {
                          // Handle size selection
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Color'),
                  Wrap(
                    spacing: 8,
                    children: [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.yellow
                    ].map((color) {
                      return CircleAvatar(
                        backgroundColor: color,
                        radius: 15,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Description'),
                  Text(widget.product.description),
                  const SizedBox(height: 16),
                  const Text('Shipping & Returns'),
                  const ListTile(
                    leading: Icon(Icons.local_shipping),
                    title: Text('Free Shipping'),
                    subtitle: Text('For orders over \$50'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.repeat),
                    title: Text('Free Returns'),
                    subtitle: Text('Within 30 days'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Ratings & Reviews'),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: avgRating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                      ),
                      const SizedBox(width: 8),
                      Text('(${widget.product.ratings.length} reviews)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.product.ratings.length,
                    itemBuilder: (context, index) {
                      var rating = widget.product.ratings[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(rating.userId.substring(0, 1)),
                        ),
                        title: Text(rating.userId),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBarIndicator(
                              rating: rating.rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                            ),
                            Text(rating.comment),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: isWishlisted
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                color: isWishlisted ? Colors.red : null,
                onPressed: () {
                  if (isWishlisted) {
                    removeFromWishlist(widget.product);
                  } else {
                    addToWishlist();
                  }
                },
              ),
              SizedBox(
                width: 330,
                child: CustomButton(
                  text: 'Add to Cart',
                  onTap: addToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Stars extends StatelessWidget {
  final double rating;

  const Stars({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 20.0,
    );
  }
}
