import 'package:flutter/material.dart';

import '../../shared/models/dashboard_model.dart';

import 'dashboard_service.dart';

import 'widgets/dashboard_header.dart';
import 'widgets/children_section.dart';
import 'widgets/quick_actions.dart';

import '../../core/storage/secure_storage_service.dart';

import '../notifications/notification_screen.dart';

import '../notifications/notification_service.dart';

import '../notifications/notification_websocket_service.dart';
import '../student_details/screens/student_details_screen.dart';

class DashboardScreen
extends StatefulWidget {

  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen>
  createState() =>
  _DashboardScreenState();
}

class _DashboardScreenState
extends State<DashboardScreen> {

  int unreadCount = 0;

  final NotificationWebSocketService
  notificationSocket =
  NotificationWebSocketService();

  DashboardModel? dashboard;

  bool loading = true;

  Future<void> loadData()
  async {

    try {

      final token =
        await SecureStorageService
            .getAccessToken();


      final data =
      await DashboardService().getDashboard();
     

      dashboard =
      DashboardModel.fromJson(
        data,
      );
      
    } catch (e) {
      
      print("erreur $e");
      debugPrint(
        e.toString(),
      );
    }

    setState(() {

      loading = false;
    });
  }

  Future<void>
  loadUnreadCount()
  async {

    try {

      unreadCount =

      await NotificationService()
      .getUnreadCount();

      if (mounted) {

        setState(() {});
      }

    } catch (e) {

      debugPrint(
        e.toString(),
      );
    }
  }

  Future<void>
initializeNotifications()
async {

  await loadUnreadCount();

  await notificationSocket.connect(

    onNotification: (data) {

      print(
        "NEW NOTIFICATION => $data"
      );

      setState(() {

        unreadCount++;
      });
    },
  );
}

  @override
  void initState() {

    super.initState();

    loadData();
    initializeNotifications();
  }

  @override
  void dispose() {

    notificationSocket.disconnect();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
   
      if (loading) {

        return const Scaffold(

          body: Center(
            child:
            CircularProgressIndicator(),
          ),
        );
      }

      return Scaffold(

        backgroundColor:
        const Color(
          0xffF7F8FC,
        ),

        body: SafeArea(

          child: RefreshIndicator(

            onRefresh: loadData,

            child: ListView(

              padding:
              const EdgeInsets.all(
                20,
              ),

              children: [

                DashboardHeader(

                  parentName:
                  dashboard?.parentName
                      ?? "",

                  unreadCount:
                  unreadCount,

                  onNotificationTap:
                  () async {

                    await Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                        const NotificationScreen(),
                      ),
                    );

                    loadUnreadCount();
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                const Text(

                  "Mes enfants",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                ChildrenSection(

                  students:dashboard!.students,

                      onStudentTap:(student) {

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

                QuickActions(

                    onNotes: () {

                      print("NOTES");
                    },

                    onAttendance: () {

                      print("PRESENCE");
                    },

                    onPayments: () {

                      setState(() {

                        // futur switch navigation
                      });
                    },

                    onAnnouncements: () {

                      print("ANNONCES");
                    },
                  ),

                const SizedBox(
                  height: 30,
                ),

                Container(

                  padding:
                  const EdgeInsets.all(
                    20,
                  ),

                  decoration:
                  BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.black
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
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      _activityTile(
                        Icons.notifications,
                        "Nouvelle annonce",
                        "L'école a publié une annonce",
                      ),

                      _activityTile(
                        Icons.payments,
                        "Paiement reçu",
                        "Votre paiement a été enregistré",
                      ),

                      _activityTile(
                        Icons.message,
                        "Nouveau message",
                        "Vous avez reçu un message",
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

  Widget _activityTile(

  IconData icon,

  String title,

  String subtitle,
) {

  return ListTile(

    contentPadding:
    EdgeInsets.zero,

    leading: CircleAvatar(

      backgroundColor:
      const Color(
        0xff6214BE,
      ).withValues(
        alpha: 0.1,
      ),

      child: Icon(

        icon,

        color:
        const Color(
          0xff6214BE,
        ),
      ),
    ),

    title: Text(title),

    subtitle: Text(subtitle),
  );
}
}