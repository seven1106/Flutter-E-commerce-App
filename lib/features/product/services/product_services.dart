import 'dart:convert';
import 'dart:developer';

import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/core/utils/show_snack_bar.dart';
import 'package:emigo/models/product_model.dart';
import 'package:emigo/models/user_model.dart';
import 'package:emigo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductServices {
  void fetchProductById({
    required BuildContext context,
    required String id,
    required Function(ProductModel) onSuccess,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.backEndUrl}/get-products/$id'),
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess(ProductModel.fromMap(jsonDecode(res.body)['product']));
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void addToCart({
    required BuildContext context,
    required ProductModel product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/user/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          UserModel user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void addToWishlist({
    required BuildContext context,
    required ProductModel product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/user/add-to-wishlist'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'productId': product.id!,
        }),
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          UserModel user = userProvider.user.copyWith(
            wishlist: jsonDecode(res.body)['wishlist'],
          );
          userProvider.setUserFromModel(user);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added to wishlist'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required ProductModel product,
    required double rating,
    String? comment,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/products/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'rating': rating,
          'comment': comment,
        }),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
