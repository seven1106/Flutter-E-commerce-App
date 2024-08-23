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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Store', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'Stocking'),
            Tab(text: 'Sold out'),
          ],
        ),
      ),
      body: _products == null
          ? const Loader()
          : TabBarView(
        controller: _tabController,
        children: [
          GridView.builder(
            padding: EdgeInsets.all(8),
            itemCount: _products!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final productData = _products![index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ProductEntity(
                      image: productData.images[0],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      productData.name,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${productData.price}',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      IconButton(
                        onPressed: () => deleteProduct(productData, index),
                        icon: Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          Center(child: Text('Sold out', style: TextStyle(color: Colors.black))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.pushNamed(context, '/add-product');
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}