import 'package:flutter/material.dart';

import '../../../../shared/models/message_model.dart';
import '../../screens/pdf_viewer_screen.dart';
import 'message_footer.dart';
import 'message_container.dart';

class PdfMessage extends StatelessWidget {

  final MessageModel message;

  const PdfMessage({

    super.key,

    required this.message,
  });

  @override
  Widget build(BuildContext context) {

    return MessageContainer(
        isMine: message.isMine,

        padding: const EdgeInsets.all(14),

      

        child: InkWell(

          borderRadius: BorderRadius.circular(16),

          onTap: () {

            Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) => PdfViewerScreen(

                    url: message.attachment ?? "",

                    title: message.attachmentName,
                  ),
                ),
              );
          },

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(

                children: [

                  Icon(

                    Icons.picture_as_pdf,

                    color: Colors.red,

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

              if (message.body.isNotEmpty) ...[

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