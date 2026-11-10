
import 'contact_model.dart';

class ConversationModel {
  final String id;
  final String studentId;
  final ContactModel contact;
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
    required this.contact,
    required this.studentName,
    required this.lastMessage,
    required this.lastMessageType,
    required this.lastMessageDate,
    required this.unreadCount,
    required this.updatedTime,
    required this.updatedAt,
  });

  bool get hasUnread => unreadCount > 0;

  bool get hasImage => lastMessageType == "image";

  bool get hasPdf => lastMessageType == "pdf";

  bool get hasAudio => lastMessageType == "audio";

  bool get hasVideo => lastMessageType == "video";

  bool get hasFile => lastMessageType == "file";

  bool get isEmpty => lastMessage.trim().isEmpty;

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final rawUpdatedAt = json["updated_at"];

    return ConversationModel(
      id: json["id"]?.toString() ?? "",
      studentId: json["student_id"]?.toString() ?? "",

      contact: ContactModel.fromJson(
        json["contact"] is Map
            ? Map<String, dynamic>.from(json["contact"])
            : <String, dynamic>{},
      ),

      studentName: json["student_name"]?.toString() ?? "",
      lastMessage: json["last_message"]?.toString() ?? "",
      lastMessageType:
          json["last_message_type"]?.toString() ?? "text",

      lastMessageDate:
          json["last_message_date"]?.toString(),

      unreadCount: int.tryParse(
            json["unread_count"]?.toString() ?? "0",
          ) ??
          0,

      updatedTime: json["updated_time"]?.toString() ?? "",

      updatedAt: DateTime.tryParse(
            rawUpdatedAt?.toString() ?? "",
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
