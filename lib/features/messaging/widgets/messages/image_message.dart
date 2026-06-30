import 'package:flutter/material.dart';

import '../../../../shared/models/message_model.dart';
import '../../screens/image_viewer_screen.dart';
import 'message_footer.dart';
import 'message_container.dart';

class ImageMessage extends StatelessWidget {

  final MessageModel message;

  const ImageMessage({

    super.key,

    required this.message,
  });

  @override
  Widget build(BuildContext context) {

    return MessageContainer(

      isMine: message.isMine,

      maxWidth: 280,

       
        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            ClipRRect(

              borderRadius: const BorderRadius.only(

                topLeft: Radius.circular(20),

                topRight: Radius.circular(20),
              ),

              child: GestureDetector(

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>

                          ImageViewerScreen(

                        imageUrl:

                            message.attachment ?? "",

                        heroTag:

                            message.id,
                      ),
                    ),
                  );
                },

                child: Hero(

                  tag: message.id,

                  child: Image.network(

                    message.attachment ?? "",

                    fit: BoxFit.cover,

                    width: double.infinity,

                    height: 220,

                    loadingBuilder:

                        (

                          context,

                          child,

                          progress,

                        ) {

                      if (progress == null) {

                        return child;
                      }

                      return SizedBox(

                        height: 220,

                        child: Center(

                          child:
                              CircularProgressIndicator(

                            value:

                                progress.expectedTotalBytes == null

                                    ? null

                                    : progress.cumulativeBytesLoaded /

                                        progress.expectedTotalBytes!,
                          ),
                        ),
                      );
                    },

                    errorBuilder:

                        (

                          context,

                          error,

                          stack,

                        ) {

                      return const SizedBox(

                        height: 220,

                        child: Center(

                          child: Icon(

                            Icons.broken_image,

                            size: 60,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            if (message.body.isNotEmpty)

              Padding(

                padding: const EdgeInsets.fromLTRB(
                  12,
                  10,
                  12,
                  0,
                ),

                child: Text(

                  message.body,

                  style: TextStyle(

                    color:

                        message.isMine

                            ? Colors.white

                            : Colors.black87,
                  ),
                ),
              ),

            Padding(

              padding: const EdgeInsets.only(

                left: 12,

                right: 12,

                bottom: 10,

                top: 6,
              ),

              child: Align(

                alignment:
                    Alignment.centerRight,

                child: MessageFooter(

                  time: message.time,

                  isMine: message.isMine,
                ),
              ),
            ),
          ],
        ),
      
    );
  }
}