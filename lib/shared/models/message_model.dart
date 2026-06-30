import 'package:intl/intl.dart';

class MessageModel {

  final String id;

  final String body;

  final String sender;

  final String senderName;

  final String? attachment;

  final String attachmentName;

  final int attachmentSize;

  final String attachmentType;

  final bool isMine;

  final String time;

  final DateTime createdAt;

  MessageModel({

    required this.id,

    required this.body,

    required this.sender,

    required this.senderName,

    required this.attachment,

    required this.attachmentName,

    required this.attachmentSize,

    required this.attachmentType,

    required this.isMine,

    required this.time,

    required this.createdAt,
  });

  bool get hasAttachment =>

      attachment != null &&
      attachment!.isNotEmpty;

  bool get isImage =>

      attachmentType == "image";

  bool get isPdf =>

      attachmentType == "pdf";

  bool get isAudio =>

      attachmentType == "audio";

  bool get isVideo =>

      attachmentType == "video";

  bool get isFile =>

      attachmentType == "file";
  
  String get attachmentSizeLabel {

    if (attachmentSize <= 0) {

      return "";
    }

    if (attachmentSize < 1024) {

      return "$attachmentSize o";
    }

    if (attachmentSize < 1024 * 1024) {

      return "${(attachmentSize / 1024).toStringAsFixed(1)} KB";
    }

    if (attachmentSize < 1024 * 1024 * 1024) {

      return "${(attachmentSize / 1024 / 1024).toStringAsFixed(1)} MB";
    }

    return "${(attachmentSize / 1024 / 1024 / 1024).toStringAsFixed(1)} GB";
  }

  String get fileName {

    if (attachmentName.isNotEmpty) {

      return attachmentName;
    }

    if (attachment == null || attachment!.isEmpty) {

      return "";
    }

    return attachment!.split("/").last;
  }

  String get formattedTime {

    return DateFormat("HH:mm").format(createdAt);
  }

  String get formattedDate {

    return DateFormat("dd/MM/yyyy").format(createdAt);
  }

  factory MessageModel.fromJson(
    Map<String, dynamic> json
    ) {

    final senderId =
      json["sender"]?.toString() ?? "";

    return MessageModel(

      id:
      json["id"].toString(),

      body:
      json["body"] ?? "",

      sender: senderId,

      senderName:
      json["sender_name"] ?? "",

      attachment:
      json["attachment"],

      attachmentName:
      json["attachment_name"] ?? "",

      attachmentSize:
      json["attachment_size"] ?? 0,

      attachmentType:
      json["attachment_type"] ?? "",

      isMine: 
       json["is_mine"] ?? false,
      

      time: json["time"] ??

        (json["created_at"] != null

          ? DateFormat("HH:mm").format(

              DateTime.parse(
                json["created_at"],
              ),
            )

          : ""),

      createdAt: json["created_at"] != null

      ? DateTime.parse(json["created_at"])

      : DateTime.now(),
    );
  }
 
}