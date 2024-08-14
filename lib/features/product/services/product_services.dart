import 'dart:convert';

import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/core/utils/show_snack_bar.dart';
import 'package:emigo/models/product_model.dart';
import 'package:emigo/providers/user-provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductServices {
  void addToCart({
    required BuildContext context,
    required ProductModel product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/add-to-cart'),
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
          // User user =
          //     userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          // userProvider.setUserFromModel(user);
          showSnackBar(context, 'message');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required ProductModel product,
    required double rating,
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
