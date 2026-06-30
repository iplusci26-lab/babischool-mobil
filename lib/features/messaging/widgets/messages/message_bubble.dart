import 'package:flutter/material.dart';

import '../../../../shared/models/message_model.dart';

import 'text_message.dart';
import 'image_message.dart';
import 'pdf_message.dart';
import 'file_message.dart';
// import 'audio_message.dart';
// import 'video_message.dart';

class MessageBubble extends StatelessWidget {

  final MessageModel message;

  const MessageBubble({

    super.key,

    required this.message,
  });

  @override
  Widget build(BuildContext context) {

    switch (message.attachmentType) {

      case "image":

        return ImageMessage(
          message: message,
        );

      case "pdf":

        return PdfMessage(
          message: message,
        );

      case "audio":

        return const SizedBox();

      case "video":

        return const SizedBox();

      case "file":

        return FileMessage(
          message: message,
        );

      default:

        return TextMessage(
          message: message,
        );
    }
  }
}