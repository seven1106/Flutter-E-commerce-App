import 'package:emigo/core/utils/loader.dart';
import 'package:emigo/features/vendor/services/vendor_services.dart';
import 'package:emigo/features/vendor/widgets/product_entity.dart';
import 'package:emigo/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final VendorServices _vendorServices = VendorServices();
  List<ProductModel>? _products;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchProducts();
    setState(() {});
  }

  fetchProducts() async {
    _products = await _vendorServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(ProductModel product, int index) {
    _vendorServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        _products!.removeAt(index);
        setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 4,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(
              text: 'Stocking',
            ),
            Tab(
              text: 'Sold out',
            ),
          ],
        ),
      ),
      body: _products == null
          ? const Loader()
          : TabBarView(
              controller: _tabController,
              children: [
                GridView.builder(
                  itemCount: _products!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    final productData = _products![index];
                    return Column(
                      children: [
                        SizedBox(
                          height: 140,
                          child: ProductEntity(
                            image: productData.images[0],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  productData.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    deleteProduct(productData, index),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Text('Sold out'),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
