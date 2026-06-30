import 'package:flutter/material.dart';

import '../../../../shared/models/message_model.dart';

import 'message_footer.dart';
import 'message_container.dart';

class FileMessage extends StatelessWidget {

  final MessageModel message;

  const FileMessage({

    super.key,

    required this.message,
  });

  IconData _icon() {

    final name =
        message.attachmentName.toLowerCase();

    if (name.endsWith(".doc") ||
        name.endsWith(".docx")) {

      return Icons.description;
    }

    if (name.endsWith(".xls") ||
        name.endsWith(".xlsx")) {

      return Icons.table_chart;
    }

    if (name.endsWith(".ppt") ||
        name.endsWith(".pptx")) {

      return Icons.slideshow;
    }

    if (name.endsWith(".zip") ||
        name.endsWith(".rar")) {

      return Icons.folder_zip;
    }

    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {

    return MessageContainer(

        isMine: message.isMine,

        padding: const EdgeInsets.all(14),

       

        child: InkWell(

          borderRadius:
              BorderRadius.circular(16),

          onTap: () {
            
             if (message.attachment == null) {

              return;
            }

            // ouverture du fichier
          },

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(

                children: [

                  Icon(

                    _icon(),

                    color: Colors.deepPurple,

                    size: 40,
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(

                          message.attachmentName,

                          maxLines: 2,

                          overflow:
                              TextOverflow.ellipsis,

                          style: TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            color: message.isMine

                                ? Colors.white

                                : Colors.black87,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(

                          message.attachmentSizeLabel,

                          style: TextStyle(

                            color: message.isMine

                                ? Colors.white70

                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (message.body.isNotEmpty)...[

                const SizedBox(
                  height: 10,
                ),

                Text(

                  message.body,

                  style: TextStyle(

                    color: message.isMine

                        ? Colors.white

                        : Colors.black87,
                  ),
                ),
              ],

              const SizedBox(
                height: 10,
              ),

              Align(

                alignment:
                    Alignment.centerRight,

                child: MessageFooter(

                  time: message.time,

                  isMine: message.isMine,
                ),
              ),
            ],
          ),
        ),
      );
    
  }
}