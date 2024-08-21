import 'package:carousel_slider/carousel_slider.dart';
import 'package:emigo/core/common/custom_button.dart';
import 'package:emigo/core/config/theme/app_palette.dart';
import 'package:emigo/features/search/screen/search_screen.dart';
import 'package:emigo/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  @override
  void initState() {
    super.initState();
    // Ở đây bạn có thể thêm logic để tính toán avgRating từ widget.product.rating
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    productServices.addToCart(context: context, product: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
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
                    children: widget.product.images.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin:const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4),
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
                    style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price}',
                        style:const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${(widget.product.price * 1.2).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
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
                        selected: false,
                        onSelected: (bool selected) {},
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Color'),
                  Wrap(
                    spacing: 8,
                    children: [Colors.red, Colors.blue, Colors.green, Colors.yellow].map((color) {
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
                      Text('(${widget.product.description.length} reviews)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sample reviews
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2, // Show 2 sample reviews
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('U${index + 1}'),
                        ),
                        title: Text('User ${index + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBarIndicator(
                              rating: 4,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                            ),
                            const Text('Great product! Highly recommended.'),
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
                icon: const Icon(Icons.favorite_border,
                    color: Colors.black, size: 35),
                onPressed: () {},
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