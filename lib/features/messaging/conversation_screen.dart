import 'dart:io';

import 'package:file_picker/file_picker.dart';

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

  

  File? selectedAttachment;

  final messageController =
      TextEditingController();

  final scrollController =
      ScrollController();

  final MessagingWebSocketService
      webSocketService =
      MessagingWebSocketService();

  final ImagePicker imagePicker =
      ImagePicker();



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
     

      if (data["event"] !="new_message") {
        return;
      }

      if (

      data["conversation_id"] != widget.conversationId) {
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

Future<void> pickImage() async {

  final image =

      await imagePicker.pickImage(

    source: ImageSource.gallery,

    imageQuality: 80,
  );

  if (image == null) {

    return;
  }

  setState(() {

    selectedAttachment =
        File(image.path);
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

  final image = await imagePicker.pickImage(

    source: ImageSource.camera,

    imageQuality: 80,
  );

  if (image == null) return;

  setState(() {

    selectedAttachment = File(image.path);

  });
}

 

 Future<void> pickDocument() async {

  final result = await FilePicker.pickFiles(

    type: FileType.custom,

    allowedExtensions: const [
      "pdf",
    ],
  );

  if (result == null) {
    return;
  }

  setState(() {
    selectedAttachment = File(
      result.files.single.path!,
    );
  });
}

  Future<void> sendMessage() async {

  if (sending) {

    return;
  }

  if (

      messageController.text
          .trim()
          .isEmpty &&

      selectedAttachment == null) {

    return;
  }

  setState(() {

    sending = true;
  });

  try {

    await MessagingService()
        .sendMessage(

      conversationId:
          widget.conversationId,

      body:
          messageController.text,

      attachment:
          selectedAttachment,
    );

    messageController.clear();

    selectedAttachment = null;

    if (mounted) {

      setState(() {});
    }

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(
          e.toString(),
        ),
      ),
    );

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

      selectedAttachment = null;
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

          if (selectedAttachment != null)

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

                  Expanded(

                    child: Text(

                      selectedAttachment!.path
                          .split("/")
                          .last,

                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ),

                  IconButton(

                    onPressed: () {

                      setState(() {

                        selectedAttachment = null;
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

            attachment: selectedAttachment,

            sending: sending,

            onGallery: pickImage,

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