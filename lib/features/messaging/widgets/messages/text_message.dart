import 'package:flutter/material.dart';

import '../../../../shared/models/message_model.dart';

import 'message_footer.dart';
import 'message_container.dart';

class TextMessage extends StatelessWidget {

  final MessageModel message;

  const TextMessage({

    super.key,

    required this.message,
  });

  @override
  Widget build(BuildContext context) {

  return MessageContainer(

  isMine: message.isMine,

  padding: const EdgeInsets.all(14),

  child: Column(

    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      if(message.body.isNotEmpty)

        Text(

          message.body,

          style: TextStyle(

            color:

            message.isMine

                ? Colors.white

                : Colors.black87,
          ),
        ),

      const SizedBox(
        height: 8,
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
);
  }
}