import 'package:flutter/material.dart';

import '../../../shared/models/notification_model.dart';

class NotificationTile
    extends StatelessWidget {

  final NotificationModel notification;

  const NotificationTile({

    super.key,

    required this.notification,
  });

  IconData get icon {

    switch (notification.type) {

      case "announcement":
        return Icons.campaign;

      case "payment":
        return Icons.payments;

      case "message":
        return Icons.chat_bubble;

      case "attendance":
        return Icons.check_circle;

      default:
        return Icons.notifications;
    }
  }

  Color get iconColor {

    switch (notification.type) {

      case "announcement":
        return Colors.orange;

      case "payment":
        return Colors.green;

      case "message":
        return Colors.blue;

      case "attendance":
        return Colors.teal;

      default:
        return const Color(
          0xff6214BE,
        );
    }
  }

  String get timeAgo {

    final now =
        DateTime.now();

    final diff =
        now.difference(
      notification.createdAt,
    );

    if (diff.inMinutes < 1) {

      return "à l'instant";
    }

    if (diff.inMinutes < 60) {

      return
      "il y a ${diff.inMinutes} min";
    }

    if (diff.inHours < 24) {

      return
      "il y a ${diff.inHours} h";
    }

    return
    "il y a ${diff.inDays} j";
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
      const EdgeInsets.all(
        16,
      ),

      decoration:
      BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          22,
        ),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withValues(
              alpha: 0.05,
            ),

            blurRadius: 12,

            offset:
            const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(

            width: 52,

            height: 52,

            decoration:
            BoxDecoration(

              color:
              iconColor.withValues(
                alpha: 0.12,
              ),

              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(

              icon,

              color: iconColor,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(

                  children: [

                    Expanded(

                      child: Text(

                        notification.title,

                        style:
                        const TextStyle(

                          fontSize: 16,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    if (
                    !notification.isRead
                    )

                    Container(

                      width: 10,

                      height: 10,

                      decoration:
                      const BoxDecoration(

                        color: Colors.red,

                        shape:
                        BoxShape.circle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(

                  notification.message,

                  style: TextStyle(

                    color:
                    Colors.grey.shade700,

                    height: 1.4,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(

                  timeAgo,

                  style: TextStyle(

                    color:
                    Colors.grey.shade500,

                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}