import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../shared/models/notification_model.dart';
import '../../shared/widgets/app_header.dart';

import 'notification_service.dart';
import 'widgets/notification_tile.dart';

import '../announcements/screens/announcement_detail_screen.dart';
import '../messaging/conversation_screen.dart';
import '../payments/payment_history_screen.dart';
import '../attendance/attendance_tab.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];

  bool loading = true;

  int selectedTab = 0;

  final List<String> filters = [
    "Toutes",
    "Non lues",
    "Annonces",
    "Paiements",
  ];

  Future<void> loadData() async {
    await initializeDateFormatting("fr");

    final data =
        await NotificationService()
            .getNotifications();

    notifications =
        data
            .map<NotificationModel>(
              (e) => NotificationModel.fromJson(e),
            )
            .toList();

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

Future<void> _markAsRead(NotificationModel notification,) async {

  if (notification.isRead) return;

  final index =
      notifications.indexWhere(
    (e) => e.id == notification.id,
  );

  if (index == -1) return;

  final updated =
      NotificationModel(
    id: notification.id,
    title: notification.title,
    message: notification.message,
    type: notification.type,
    isRead: true,
    url: notification.url,
    createdAt:
        notification.createdAt,
    objectId: notification.objectId,
    targetType: notification.objectId,
  );

  setState(() {
    notifications[index] = updated;
  });

  try {
    await NotificationService()
        .markAsRead(
      notification.id,
    );
  } catch (_) {
    setState(() {
      notifications[index] =
          notification;
    });
  }
}


Future<void> _openActivity(
    NotificationModel notification,
) async {

    await _markAsRead(
        notification,
    );
    
    final targetId =
        int.tryParse(
            notification.objectId,
        );

    switch (
        notification.targetType
    ) {
        
        case "announcement":

            if (notification.objectId == null) return;

            Navigator.push(

                context,

                MaterialPageRoute(

                    builder: (_) =>

                        AnnouncementDetailScreen(

                            announcementId: notification.objectId,

                        ),

                ),

            );

            break;

        case "message":

            if (notification.objectId == null) return;

            Navigator.push(

                context,

                MaterialPageRoute(

                    builder: (_) =>

                        ConversationScreen(

                            conversationId: notification.objectId,

                        ),

                ),

            );

            break;

        case "payment":

            ScaffoldMessenger.of(context).showSnackBar(

              const SnackBar(

              content: Text(

              "Ouverture des paiements bientôt disponible.",

              ),

              ),

              );

            break;

        case "attendance":

            ScaffoldMessenger.of(context).showSnackBar(

                    const SnackBar(

                    content: Text(

                    "Ouverture des présences bientôt disponible.",

                    ),

                    ),

                    );


            break;

    }

}

  List<NotificationModel> get filteredNotifications {
    switch (selectedTab) {
      case 1:
        return notifications
            .where((e) => !e.isRead)
            .toList();

      case 2:
        return notifications
            .where(
              (e) =>
                  e.type ==
                  "announcement",
            )
            .toList();

      case 3:
        return notifications
            .where(
              (e) =>
                  e.type ==
                  "payment",
            )
            .toList();

      default:
        return notifications;
    }
  }

  Map<String, List<NotificationModel>>
      get groupedNotifications {
    final Map<
        String,
        List<NotificationModel>> groups = {};

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    for (final notification
        in filteredNotifications) {
      final date = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      String key;

      if (date == today) {
        key = "Aujourd'hui";
      } else if (date == yesterday) {
        key = "Hier";
      } else {
        key = DateFormat(
          "d MMMM",
          "fr",
        ).format(date);
      }

      groups.putIfAbsent(
        key,
        () => [],
      );

      groups[key]!.add(notification);
    }

    return groups;
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadData,

              child: SafeArea(
                child: Column(
                  children: [

                    const Padding(
                      padding: EdgeInsets.fromLTRB(0,0,0,0,),
                      child: AppHeader(
                        title: "Notifications",
                        subtitle: "Restez informé sur la vie scolaire de vos enfants",
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 42,

                      child: ListView.separated(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),

                        scrollDirection:
                            Axis.horizontal,

                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(
                                  width: 10,
                                ),

                        itemCount: filters.length,

                        itemBuilder: (
                          context,
                          index,
                        ) {
                          final selected =
                              selectedTab ==
                                  index;

                          return InkWell(
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),

                            onTap: () {
                              setState(() {
                                selectedTab =
                                    index;
                              });
                            },

                            child: AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds: 200,
                              ),

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: selected
                                    ? const Color(
                                        0xFF6214BE,
                                      )
                                    : Colors.white,

                                borderRadius:
                                    BorderRadius.circular(
                                  30,
                                ),

                                border: Border.all(
                                  color: selected
                                      ? const Color(
                                          0xFF6214BE,
                                        )
                                      : Colors.grey
                                          .shade300,
                                ),
                              ),

                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min,

                                children: [

                                  Text(
                                    filters[index],

                                    style:
                                        TextStyle(
                                      color: selected
                                          ? Colors
                                              .white
                                          : Colors
                                              .black87,

                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),

                                  if (index == 1 &&
                                      notifications.any(
                                        (e) =>
                                            !e.isRead,
                                      )) ...[
                                    const SizedBox(
                                      width: 6,
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            6,
                                        vertical:
                                            2,
                                      ),

                                      decoration:
                                          const BoxDecoration(
                                        color:
                                            Colors.red,

                                        shape:
                                            BoxShape.circle,
                                      ),

                                      child: Text(
                                        notifications
                                            .where(
                                              (e) =>
                                                  !e.isRead,
                                            )
                                            .length
                                            .toString(),

                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize:
                                              10,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),

                        children:
                            groupedNotifications.entries
                                .map(
                                  (group) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(
                                          bottom: 12,
                                          top: 8,
                                        ),
                                        child: Text(
                                          group.key,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        decoration:
                                            BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(
                                            18,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(
                                                .04,
                                              ),
                                              blurRadius: 18,
                                              offset:
                                                  const Offset(
                                                0,
                                                6,
                                              ),
                                            ),
                                          ],
                                        ),

                                        child: Column(
                                          children:
                                              List.generate(
                                            group.value.length,
                                            (index) {
                                              return Column(
                                                children: [

                                                 Dismissible(

                                                    key: ValueKey(
                                                      group.value[index].id,
                                                    ),

                                                    direction:
                                                        DismissDirection.endToStart,

                                                    confirmDismiss: (_) async {

                                                      if (!group.value[index].isRead) {

                                                        await _markAsRead(
                                                            group.value[index],
                                                        );

                                                      }

                                                      return false;

                                                    },

                                                    background: Container(

                                                      alignment:
                                                          Alignment.centerRight,

                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 24,
                                                      ),

                                                      decoration: BoxDecoration(

                                                        color: Colors.green,

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          16,
                                                        ),

                                                      ),

                                                      child: const Icon(

                                                        Icons.done,

                                                        color: Colors.white,

                                                      ),

                                                    ),

                                                    child: Padding(

                                                      padding:
                                                          const EdgeInsets.symmetric(

                                                        horizontal: 16,

                                                        vertical: 6,

                                                      ),

                                                      child: NotificationTile(

                                                        notification:
                                                            group.value[index],

                                                        onTap: () =>
                                                            _openActivity(
                                                          group.value[index],
                                                        ),

                                                      ),

                                                    ),

                                                  ),
                                                  if (index !=
                                                      group.value
                                                              .length -
                                                          1)
                                                    Divider(
                                                      height: 1,
                                                      indent: 72,
                                                      endIndent: 16,
                                                      color: Colors
                                                          .grey
                                                          .shade200,
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 24,
                                      ),
                                    ],
                                  );
                                },
                              )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}