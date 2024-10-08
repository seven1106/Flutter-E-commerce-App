import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:emigo/core/common/custom_textfield.dart';
import 'package:emigo/core/common/long_button.dart';
import 'package:emigo/core/utils/utils.dart';
import 'package:emigo/features/vendor/services/vendor_services.dart';
import 'package:emigo/models/product_model.dart'; // Import the model
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  final ProductModel product; // Add this line to receive the product

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final VendorServices vendorServices = VendorServices();
  int _current = 0;
  final CarouselController _controller = CarouselController();

  String category = 'Mobiles';
  List<File> images = [];
  final _editProductFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    quantityController.text = widget.product.quantity.toString();
    discountController.text = widget.product.discountPrice.toString();
    category = widget.product.category;
    images = widget.product.images.map((url) => File(url)).toList();
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    discountController.dispose();
  }

  List<String> productCategories = [
    'Mobiles', 'Essentials', 'Appliances', 'Books', 'Fashion'
  ];

  void selectImages() async {
    final res = await pickMultipleImages();
    if (res != null) {
      setState(() {
        for (var pickedImage in res) {
          images.add(File(pickedImage.path));
        }
      });
    }
  }

  void updateProduct() {
    if (_editProductFormKey.currentState!.validate()) {
      final product = ProductModel(
        name: productNameController.text,
        sellerId: widget.product.sellerId,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: int.parse(quantityController.text),
        category: category,
        images: images.map((image) => image.path).toList(),
        discountPrice: double.parse(discountController.text),
        sellCount: widget.product.sellCount,
        ratings: widget.product.ratings,
        id: widget.product.id,
      );
      vendorServices.updateProduct(context: context, product: product);
    } else {
      showSnackBar(context, 'Please fill all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Product',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _editProductFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                images.isNotEmpty
                    ? Stack(
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
                        children: widget.product.images
                            .asMap()
                            .entries
                            .map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(
                                  _current == entry.key ? 0.9 : 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
                    : GestureDetector(
                  onTap: selectImages,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    color: Colors.grey,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate,
                              size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Edit Product Images',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text('Product Details',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (isLargeScreen) {
                      return Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: priceController,
                              hintText: 'Price',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: quantityController,
                              hintText: 'Quantity',
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          CustomTextField(
                            controller: priceController,
                            hintText: 'Price',
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            controller: quantityController,
                            hintText: 'Quantity',
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: discountController,
                  hintText: 'Discount Price',
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: category,
                  items: productCategories.map((String item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (String? newVal) {
                    setState(() {
                      category = newVal!;
                    });
                  },
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: isLargeScreen
                      ? MediaQuery.of(context).size.width * 0.5
                      : double.infinity, // Điều chỉnh linh hoạt với màn hình
                  child: LongButton(
                    buttonText: 'Update Product',
                    onPressed: updateProduct,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
