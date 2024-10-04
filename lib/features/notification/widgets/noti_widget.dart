import 'dart:developer';

import 'package:emigo/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/notification_model.dart';
import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';
import '../../vendor/services/vendor_services.dart';
import '../services/notification_services.dart';

class NotificationWidget extends StatefulWidget {
  final int index;

  const NotificationWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final NotificationServices notificationServices = NotificationServices();
  final VendorServices _vendorServices = VendorServices();

  @override
  Widget build(BuildContext context) {
    final notificationList = context
        .watch<UserProvider>()
        .user
        .notifications
        .reversed
        .toList()[widget.index];

    final notification = NotificationModel.fromMap(notificationList['notify']);

    bool isRead = notification.isRead;
    return InkWell(
      onTap: () async {
        if (!notification.isRead) {
          notificationServices.markAsRead(
              context: context, notificationId: notification.id);
          isRead = true;
        }
        if (notification.type == 'order') {
          OrderModel order = await _vendorServices.fetchOrderById(
              context: context, id: notification.orderId);
          Navigator.of(context).pushNamed('/order-details', arguments: order);
        }
        if (notification.type == 'rating') {
          ProductModel product = await _vendorServices.fetchProductById(
              context: context, id: notification.orderId);
          log('ProductorderId: ${notification.orderId}');
          log('Product: $product');
          Navigator.of(context)
              .pushNamed('/product-details', arguments: product);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isRead ? Colors.white : Colors.blueGrey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              notification.createdAt),
                        )),
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          notification.content,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
