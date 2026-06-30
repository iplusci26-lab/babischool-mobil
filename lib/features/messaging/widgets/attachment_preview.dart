import 'dart:io';

import 'package:flutter/material.dart';

class AttachmentPreview
extends StatelessWidget {

  final File file;

  final VoidCallback onRemove;

  const AttachmentPreview({

    super.key,

    required this.file,

    required this.onRemove,
  });

  bool get isImage {

    final path =
    file.path.toLowerCase();

    return

    path.endsWith(".png") ||

    path.endsWith(".jpg") ||

    path.endsWith(".jpeg");
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      margin:
      const EdgeInsets.only(

        bottom: 10,
      ),

      padding:
      const EdgeInsets.all(
        10,
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

          if (isImage)

            ClipRRect(

              borderRadius:

              BorderRadius.circular(
                10,
              ),

              child: Image.file(

                file,

                width: 60,

                height: 60,

                fit: BoxFit.cover,
              ),
            )

          else

            const Icon(

              Icons.picture_as_pdf,

              size: 50,

              color: Colors.red,
            ),

          const SizedBox(
            width: 12,
          ),

          Expanded(

            child: Text(

              file.path
                  .split("/")
                  .last,

              overflow:
              TextOverflow.ellipsis,
            ),
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