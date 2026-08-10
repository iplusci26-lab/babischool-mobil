class NotificationModel {

  final String id;

  final String title;

  final String message;

  final String type;

  final bool isRead;

  final String url;

  final DateTime createdAt;

  final String objectId;

  final String targetType;

  NotificationModel({

    required this.id,

    required this.title,

    required this.message,

    required this.type,

    required this.isRead,

    required this.url,

    required this.createdAt,

    required this.objectId,

    required this.targetType,
  });

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return NotificationModel(

      id:
      json["id"].toString(),

      title:
      json["title"] ?? "",

      message:
      json["message"] ?? "",

      type:
      json["notification_type"] ?? "",

      isRead:
      json["is_read"] ?? false,

      url:
      json["url"] ?? "",

      createdAt:
      DateTime.parse(
        json["created_at"],
      ),

      objectId:
        json["object_id"] ?? "",

      targetType:
          json["target_type"] ??
          json["notification_type"],
          
    );
  }
}