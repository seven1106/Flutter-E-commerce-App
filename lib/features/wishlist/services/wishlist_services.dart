import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';
import '../../../core/constants/error_handler.dart';
import '../../../core/utils/show_snack_bar.dart';
import '../../../models/product_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';

class WishlistServices {
  void removeFromWishlist({
    required BuildContext context,
    required ProductModel product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('${Constants.backEndUrl}/user/remove-from-wishlist/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          UserModel user = userProvider.user.copyWith(
            wishlist: jsonDecode(res.body)['wishlist'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

}