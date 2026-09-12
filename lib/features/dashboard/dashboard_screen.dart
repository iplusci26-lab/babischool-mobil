
import "package:flutter/material.dart";

import "../../shared/models/dashboard_model.dart";

import "dashboard_service.dart";

import "widgets/dashboard_header.dart";
import "widgets/children_section.dart";
import "widgets/quick_actions.dart";

import "../../core/theme/app_colors.dart";

import "../messaging/conversation_screen.dart";
import "../student_details/screens/student_details_screen.dart";

import "../../shared/widgets/app_header.dart";

import "../../../core/navigation/navigation_controller.dart";

import "package:babischool_mobile/core/utils/date_formatter.dart";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardModel? dashboard;

  bool loading = true;

  String? error;

  // =====================================================
  // CHARGEMENT DU DASHBOARD
  // =====================================================

  Future<void> loadData() async {
    if (mounted) {
      setState(() {
        loading = true;
        error = null;
      });
    }

    try {
      final data = await DashboardService().getDashboard();

      final parsedDashboard = DashboardModel.fromJson(
        data,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        dashboard = parsedDashboard;
        loading = false;
        error = null;
      });
    } catch (e, stackTrace) {
      debugPrint(
        "ERREUR DASHBOARD: $e",
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        dashboard = null;
        loading = false;
        error = e.toString();
      });
    }
  }

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {
    super.initState();

    loadData();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // ===================================================
    // CHARGEMENT
    // ===================================================

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // ===================================================
    // ERREUR
    // ===================================================

    if (error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 52,
                    color: Colors.red,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Text(
                    "Impossible de charger le tableau de bord",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Une erreur est survenue lors du chargement de vos informations.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  ElevatedButton(
                    onPressed: loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF6214BE,
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Réessayer",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ===================================================
    // DASHBOARD NULL
    // ===================================================

    final currentDashboard = dashboard;

    if (currentDashboard == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.dashboard_outlined,
                    size: 52,
                    color: Colors.grey,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Text(
                    "Aucune donnée disponible",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  ElevatedButton(
                    onPressed: loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF6214BE,
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Actualiser",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ===================================================
    // NOM DU PARENT
    // ===================================================

    final parentName = currentDashboard.parentName.trim();

    final parentDisplayName = parentName.isEmpty
        ? ""
        : parentName.split(" ").last;

    // ===================================================
    // DASHBOARD
    // ===================================================

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadData,

          child: ListView(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),

            children: [
              // =================================================
              // HEADER
              // =================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                ),

                child: AppHeader(
                  title: parentDisplayName.isEmpty
                      ? "Bonjour 👋"
                      : "Bonjour M. / Mme $parentDisplayName 👋",

                  subtitle:
                      "Informez-vous de l'activité de vos enfants à l'école",

                  onNotificationTap: () {
                    NavigationController.goTo(1);
                  },
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // =================================================
              // CONTENU
              // =================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // =============================================
                    // MES ENFANTS
                    // =============================================

                    const Text(
                      "Mes enfants",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    ChildrenSection(
                      students:
                          currentDashboard.students,

                      onStudentTap: (student) {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                StudentDetailsScreen(
                              student: student,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // =============================================
                    // DERNIÈRES ACTIVITÉS
                    // =============================================

                    Container(
                      padding: const EdgeInsets.all(
                        20,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF6214BE,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.white
                                .withValues(
                              alpha: 0.05,
                            ),

                            blurRadius: 10,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Dernières activités",

                            style: TextStyle(
                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,

                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          // =========================================
                          // AUCUNE ACTIVITÉ
                          // =========================================

                          if (currentDashboard
                              .activities
                              .isEmpty)

                            Container(
                              padding:
                                  const EdgeInsets.all(
                                20,
                              ),

                              alignment:
                                  Alignment.center,

                              child: const Text(
                                "Aucune activité récente",

                                style: TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),
                            )

                          // =========================================
                          // LISTE ACTIVITÉS
                          // =========================================

                          else

                            ...currentDashboard.activities
                                .map(
                              (activity) {
                                IconData icon;

                                Color color;

                                switch (
                                    activity.type) {
                                  case "payment":

                                    icon =
                                        Icons.payments;

                                    color =
                                        const Color(
                                      0xFF18B26B,
                                    );

                                    break;

                                  case "message":

                                    icon =
                                        Icons.message;

                                    color =
                                        const Color(
                                      0xFF2196F3,
                                    );

                                    break;

                                  case "announcement":

                                    icon =
                                        Icons.campaign;

                                    color =
                                        const Color(
                                      0xFFFF9800,
                                    );

                                    break;

                                  default:

                                    icon =
                                        Icons.notifications;

                                    color =
                                        const Color(
                                      0xFF6214BE,
                                    );
                                }

                                return _activityTile(
                                  icon: icon,

                                  title:
                                      activity.title,

                                  subtitle: activity
                                              .studentName ==
                                          null
                                      ? activity.description
                                      : "${activity.studentName} • "
                                          "${activity.description}",

                                  color: color,

                                  time:
                                      DateFormatter.relative(
                                    activity.date,
                                  ),

                                  isRead:
                                      activity.isRead,

                                  onTap: () {
                                    switch (
                                        activity.type) {
                                      // =============================
                                      // ANNONCE
                                      // =============================

                                      case "announcement":

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Le détail des annonces sera bientôt disponible",
                                            ),
                                          ),
                                        );

                                        break;

                                      // =============================
                                      // PAIEMENT
                                      // =============================

                                      case "payment":

                                        NavigationController
                                            .goTo(3);

                                        break;

                                      // =============================
                                      // MESSAGE
                                      // =============================

                                      case "message":

                                        Navigator.push(
                                          context,

                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ConversationScreen(
                                              conversationId:
                                                  activity
                                                      .targetId,
                                            ),
                                          ),
                                        );

                                        break;

                                      default:
                                        break;
                                    }
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // =============================================
                    // QUICK ACTIONS
                    // =============================================

                    /*
                    QuickActions(
                      onNotes: () {
                        print("NOTES");
                      },

                      onAttendance: () {
                        print("PRESENCE");
                      },

                      onPayments: () {
                        NavigationController.goTo(3);
                      },

                      onAnnouncements: () {
                        print("ANNONCES");
                      },
                    ),
                    */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // ACTIVITY TILE
  // =====================================================

  Widget _activityTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String time,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Material(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            16,
          ),

          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.all(
              14,
            ),

            child: Row(
              children: [
                // ===========================================
                // ICON
                // ===========================================

                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color:
                        color.withOpacity(.12),

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),

                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                // ===========================================
                // CONTENT
                // ===========================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,

                              maxLines: 1,

                              overflow:
                                  TextOverflow.ellipsis,

                              style: TextStyle(
                                fontWeight: isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,

                                fontSize: 15,
                              ),
                            ),
                          ),

                          if (!isRead)

                            Container(
                              width: 9,
                              height: 9,

                              margin:
                                  const EdgeInsets.only(
                                left: 6,
                              ),

                              decoration:
                                  const BoxDecoration(
                                color: Color(
                                  0xFF6214BE,
                                ),

                                shape:
                                    BoxShape.circle,
                              ),
                            ),

                          const SizedBox(
                            width: 8,
                          ),

                          Text(
                            time,

                            style: TextStyle(
                              color:
                                  Colors.grey.shade500,

                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        subtitle,

                        maxLines: 2,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color:
                              Colors.grey.shade600,

                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Icon(
                  Icons.chevron_right,

                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}