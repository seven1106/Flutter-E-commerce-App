import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/core/utils/show_snack_bar.dart';
import 'package:emigo/models/order.dart';
import 'package:emigo/models/product_model.dart';
import 'package:emigo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/sales.dart';

class VendorServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double discountPrice,
    required int quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      List<String> imageUrls = [];
      try {
        final cloudinary = CloudinaryPublic('dhpmkmnap', 'ifzll6l1');

        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path, folder: name),
          );
          imageUrls.add(res.secureUrl);
        }
      } catch (e) {
        print(e);
      }

      ProductModel product = ProductModel(
        name: name,
        sellerId: userProvider.user.id,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
        discountPrice: discountPrice,
        sellCount: 0,
        ratings: [],
        id: '',
      );
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/vendor/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          fetchAllProducts(context);
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateProduct({
    required BuildContext context,
    required ProductModel product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/vendor/update-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Updated Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<ProductModel> fetchProductById({
    required BuildContext context,
    required String? id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    ProductModel product = ProductModel(
      name: '',
      sellerId: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
      discountPrice: 0,
      sellCount: 0,
      ratings: [],
      id: '',
    );

    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.backEndUrl}/vendor/get-product/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      log(res.toString());
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          product = ProductModel.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return product;
  }

  Future<OrderModel> fetchOrderById({
    required BuildContext context,
    required String? id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    OrderModel order = OrderModel(
      id: '',
      userId: '',
      products: [],
      status: 0,
      description: '',
      voucherCode: '',
      address: '',
      quantity: [],
      receiverName: '',
      receiverPhone: '',
      paymentMethod: '',
      orderedAt: 0,
      totalPrice: 0,
      initialPrice: 0,
    );

    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.backEndUrl}/vendor/get-order/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      log(res.toString());
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          order = OrderModel.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return order;
  }

  // get all the products
  Future<List<ProductModel>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ProductModel> productList = [];
    try {
      http.Response res = await http.get(
          Uri.parse('${Constants.backEndUrl}/vendor/get-products'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              ProductModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required ProductModel product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/vendor/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<OrderModel>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<OrderModel> orderList = [];
    try {
      http.Response res = await http.get(
          Uri.parse('${Constants.backEndUrl}/vendor/get-orders'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              OrderModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList.reversed.toList();
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required OrderModel order,
    required VoidCallback onSuccess,
    required String message,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/vendor/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
          'message': message,
        }),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    double totalEarning = 0.0;
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.backEndUrl}/vendor/get-analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = (response['totalEarnings'] as num).toDouble();
          sales = [
            Sales('Mobiles', (response['mobileEarnings'] as num).toDouble()),
            Sales('Essentials',
                (response['essentialEarnings'] as num).toDouble()),
            Sales('Books', (response['booksEarnings'] as num).toDouble()),
            Sales('Appliances',
                (response['applianceEarnings'] as num).toDouble()),
            Sales('Fashion', (response['fashionEarnings'] as num).toDouble()),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}
