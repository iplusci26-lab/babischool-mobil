import 'message_model.dart';

class ConversationDetailModel {

  final String id;

  final String studentName;

  final String parentName;

  final String currentUserId;

  final List<MessageModel> messages;

  ConversationDetailModel({

    required this.id,

    required this.studentName,

    required this.parentName,

    required this.currentUserId,

    required this.messages,
  });

  factory ConversationDetailModel.fromJson(
    Map<String,dynamic> json,
  ) {

    return ConversationDetailModel(

      id:
      json["id"],

      studentName:
      json["student_name"] ?? "",

      parentName:
      json["parent_name"] ?? "",

      currentUserId:
      json["current_user_id"].toString(),

      messages:

      (json["messages"] as List)

      .map(

        (e) =>
        MessageModel.fromJson(e),
      )

      .toList(),
    );
  }
}