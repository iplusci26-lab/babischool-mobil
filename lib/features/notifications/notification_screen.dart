import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../shared/models/notification_model.dart';
import '../../shared/widgets/app_header.dart';

import 'notification_service.dart';
import 'widgets/notification_tile.dart';

import '../announcements/screens/announcement_detail_screen.dart';
import '../messaging/conversation_screen.dart';

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
  // ============================================================
  // ÉTAT
  // ============================================================

  List<NotificationModel> notifications = [];

  bool loading = true;

  int selectedTab = 0;

  // ============================================================
  // FILTRES
  // ============================================================

  final List<String> filters = [
    "Toutes",
    "Non lues",
    "Annonces",
    "Paiements",
  ];

  // ============================================================
  // SERVICE
  // ============================================================

  final NotificationService notificationService =
      NotificationService();

  // ============================================================
  // CHARGEMENT
  // ============================================================

  Future<void> loadData() async {
    await initializeDateFormatting("fr");

    try {
      final data =
          await notificationService.getNotifications();

      final loadedNotifications =
          data
              .map<NotificationModel>(
                (e) => NotificationModel.fromJson(e),
              )
              .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        notifications = loadedNotifications;
        loading = false;
      });
    } catch (e) {
      debugPrint(
        "Erreur chargement notifications : $e",
      );

      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });
    }
  }

  // ============================================================
  // NOMBRE DE NOTIFICATIONS NON LUES
  // ============================================================

  int get unreadCount {
    return notifications
        .where(
          (notification) => !notification.isRead,
        )
        .length;
  }

  // ============================================================
  // MARQUER UNE NOTIFICATION COMME LUE
  // ============================================================

  Future<void> _markAsRead(
    NotificationModel notification,
  ) async {
    if (notification.isRead) {
      return;
    }

    final index = notifications.indexWhere(
      (e) => e.id == notification.id,
    );

    if (index == -1) {
      return;
    }

    // ----------------------------------------------------------
    // Sauvegarde de l'ancienne notification
    // ----------------------------------------------------------

    final previousNotification =
        notifications[index];

    // ----------------------------------------------------------
    // Mise à jour optimiste
    // ----------------------------------------------------------

    final updated = NotificationModel(
      id: notification.id,
      title: notification.title,
      message: notification.message,
      type: notification.type,
      isRead: true,
      url: notification.url,
      createdAt: notification.createdAt,
      objectId: notification.objectId,
      targetType: notification.targetType,
    );

    setState(() {
      notifications[index] = updated;
    });

    try {
      await notificationService.markAsRead(
        notification.id,
      );
    } catch (e) {
      debugPrint(
        "Erreur marquage notification comme lue : $e",
      );

      // --------------------------------------------------------
      // Rollback si l'API échoue
      // --------------------------------------------------------

      if (!mounted) {
        return;
      }

      setState(() {
        notifications[index] =
            previousNotification;
      });
    }
  }

  // ============================================================
  // OUVERTURE D'UNE NOTIFICATION
  // ============================================================

  Future<void> _openActivity(
    NotificationModel notification,
  ) async {
    // ----------------------------------------------------------
    // Marquer comme lue AVANT l'ouverture
    // ----------------------------------------------------------

    await _markAsRead(
      notification,
    );

    if (!mounted) {
      return;
    }

    // ----------------------------------------------------------
    // Navigation selon le type
    // ----------------------------------------------------------

    switch (notification.targetType) {
      // ========================================================
      // ANNONCE
      // ========================================================

      case "announcement":
        if (notification.objectId == null) {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AnnouncementDetailScreen(
              announcementId:
                  notification.objectId!,
            ),
          ),
        );

        break;

      // ========================================================
      // MESSAGE
      // ========================================================

      case "message":
        if (notification.objectId == null) {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ConversationScreen(
              conversationId:
                  notification.objectId!,
            ),
          ),
        );

        break;

      // ========================================================
      // PAIEMENT
      // ========================================================

      case "payment":
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Ouverture des paiements bientôt disponible.",
            ),
          ),
        );

        break;

      // ========================================================
      // PRÉSENCE
      // ========================================================

      case "attendance":
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Ouverture des présences bientôt disponible.",
            ),
          ),
        );

        break;
    }
  }

  // ============================================================
  // FILTRE
  // ============================================================

  List<NotificationModel>
      get filteredNotifications {
    switch (selectedTab) {
      case 1:
        return notifications
            .where(
              (e) => !e.isRead,
            )
            .toList();

      case 2:
        return notifications
            .where(
              (e) =>
                  e.type == "announcement",
            )
            .toList();

      case 3:
        return notifications
            .where(
              (e) => e.type == "payment",
            )
            .toList();

      default:
        return notifications;
    }
  }

  // ============================================================
  // GROUPEMENT PAR DATE
  // ============================================================

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

  // ============================================================
  // RETOUR VERS APPHEADER
  // ============================================================

  void _closeScreen() {
    Navigator.of(context).pop(
      unreadCount,
    );
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadData();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return PopScope<int>(
      canPop: false,
      onPopInvokedWithResult: (
        didPop,
        result,
      ) {
        if (didPop) {
          return;
        }

        _closeScreen();
      },
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF7F8FC),
        body: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: loadData,
                child: SafeArea(
                  child: Column(
                    children: [
                      // ==================================================
                      // HEADER
                      // ==================================================

                      const Padding(
                        padding:
                            EdgeInsets.zero,
                        child: AppHeader(
                          title:
                              "Notifications",
                          subtitle:
                              "Restez informé sur la vie scolaire de vos enfants",
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // ==================================================
                      // FILTRES
                      // ==================================================

                      SizedBox(
                        height: 42,
                        child:
                            ListView.separated(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 20,
                          ),
                          scrollDirection:
                              Axis.horizontal,
                          separatorBuilder:
                              (_, __) =>
                                  const SizedBox(
                            width: 10,
                          ),
                          itemCount:
                              filters.length,
                          itemBuilder:
                              (
                            context,
                            index,
                          ) {
                            final selected =
                                selectedTab ==
                                    index;

                            final unread =
                                unreadCount;

                            return InkWell(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                30,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedTab =
                                      index;
                                });
                              },
                              child:
                                  AnimatedContainer(
                                duration:
                                    const Duration(
                                  milliseconds:
                                      200,
                                ),
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      18,
                                  vertical: 10,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: selected
                                      ? const Color(
                                          0xFF6214BE,
                                        )
                                      : Colors
                                          .white,
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    30,
                                  ),
                                  border:
                                      Border.all(
                                    color: selected
                                        ? const Color(
                                            0xFF6214BE,
                                          )
                                        : Colors
                                            .grey
                                            .shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,
                                  children: [
                                    Text(
                                      filters[
                                          index],
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

                                    // --------------------------------
                                    // BADGE NON LUES
                                    // --------------------------------

                                    if (index ==
                                            1 &&
                                        unread >
                                            0) ...[
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal:
                                              6,
                                          vertical:
                                              2,
                                        ),
                                        decoration:
                                            const BoxDecoration(
                                          color:
                                              Colors
                                                  .red,
                                          shape:
                                              BoxShape
                                                  .circle,
                                        ),
                                        child: Text(
                                          unread
                                              .toString(),
                                          style:
                                              const TextStyle(
                                            color: Colors
                                                .white,
                                            fontSize:
                                                10,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
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

                      const SizedBox(
                        height: 20,
                      ),

                      // ==================================================
                      // LISTE
                      // ==================================================

                      Expanded(
                        child: ListView(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 20,
                          ),
                          children:
                              groupedNotifications
                                  .entries
                                  .map(
                            (group) {
                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                      bottom: 12,
                                      top: 8,
                                    ),
                                    child: Text(
                                      group.key,
                                      style:
                                          const TextStyle(
                                        fontSize:
                                            18,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .white,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        18,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .black
                                              .withOpacity(
                                            .04,
                                          ),
                                          blurRadius:
                                              18,
                                          offset:
                                              const Offset(
                                            0,
                                            6,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child:
                                        Column(
                                      children:
                                          List.generate(
                                        group.value
                                            .length,
                                        (index) {
                                          final notification =
                                              group.value[
                                                  index];

                                          return Column(
                                            children: [
                                              // ==================================
                                              // SWIPE
                                              // ==================================

                                              Dismissible(
                                                key:
                                                    ValueKey(
                                                  notification
                                                      .id,
                                                ),
                                                direction:
                                                    DismissDirection
                                                        .endToStart,
                                                confirmDismiss:
                                                    (_) async {
                                                  if (!notification
                                                      .isRead) {
                                                    await _markAsRead(
                                                      notification,
                                                    );
                                                  }

                                                  return false;
                                                },
                                                background:
                                                    Container(
                                                  alignment:
                                                      Alignment
                                                          .centerRight,
                                                  padding:
                                                      const EdgeInsets
                                                          .only(
                                                    right:
                                                        24,
                                                  ),
                                                  decoration:
                                                      BoxDecoration(
                                                    color:
                                                        Colors.green,
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                      16,
                                                    ),
                                                  ),
                                                  child:
                                                      const Icon(
                                                    Icons
                                                        .done,
                                                    color:
                                                        Colors.white,
                                                  ),
                                                ),

                                                // ==================================
                                                // TILE
                                                // ==================================

                                                child:
                                                    Padding(
                                                  padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal:
                                                        16,
                                                    vertical:
                                                        6,
                                                  ),
                                                  child:
                                                      NotificationTile(
                                                    notification:
                                                        notification,
                                                    onTap:
                                                        () =>
                                                            _openActivity(
                                                      notification,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              if (index !=
                                                  group.value.length -
                                                      1)
                                                Divider(
                                                  height:
                                                      1,
                                                  indent:
                                                      72,
                                                  endIndent:
                                                      16,
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
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}