import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/notification_model.dart'; // Thay đổi theo đúng đường dẫn của bạn
import '../../../providers/user_provider.dart';
import '../services/notification_services.dart'; // Thay đổi theo đúng đường dẫn của bạn

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



  @override
  Widget build(BuildContext context) {
    final notificationList = context.watch<UserProvider>().user.notifications[widget.index];
    final notification = NotificationModel.fromMap(notificationList['notify']);
    return InkWell(
      onTap: () {
        // Xử lý khi người dùng nhấn vào thông báo
        // Ví dụ: Mở chi tiết thông báo hoặc trang liên quan
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notification.isRead ? Colors.grey[200] : Colors.white,
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
                        Text('Date:      ${DateFormat().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              notification.createdAt),
                        )}'),
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
                  IconButton(
                    icon: const Icon(Icons.done, color: Colors.green),
                    onPressed: () {
                      if (!notification.isRead) {
                      }
                    },
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
