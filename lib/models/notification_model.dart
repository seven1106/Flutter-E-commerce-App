import 'dart:convert';

import '../enum/notification_enum.dart';

class NotificationModel {
  final String title;
  final String content;
  final NotificationEnum type;
  final bool isRead;
  final String orderId;
  final int createdAt;

  const NotificationModel({
    required this.title,
    required this.content,
    required this.orderId,
    required this.isRead,
    required this.type,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'NotificationModel{ , name: $title, text: $content, orderId: $orderId, isRead: $isRead, type: $type, createdAt: $createdAt,}';
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'orderId': orderId,
      'isRead': isRead,
      'type': type.type,
      'createdAt': createdAt,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      content: map['content'] as String,
      orderId: map['orderId'] as String,
      isRead: map['isRead'] as bool,
      type: (map['type'] as String).toEnum(),
      createdAt: map['createdTime']?.toInt() ?? 0,
    );
  }
  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source));
}
