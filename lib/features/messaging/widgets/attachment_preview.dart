import 'package:flutter/material.dart';
import '../models/attachment_model.dart';

class AttachmentPreview
extends StatelessWidget {

  final AttachmentModel  attachment;

  final VoidCallback onRemove;

  const AttachmentPreview({

    super.key,

    required this.attachment,

    required this.onRemove,
  });

  

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      margin: const EdgeInsets.only(

        bottom: 12,
      ),

      padding:
      const EdgeInsets.all(
        12,
      ),

      decoration:
      BoxDecoration(

        color:
        Colors.grey.shade100,

        borderRadius:
        BorderRadius.circular(
          16,
        ),
      ),

      child: Row(

        children: [

          if (attachment.isImage)

            ClipRRect(

              borderRadius:

              BorderRadius.circular(
                12,
              ),

              child: Image.memory(

                attachment.bytes,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            )

          else

            const Icon(

              Icons.insert_drive_file,

              size: 42,

              color: Colors.red,
            ),

          const SizedBox(
            width: 12,
          ),

          Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                attachment.name,
              ),

              Text(

                attachment.formattedSize,

                style: TextStyle(

                  color: Colors.grey,

                  fontSize: 12,
                ),
              ),
            ],
          ),

          IconButton(

            onPressed:
            onRemove,

            icon:
            const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
    );
  }
}