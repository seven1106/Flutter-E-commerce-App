import 'dart:convert';

import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/core/utils/show_snack_bar.dart';
import 'package:emigo/models/product_model.dart';
import 'package:emigo/providers/user-provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<ProductModel>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ProductModel> productList = [];
    try {
      http.Response res = await http.get(
          Uri.parse('${Constants.backEndUrl}/products?category=$category'),
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

  // Future<ProductModel> fetchDealOfDay({
  //   required BuildContext context,
  // }) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   ProductModel product = ProductModel(
  //     name: '',
  //     description: '',
  //     quantity: 0,
  //     images: [],
  //     category: '',
  //     price: 0,
  //   );

  //   try {
  //     http.Response res =
  //         await http.get(Uri.parse('${Constants.backEndUrl}/api/deal-of-day'), headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'x-auth-token': userProvider.user.token,
  //     });

  //     httpErrorHandler(
  //       response: res,
  //       context: context,
  //       onSuccess: () {
  //         product = ProductModel.fromJson(res.body);
  //       },
  //     );
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  //   return product;
  // }
}
