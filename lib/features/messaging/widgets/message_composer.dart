import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import 'attachment_preview.dart';

class MessageComposer
extends StatelessWidget {

  final TextEditingController
  controller;

  final File? attachment;

  final VoidCallback onGallery;

  final VoidCallback onCamera;

  final VoidCallback onDocument;

  final VoidCallback onRemoveAttachment;

  final VoidCallback onSend;

  final bool sending;

  const MessageComposer({

    super.key,

    required this.controller,

    required this.attachment,

    required this.onGallery,

    required this.onCamera,

    required this.onDocument,

    required this.onRemoveAttachment,

    required this.onSend,

    required this.sending,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return SafeArea(

      child: Container(

        padding:
        const EdgeInsets.all(
          12,
        ),

        decoration:
        const BoxDecoration(

          color: Colors.white,

          boxShadow: [

            BoxShadow(

              blurRadius: 10,

              color:
              Colors.black12,
            ),
          ],
        ),

        child: Column(

          mainAxisSize:
          MainAxisSize.min,

          children: [

            if (
                attachment != null)

              AttachmentPreview(

                file:
                attachment!,

                onRemove:
                onRemoveAttachment,
              ),

            Row(

              children: [

                PopupMenuButton<String>(

                  icon: const Icon(

                    Icons.attach_file,

                    color: AppColors.primary,
                  ),

                  onSelected: (value) {

                    switch (value) {

                      case "gallery":

                        onGallery();

                        break;

                      case "camera":

                        onCamera();

                        break;

                      case "document":

                        onDocument();

                        break;
                    }
                  },

                  itemBuilder: (_) => const [

                    PopupMenuItem(

                      value: "gallery",

                      child: Row(

                        children: [

                          Icon(Icons.photo),

                          SizedBox(width: 10),

                          Text("Galerie"),
                        ],
                      ),
                    ),

                    PopupMenuItem(

                      value: "camera",

                      child: Row(

                        children: [

                          Icon(Icons.camera_alt),

                          SizedBox(width: 10),

                          Text("Caméra"),
                        ],
                      ),
                    ),

                    PopupMenuItem(

                      value: "document",

                      child: Row(

                        children: [

                          Icon(Icons.description),

                          SizedBox(width: 10),

                          Text("Document"),
                        ],
                      ),
                    ),
                  ],
                ),

                Expanded(

                  child: TextField(
                    
                    enabled: !sending,
                    controller:
                    controller,

                    minLines: 1,

                    maxLines: 5,

                    decoration:

                    InputDecoration(

                      hintText:
                      "Votre message...",

                      filled: true,

                      fillColor:
                      Colors.grey.shade100,

                      border:
                      OutlineInputBorder(

                        borderRadius:

                        BorderRadius.circular(
                          30,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                InkWell(

                  onTap: sending ? null : onSend,

                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),

                  child: Container(

                    width: 52,

                    height: 52,

                    decoration:
                    const BoxDecoration(

                      color:
                      AppColors.primary,

                      shape:
                      BoxShape.circle,
                    ),

                    child: sending

                    ? const SizedBox(

                        width: 22,

                        height: 22,

                        child: CircularProgressIndicator(

                          strokeWidth: 2,

                          color: Colors.white,
                        ),
                      )
                      :const Icon(

                        Icons.send,

                        color:
                        Colors.white,
                      ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}