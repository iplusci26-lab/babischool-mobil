import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import '../../../shared/models/conversation_model.dart';

import '../../../shared/widgets/app_avatar.dart';

class ConversationTile extends StatelessWidget {

  final ConversationModel conversation;

  final VoidCallback onTap;

  const ConversationTile({

    super.key,

    required this.conversation,

    required this.onTap,
  });

  String _formatDate(DateTime date) {

  final now = DateTime.now();

  final difference = now.difference(date);

  if (difference.inDays == 0) {

    return "${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";
  }

  if (difference.inDays == 1) {

    return "Hier";
  }

  if (difference.inDays < 7) {

    const days = [

      "Lun",

      "Mar",

      "Mer",

      "Jeu",

      "Ven",

      "Sam",

      "Dim",
    ];

    return days[date.weekday - 1];
  }

  return "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}";
}

  IconData? _attachmentIcon() {

    

    if (

        conversation.lastMessage
            .startsWith("[PHOTO]")

    ) {

      return Icons.photo;
    }

    if (

        conversation.lastMessage
            .startsWith("[PDF]")

    ) {

      return Icons.picture_as_pdf;
    }

    return null;
  }

  String _message() {

    if (

        conversation.lastMessage
            .startsWith("[PHOTO]")

    ) {

      return "Photo";
    }

    if (

        conversation.lastMessage
            .startsWith("[PDF]")

    ) {

      return "Document PDF";
    }

    return conversation.lastMessage;
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return InkWell(

      onTap: onTap,

      borderRadius:
          BorderRadius.circular(
        22,
      ),

      child: Container(

        margin:
            const EdgeInsets.only(
          bottom: 14,
        ),

        padding:
            const EdgeInsets.all(
          18,
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

              color: Colors.black
                  .withValues(
                alpha: .04,
              ),

              blurRadius: 15,

              offset:
                  const Offset(
                0,
                6,
              ),
            ),
          ],
        ),

        child: Row(

          children: [

            AppAvatar(

              name:
                  conversation.studentName,

              radius: 28,
            ),

            const SizedBox(
              width: 16,
            ),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    conversation
                        .studentName,

                    maxLines: 1,

                    overflow:
                        TextOverflow
                            .ellipsis,

                    style:
                        const TextStyle(

                      fontSize: 16,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Row(

                    children: [

                      if (_attachmentIcon() !=
                          null)

                        Padding(

                          padding:
                              const EdgeInsets.only(
                            right: 4,
                          ),

                          child: Icon(

                            _attachmentIcon(),

                            size: 16,

                            color: Colors.grey,
                          ),
                        ),

                      Expanded(

                        child: Text(

                          _message(),

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              TextStyle(

                            color:
                                Colors.grey
                                    .shade600,

                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .end,

              children: [

                Text(

                  _formatDate(

                    conversation.updatedAt,
                  ),

                  style: TextStyle(

                    color:
                        Colors.grey
                            .shade500,

                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                if (conversation
                        .unreadCount >
                    0)

                  Container(

                    width: 24,

                    height: 24,

                    decoration:
                        const BoxDecoration(

                      color:
                          AppColors.primary,

                      shape:
                          BoxShape.circle,
                    ),

                    child: Center(

                      child: Text(

                        conversation
                            .unreadCount
                            .toString(),

                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                          fontWeight:
                              FontWeight.bold,

                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}