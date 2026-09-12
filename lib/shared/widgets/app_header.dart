import 'package:flutter/material.dart';

import 'app_logo.dart';

import '../../features/notifications/notification_screen.dart';
import '../../features/notifications/notification_service.dart';
import '../../features/notifications/notification_websocket_service.dart';

class AppHeader extends StatefulWidget {
  // ============================================================
  // CONTENU
  // ============================================================

  final String title;

  final String? subtitle;

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  final bool showNotification;

  /// Compteur éventuellement fourni par l'écran parent.
  ///
  /// Si null, AppHeader utilise son propre compteur.
  final int? notificationCount;

  /// Action personnalisée lors du clic sur la cloche.
  ///
  /// Si null, AppHeader ouvre automatiquement
  /// NotificationScreen.
  final VoidCallback? onNotificationTap;

  // ============================================================
  // ACTIONS
  // ============================================================

  final Widget? trailing;

  final VoidCallback? onLogoTap;

  final VoidCallback? onBack;

  // ============================================================
  // CONSTRUCTEUR
  // ============================================================

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showNotification = true,
    this.notificationCount,
    this.onNotificationTap,
    this.trailing,
    this.onLogoTap,
    this.onBack,
  });

  @override
  State<AppHeader> createState() =>
      _AppHeaderState();
}

// =================================================================
// STATE
// =================================================================

class _AppHeaderState extends State<AppHeader> {
  // ============================================================
  // SERVICES
  // ============================================================

  final NotificationService notificationService =
      NotificationService();

  final NotificationWebSocketService
      notificationSocket =
      NotificationWebSocketService();

  // ============================================================
  // ÉTAT
  // ============================================================

  int unreadCount = 0;

  bool loadingNotifications = false;

  /// Compteur local obtenu après le retour de
  /// NotificationScreen.
  ///
  /// Il devient prioritaire sur la valeur fournie
  /// par le parent.
  int? localNotificationCount;

  // ============================================================
  // COMPTEUR À AFFICHER
  // ============================================================

  int get displayedNotificationCount {
    return localNotificationCount ??
        widget.notificationCount ??
        unreadCount;
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _initializeNotifications();
  }

  // ============================================================
  // INITIALISATION NOTIFICATIONS
  // ============================================================

  Future<void> _initializeNotifications() async {
    await _loadUnreadCount();

    if (!mounted) {
      return;
    }

    try {
      await notificationSocket.connect(
        onNotification: (data) {
          if (!mounted) {
            return;
          }

          debugPrint(
            "NEW NOTIFICATION => $data",
          );

          // ----------------------------------------------------
          // Une nouvelle notification invalide le compteur
          // local précédent.
          // ----------------------------------------------------

          setState(() {
            localNotificationCount = null;
          });

          // ----------------------------------------------------
          // Si le parent fournit le compteur, on ne le modifie
          // pas directement.
          // ----------------------------------------------------

          if (widget.notificationCount != null) {
            return;
          }

          setState(() {
            unreadCount++;
          });
        },
      );
    } catch (e) {
      debugPrint(
        "Erreur WebSocket notifications : $e",
      );
    }
  }

  // ============================================================
  // CHARGER COMPTEUR
  // ============================================================

  Future<void> _loadUnreadCount() async {
    if (loadingNotifications) {
      return;
    }

    loadingNotifications = true;

    try {
      final count =
          await notificationService
              .getUnreadCount();

      if (!mounted) {
        return;
      }

      setState(() {
        unreadCount = count;
      });

      // --------------------------------------------------------
      // Si aucune valeur locale n'est imposée,
      // le compteur API devient la source actuelle.
      // --------------------------------------------------------

      if (localNotificationCount == null) {
        setState(() {
          unreadCount = count;
        });
      }
    } catch (e) {
      debugPrint(
        "Erreur récupération notifications : $e",
      );
    } finally {
      loadingNotifications = false;
    }
  }

  // ============================================================
  // CLIC SUR NOTIFICATION
  // ============================================================

