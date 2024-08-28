import 'dart:convert';
import 'dart:developer';
import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/core/utils/show_snack_bar.dart';
import 'package:emigo/models/notification_model.dart';
import 'package:emigo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NotificationServices {

  Future<void> createNotification({
    required BuildContext context,
    required String title,
    required String content,
    required String type,
    required String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final Map<String, dynamic> notificationData = {
        'title': title,
        'content': content,
        'type': type,
        'userId': userId,
        'createAt': DateTime.now().millisecondsSinceEpoch,
      };

      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(notificationData),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          log('Notification created successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }



  // Lấy danh sách notification của người dùng
  Future<List<NotificationModel>> fetchUserNotifications({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<NotificationModel> notificationList = [];

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
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            notificationList.add(
              NotificationModel.fromJson(
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

    return notificationList;
  }

  // Đánh dấu notification là đã đọc
  Future<void> markAsRead({
    required BuildContext context,
    required String notificationId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.put(
        Uri.parse('${Constants.backEndUrl}/notifications/mark-as-read/$notificationId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          // Update trạng thái của notification trong provider
          log('Notification marked as read');
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
