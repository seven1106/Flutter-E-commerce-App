import 'dart:convert';
import 'dart:developer';
import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/core/utils/show_snack_bar.dart';
import 'package:emigo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';

class NotificationServices {
  Future<void> createNotification({
    required BuildContext context,
    required String title,
    required String content,
    required String type,
    required String orderId,
    required String receiverId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/user/notification'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'type': type,
          'orderId': orderId,
          'receiverId': receiverId,
        }),
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          UserModel user = userProvider.user
              .copyWith(notifications: jsonDecode(res.body)['notifications']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> markAsRead({
    required BuildContext context,
    required String notificationId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/user/mark-as-read'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': notificationId,
          'uid': userProvider.user.id,
        }),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          UserModel user = userProvider.user
              .copyWith(notifications: jsonDecode(res.body)['notifications']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchUserNotifications({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.backEndUrl}/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          UserModel user = userProvider.user
              .copyWith(notifications: jsonDecode(res.body)['notifications']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Xóa một notification
  Future<void> deleteNotification({
    required BuildContext context,
    required String notificationId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('${Constants.backEndUrl}/notifications/$notificationId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          log('Notification deleted successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
