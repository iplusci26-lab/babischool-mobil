import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ConversationCard extends StatelessWidget {
  final String name;
  final String role;
  final String studentName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String lastMessageType;
  final String? avatarUrl;
  final VoidCallback onTap;

  const ConversationCard({
    super.key,
    required this.name,
    required this.role,
    required this.studentName,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.onTap,
    required this.lastMessageType,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ), 
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "$role  ( à propos de  •$studentName• )",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _buildLastMessage(),
                        ),

                        if (unreadCount > 0) ...[
                          const SizedBox(width: 10),
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount > 99
                                  ? "99+"
                                  : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.primary.withOpacity(.12),
      child: Icon(
        Icons.person,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildLastMessage() {
  IconData? icon;

  switch (lastMessageType) {
    case "image":
      icon = Icons.photo;
      break;

    case "pdf":
      icon = Icons.picture_as_pdf;
      break;

    case "audio":
      icon = Icons.mic;
      break;

    case "video":
      icon = Icons.videocam;
      break;

    case "file":
      icon = Icons.attach_file;
      break;
  }

  return Row(
    children: [
      if (icon != null) ...[
        Icon(
          icon,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
      ],

      Expanded(
        child: Text(
          lastMessage.isEmpty ? "Aucun message" : lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}
}