  Future<void> _handleNotificationTap() async {
    debugPrint(
      "🔔 AppHeader : clic sur la cloche",
    );

    // ==========================================================
    // CAS 1 : ACTION PERSONNALISÉE
    // ==========================================================

    if (widget.onNotificationTap != null) {
      debugPrint(
        "🔔 AppHeader : utilisation de onNotificationTap",
      );

      widget.onNotificationTap!();

      return;
    }

    // ==========================================================
    // CAS 2 : NAVIGATION AUTOMATIQUE
    // ==========================================================

    debugPrint(
      "🔔 AppHeader : ouverture de NotificationScreen",
    );

    if (!mounted) {
      return;
    }

    final result =
        await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) =>
            const NotificationScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    // ==========================================================
    // COMPTEUR RETOURNÉ PAR NOTIFICATION SCREEN
    // ==========================================================

    if (result != null) {
      debugPrint(
        "🔔 Notifications non lues après retour : $result",
      );

      setState(() {
        localNotificationCount = result;
        unreadCount = result;
      });

      return;
    }

    // ==========================================================
    // FALLBACK
    // ==========================================================

    await _loadUnreadCount();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    notificationSocket.disconnect();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft:
              Radius.circular(28),
          bottomRight:
              Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(
              0,
              0,
              0,
              .05,
            ),
            blurRadius: 20,
            offset: Offset(
              0,
              6,
            ),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            22,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // LOGO + ACTION
              // ==================================================

              Row(
                children: [
                  // ==============================================
                  // BOUTON RETOUR
                  // ==============================================

                  if (widget.onBack != null) ...[
                    InkWell(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                      onTap:
                          widget.onBack,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xffF7F8FC,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),
                        child:
                            const Icon(
                          Icons
                              .arrow_back_rounded,
                          color:
                              Color(
                            0xff23314D,
                          ),
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],

                  // ==============================================
                  // LOGO
                  // ==============================================

                  Expanded(
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                      onTap:
                          widget.onLogoTap,
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                26,
                              ),
                            ),
                            clipBehavior:
                                Clip.antiAlias,
                            child:
                                const AppLogo(
                              showText:
                                  false,
                              size: 70,
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Flexible(
                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children:
                                  const [
                                Text(
                                  "BabiSchool",
                                  maxLines:
                                      1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      TextStyle(
                                    fontSize:
                                        20,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color:
                                        Color(
                                      0xff23314D,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Le suivi scolaire de votre enfant à distance",
                                  maxLines:
                                      1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      TextStyle(
                                    fontSize:
                                        11,
                                    color:
                                        Colors
                                            .grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==============================================
                  // ACTION
                  // ==============================================

                  if (widget.trailing !=
                      null)
                    widget.trailing!
                  else if (widget
                      .showNotification)
                    _buildNotificationButton(),
                ],
              ),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // TITRE
              // ==================================================

              Text(
                widget.title,
                style:
                    const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Color(0xff1F2937),
                ),
              ),

              // ==================================================
              // SOUS-TITRE
              // ==================================================

              if (widget.subtitle !=
                  null) ...[
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOUTON NOTIFICATION
  // ============================================================

  Widget _buildNotificationButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(16),
        onTap:
            _handleNotificationTap,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            clipBehavior:
                Clip.none,
            children: [
              // ==================================================
              // BOUTON
              // ==================================================

              Container(
                width: 52,
                height: 52,
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color:
                          Color.fromRGBO(
                        0,
                        0,
                        0,
                        .08,
                      ),
                      blurRadius: 18,
                      offset: Offset(
                        0,
                        6,
                      ),
                    ),
                  ],
                ),
                child:
                    const Icon(
                  Icons
                      .notifications_none_rounded,
                  color:
                      Color(0xff4F46E5),
                  size: 28,
                ),
              ),

              // ==================================================
              // BADGE
              // ==================================================

              if (displayedNotificationCount >
                  0)
                Positioned(
                  right: -3,
                  top: -3,
                  child: Container(
                    constraints:
                        const BoxConstraints(
                      minHeight: 20,
                      minWidth: 20,
                    ),
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 4,
                    ),
                    decoration:
                        const BoxDecoration(
                      color:
                          Color(0xffFF3B30),
                      shape:
                          BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        displayedNotificationCount >
                                99
                            ? "99+"
                            : displayedNotificationCount
                                .toString(),
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 10,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}