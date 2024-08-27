import '../enum/notification_enum.dart';

class NotificationModel {
  final String title;
  final String content;
  final String uid;
  final String id;
  final bool isRead;
  final NotificationEnum type;
  final DateTime createdAt;

  const NotificationModel({
    required this.title,
    required this.content,
    required this.uid,
    required this.id,
    required this.isRead,
    required this.type,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'NotificationModel{ , name: $title, text: $content, uid: $uid, id: $id, isRead: $isRead, type: $type, createdAt: $createdAt,}';
  }

  NotificationModel copyWith({
    String? title,
    String? content,
    String? uid,
    String? id,
    bool? isRead,
    NotificationEnum? type,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      content: content ?? this.content,
      uid: uid ?? this.uid,
      id: id ?? this.id,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'uid': uid,
      'id': id,
      'isRead': isRead,
      'type': type.type,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      content: map['content'] as String,
      uid: map['uid'] as String,
      id: map['_id'] as String,
      isRead: map['isRead'] as bool,
      type: (map['type'] as String).toEnum(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
