class ConversationModel {

  final String id;

  final String studentId;

  final String studentName;

  final String lastMessage;

  final String lastMessageType;

  final String? lastMessageDate;

  final int unreadCount;

  final String updatedTime;

  final DateTime updatedAt;

  ConversationModel({

    required this.id,

    required this.studentId,

    required this.studentName,

    required this.lastMessage,

    required this.lastMessageType,

    required this.lastMessageDate,

    required this.unreadCount,

    required this.updatedTime,

    required this.updatedAt,
  });

  bool get hasUnread =>

      unreadCount > 0;

  bool get hasImage =>

      lastMessageType == "image";

  bool get hasPdf =>

      lastMessageType == "pdf";

  bool get hasAudio =>

      lastMessageType == "audio";

  bool get hasVideo =>

      lastMessageType == "video";

  bool get hasFile =>

      lastMessageType == "file";
  
  bool get isEmpty =>

      lastMessage.trim().isEmpty;

  factory ConversationModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return ConversationModel(

      id:
      json["id"].toString(),

      studentId:
      json["student_id"]?.toString() ?? "",

      studentName:
      json["student_name"] ?? "",

      lastMessage:
      json["last_message"] ?? "",

      lastMessageType:
      json["last_message_type"] ?? "text",

      unreadCount:
      json["unread_count"] ?? 0,

      updatedTime:
      json["updated_time"] ?? "",

      lastMessageDate:
      json["last_message_date"],

      updatedAt:
      DateTime.tryParse(
        json["updated_at"] ?? "",
      ) ??
      DateTime.now(),
    );
  }
}