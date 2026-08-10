import 'package:flutter/material.dart';

import '../../../shared/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  IconData get icon {
    switch (notification.type) {
      case "announcement":
        return Icons.campaign_rounded;

      case "payment":
        return Icons.account_balance_wallet_rounded;

      case "message":
        return Icons.chat_bubble_rounded;

      case "attendance":
        return Icons.assignment_late_rounded;

      default:
        return Icons.notifications_rounded;
    }
  }

  Color get iconColor {
    switch (notification.type) {
      case "announcement":
        return const Color(0xFF6214BE);

      case "payment":
        return const Color(0xFF18B26B);

      case "message":
        return const Color(0xFF3B82F6);

      case "attendance":
        return const Color(0xFFFF8A00);

      default:
        return const Color(0xFF6214BE);
    }
  }

  String get timeAgo {
    final now = DateTime.now();

    final diff = now.difference(
      notification.createdAt,
    );

    if (diff.inMinutes < 1) {
      return "à l'instant";
    }

    if (diff.inMinutes < 60) {
      return "il y a ${diff.inMinutes} min";
    }

    if (diff.inHours < 24) {
      return "il y a ${diff.inHours} h";
    }

    return "il y a ${diff.inDays} j";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(.12),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
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
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration:
                              const BoxDecoration(
                            color: Colors.red,
                            shape:
                                BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color:
                          Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}