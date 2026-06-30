import 'package:flutter/material.dart';

class MessageFooter extends StatelessWidget {

  final String time;

  final bool isMine;

  final bool isRead;

  const MessageFooter({

    super.key,

    required this.time,

    required this.isMine,

    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisSize: MainAxisSize.min,

      mainAxisAlignment: MainAxisAlignment.end,

      children: [

        Text(

          time,

          style: TextStyle(

            fontSize: 11,

            color: isMine
                ? Colors.white70
                : Colors.grey,
          ),
        ),

        if (isMine) ...[

          const SizedBox(
            width: 4,
          ),

          Icon(

            isRead
                ? Icons.done_all
                : Icons.done,

            size: 15,

            color: isRead
                ? Colors.lightBlueAccent
                : Colors.white70,
          ),
        ],
      ],
    );
  }
}