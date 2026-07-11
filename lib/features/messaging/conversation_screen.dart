import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../messaging/models/attachment_model.dart';

import '../messaging/widgets/attachment_preview.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/models/conversation_detail_model.dart';
import '../../shared/models/message_model.dart';
import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';

import 'messaging_service.dart';
import 'websocket_service.dart';

import 'widgets/message_composer.dart';
import 'widgets/messages/message_bubble.dart';

class ConversationScreen extends StatefulWidget {

  final String conversationId;
  
  const ConversationScreen({

    super.key,

    required this.conversationId,
  });

  @override
  State<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState
    extends State<ConversationScreen> {

  ConversationDetailModel?
      conversation;

  bool loading = true;

  bool sending = false;

  String? error;

  
  AttachmentModel? attachment;
  //File? selectedAttachment;

  final messageController =
      TextEditingController();

  final scrollController =
      ScrollController();

  final MessagingWebSocketService
      webSocketService =
      MessagingWebSocketService();
  
  final MessagingService messagingService =
    MessagingService();

  final ImagePicker imagePicker =
      ImagePicker();

AttachmentModel createAttachment({

  required String name,

  required Uint8List bytes,

  required String mimeType,

  required int size,

  String? path,

}) {

  return AttachmentModel(

    name: name,

    bytes: bytes,

    mimeType: mimeType,

    size: size,

    path: path,

  );

}

  Future<void> loadConversation() async {

  try {

    error = null;

    final data =
        await MessagingService()
            .getConversation(
      widget.conversationId,
    );

    conversation =
        ConversationDetailModel
            .fromJson(
      data,
    );

    if (mounted) {

      setState(() {

        loading = false;
      });

      scrollToBottom();
    }

  } catch (e) {

    if (mounted) {

      setState(() {

        loading = false;

        error = e.toString();
      });
    }
  }
}


 Future<void> connectSocket() async {

  await webSocketService.connect(

    onMessage: (data) {
     
     
      print('-------------$data["message"]');

      if (data["event"] !="new_message") {
        return;
      }

      if (data["conversation_id"] != widget.conversationId) {
        return;
      }

      final message = MessageModel.fromJson(data["message"]);
     

      final exists =

          conversation?.messages.any(

                (m) =>
                    m.id ==
                    message.id,

              ) ??
              false;

      if (exists) {

        return;
      }

      if (!mounted) {

        return;
      }

      setState(() {

        conversation!
            .messages
            .add(message);
      });

      scrollToBottom();
    },
  );
}

Future<void> pickGallery() async {

  final picker = ImagePicker();

  final XFile? image =

      await picker.pickImage(

    source: ImageSource.gallery,

  );

  if (image == null) {

    return;

  }

  final bytes =

      await image.readAsBytes();

  setState(() {

    attachment = createAttachment(

      name: image.name,

      bytes: bytes,

      mimeType: "image/${image.name.split(".").last}",

      size: bytes.length,

      path: image.path,

    );

  });

}

 void scrollToBottom() {

  WidgetsBinding.instance
      .addPostFrameCallback((_) {

    if (!scrollController.hasClients) {

      return;
    }

    scrollController.animateTo(

      scrollController.position.maxScrollExtent,

      duration: const Duration(
        milliseconds: 300,
      ),

      curve: Curves.easeOut,
    );
  });
}

Future<void> pickCamera() async {

  final picker = ImagePicker();

  final XFile? image =

      await picker.pickImage(

    source: ImageSource.camera,

  );

  if (image == null) {

    return;

  }

  final bytes =

      await image.readAsBytes();

  setState(() {

    attachment = createAttachment(

      name: image.name,

      bytes: bytes,

      mimeType: "image/${image.name.split(".").last}",

      size: bytes.length,

      path: image.path,

    );

  });

}


Future<void> pickDocument() async {

  final result =
      //FilePicker.pickFiles
      await FilePicker.platform.pickFiles(

    withData: true,

  );

  if (result == null) {

    return;

  }

  final file = result.files.first;

  setState(() {

    attachment = createAttachment(

      name: file.name,

      bytes: file.bytes!,

     mimeType: MimeTypes.fromExtension(
        file.extension,
      ),
      size: file.size,

      path: file.path,

    );

  });

}

  Future<void> sendMessage() async {

    if (

        messageController.text.trim().isEmpty &&

        attachment == null

    ) {

        return;

    }

    try {

        setState(() {

            sending = true;

        });

        await messagingService.sendMessage(

            conversationId: widget.conversationId,

            body: messageController.text.trim(),

            attachment: attachment,

        );

        messageController.clear();

        setState(() {

            attachment = null;

        });

    } finally {

        if (mounted) {

            setState(() {

                sending = false;

            });

        }

    }

}

  void removeAttachment() {

    setState(() {

      attachment  = null;
    });
  }

  
  
  @override
  void initState() {

    super.initState();
    loadConversation();

    connectSocket();
  }

  @override
  void dispose() {

    webSocketService.disconnect();

    messageController.dispose();

    scrollController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context,) {

    if (loading) {

      return const Scaffold(

        body:
        LoadingView(),
      );
    }

    if (error != null) {

    return Scaffold(

      body: ErrorView(

        message: error!,

        onRetry: () {

          setState(() {

            loading = true;
          });

          loadConversation();
        },
      ),
    );
  }


    


    return Scaffold(

    backgroundColor: const Color(0xffF7F8FC),

    appBar: AppBar(

      elevation: 0,

      backgroundColor: Colors.white,

      foregroundColor: Colors.black,

      titleSpacing: 0,

      title: Row(

        children: [

          CircleAvatar(

            radius: 22,

            backgroundColor:
                const Color(0xff6214BE),

            child: Text(

              conversation!
                  .studentName[0]
                  .toUpperCase(),

              style: const TextStyle(

                color: Colors.white,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  conversation!.studentName,

                  style: const TextStyle(

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                Text(

                  conversation!.parentName,

                  style: TextStyle(

                    fontSize: 12,

                    color:
                        Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [

        IconButton(

          onPressed: () {},

          icon: const Icon(
            Icons.more_vert,
          ),
        ),
      ],
    ),
            body: Column(

        children: [

          Expanded(

            child: ListView.builder(

              controller:
                  scrollController,

              padding:
                  const EdgeInsets.all(16),

              itemCount:

                  conversation!
                      .messages
                      .length,

              itemBuilder:
                  (context, index) {

                final message =

                    conversation!
                        .messages[index];

                return MessageBubble(

                  message: message,
                );
              },
            ),
          ),

          if (attachment != null)

            Container(

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              color: Colors.white,

              child: Row(

                children: [

                  const Icon(
                    Icons.attach_file,
                    color: Color(0xff6214BE),
                  ),

                  const SizedBox(width: 8),

                  if (attachment != null)

                    AttachmentPreview(

                      attachment: attachment!,

                      onRemove: removeAttachment,

                    ),

                  IconButton(

                    onPressed: () {

                      setState(() {

                        attachment = null;
                      });
                    },

                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
            ),

          MessageComposer(

            controller: messageController,

            attachment: attachment,

            sending: sending,

            onGallery: pickGallery,

            onCamera: pickCamera,

            onDocument: pickDocument,

            onRemoveAttachment: removeAttachment,

            onSend: sendMessage,
          ),
        ],
      ),
    );
  }
}

class MimeTypes {

  static String fromExtension(
    String? extension,
  ) {

    switch (
      extension?.toLowerCase()
    ) {

      case "jpg":
      case "jpeg":
        return "image/jpeg";

      case "png":
        return "image/png";

      case "pdf":
        return "application/pdf";

      case "doc":
        return "application/msword";

      case "docx":
        return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";

      case "xls":
        return "application/vnd.ms-excel";

      case "xlsx":
        return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

      default:
        return "application/octet-stream";
    }
  }
}