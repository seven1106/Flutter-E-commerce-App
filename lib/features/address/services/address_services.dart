import 'dart:convert';
import 'dart:developer';

import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/models/product_model.dart';
import 'package:emigo/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/show_snack_bar.dart';
import '../../../providers/user_provider.dart';
import '../../notification/services/notification_services.dart';

class AddressServices {
  final NotificationServices notificationServices = NotificationServices();
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/user/save-user-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
        }),
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          UserModel user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );

          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
    required String receiverName,
    required String receiverPhone,
    required String paymentMethod,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productCart = userProvider.user.cart;
    try {
      http.Response res = await http.post(Uri.parse('${Constants.backEndUrl}/user/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': address,
            'totalPrice': totalSum,
            'receiverName': receiverName,
            'receiverPhone': receiverPhone,
            'paymentMethod': paymentMethod,
          }));

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          Navigator.of(context).pop();
          showSnackBar(context, 'Your order has been placed!');
          UserModel user = userProvider.user.copyWith(
            cart: [],
          );
          userProvider.setUserFromModel(user);
          String orderId = jsonDecode(res.body)['order']['_id'];
          notificationServices.createNotification(
            context: context,
            title: 'New order',
            content: 'You have a new order from ${userProvider.user.name}',
            type: 'order',
            orderId: orderId,
            receiverId: productCart[0]['product']['sellerId'],
          ).then((value) => log('Notification created successfully' + productCart[0]['product']['sellerId'] + orderId));
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }


  void deleteProduct({
    required BuildContext context,
    required ProductModel product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/admin/delete-product'),
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
}
