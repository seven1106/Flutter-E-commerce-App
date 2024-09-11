import 'dart:convert';

import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/core/utils/show_snack_bar.dart';
import 'package:emigo/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../models/order.dart';
import '../../../providers/user_provider.dart';

class AccountService {
  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
  Future<List<OrderModel>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<OrderModel> orderList = [];
    try {
      http.Response res =
      await http.get(Uri.parse('${Constants.backEndUrl}/user/orders/me'), headers: {
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
  void editUserInformation({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/user/edit-user-info'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          userProvider.setUserFromModel(
            userProvider.user.copyWith(
              name: name,
              email: email,
              phone: phone,
            ),
          );
          showSnackBar(context, 'User information updated!');
          Navigator.of(context).pop();

        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}