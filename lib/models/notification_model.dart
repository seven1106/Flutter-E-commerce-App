import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String content;
  final String type;
  final bool isRead;
  final String orderId;
  final int createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.orderId,
    required this.isRead,
    required this.type,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'NotificationModel{ id: $id, title: $title, content: $content, orderId: $orderId, isRead: $isRead, type: $type, createdAt: $createdAt,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'orderId': orderId,
      'isRead': isRead,
      'type': type,
      'createdAt': createdAt,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      orderId: map['orderId'] as String,
      isRead: map['isRead'] as bool,
      type: map['type'] as String,
      createdAt: map['createTime']?.toInt() ?? 0,
    );
  }
  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
