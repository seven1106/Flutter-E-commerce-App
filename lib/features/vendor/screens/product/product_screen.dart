import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import '../../../../core/utils/loader.dart';
import '../../../../models/product_model.dart';
import '../../../../providers/user_provider.dart';
import '../../../notification/screens/notification_screen.dart';
import '../../services/vendor_services.dart';
import '../../widgets/product_entity.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final VendorServices _vendorServices = VendorServices();
  List<ProductModel>? _products;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _products = await _vendorServices.fetchAllProducts(context);
    setState(() {});
  }

  Future<void> _onRefresh() async {
    await fetchProducts();
  }

  void deleteProduct(ProductModel product, int index) {
    _vendorServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        setState(() {
          _products!.removeAt(index);
        });
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    int unreadNotifications = 0;
    for (var notification in user.notifications) {
      if (!notification['notify']['isRead']) {
        unreadNotifications++;
      }
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Row(
            children: [
              const Text(
                'My Store',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: badges.Badge(
                  badgeContent: Text(
                    unreadNotifications.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, NotificationScreen.routeName);
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black, size: 30),
                onPressed: fetchProducts,
              ),

            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'In Stock'),
              Tab(text: 'Sold Out'),
            ],
          ),
        ),
        body: _products == null
            ? const Loader()
            : TabBarView(
              controller: _tabController,
              children: [
                _buildProductList(
                  _products!.where((product) => product.quantity > 0).toList(),
                ),
                _buildProductList(
                  _products!.where((product) => product.quantity == 0).toList(),
                ),
              ],
            ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, '/add-product');
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> productList) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GridView.builder(
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
            Navigator.pushNamed(context, '/edit-product', arguments: productData);
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
                        image: productData.images.isEmpty
                            ? 'https://via.placeholder.com/150'
                            : productData.images.first,
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
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () => deleteProduct(productData, index),
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(4),
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
                            '\$${productData.discountPrice.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${productData.price.toStringAsFixed(2)}',
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
                          const Icon(Icons.star, color: Colors.orange, size: 14),
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
    );
  }
}
