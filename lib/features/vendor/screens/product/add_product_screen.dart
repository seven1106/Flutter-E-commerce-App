import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:emigo/core/common/custom_textfield.dart';
import 'package:emigo/core/common/long_button.dart';
import 'package:emigo/core/utils/utils.dart';
import 'package:emigo/features/vendor/services/vendor_services.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final VendorServices vendorServices = VendorServices();

  String category = 'Mobiles';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
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

  void addProduct() {
    if (_addProductFormKey.currentState!.validate()) {
      vendorServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: double.parse(quantityController.text),
        category: category,
        images: images,
      );
    } else {
      showSnackBar(context, 'Please fill all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add Product',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                images.isNotEmpty
                    ? CarouselSlider(
                  items: images.map((i) => Image.file(i, fit: BoxFit.cover)).toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 200,
                    aspectRatio: 1,
                  ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Add Product Images', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text('Product Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                Row(
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
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                LongButton(
                  buttonText: 'Add Product',
                  onPressed: addProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}