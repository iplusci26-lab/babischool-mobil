import 'package:flutter/material.dart';

import '../../shared/models/dashboard_model.dart';

import 'dashboard_service.dart';

import 'widgets/dashboard_header.dart';

import 'widgets/children_section.dart';

import 'widgets/quick_actions.dart';

import '../../core/theme/app_colors.dart';

import '../../core/storage/secure_storage_service.dart';

import '../notifications/notification_screen.dart';

import '../messaging/conversation_screen.dart';

import '../student_details/screens/student_details_screen.dart';

import '../../shared/widgets/app_header.dart';

import '../../../core/navigation/navigation_controller.dart';

import 'package:babischool_mobile/core/utils/date_formatter.dart';

import '../announcements/screens/announcement_detail_screen.dart';

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

 

  @override
  void initState() {

    super.initState();

    loadData();
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

        backgroundColor:AppColors.background,

        body: SafeArea(

          child: RefreshIndicator(

            onRefresh: loadData,

            child: ListView(

            padding: const EdgeInsets.only(
                bottom: 20,
              ),

              children: [
                Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                    child:AppHeader(
                      title: "Bonjour M. / Mme ${dashboard?.parentName.split(" ").last ?? ""} 👋",
                      subtitle: "Informez-vous de l'activité de vos enfants à l'école",
                      onNotificationTap: () {
                        NavigationController.goTo(1);
                      },
                    ),
                ),

                const SizedBox(
                  height: 30,
                ),
                
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        
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

                        

                        
                        Container(

                          padding:
                          const EdgeInsets.all(
                            20,
                          ),

                          decoration:
                          BoxDecoration(

                            color: Color(0xff6214BE),

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


                            if (dashboard!.activities.isEmpty)

                                Container(

                                  padding: const EdgeInsets.all(20),

                                  alignment: Alignment.center,

                                  child: const Text(

                                    "Aucune activité récente",

                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                )

                              else

                                ...dashboard!.activities.map((activity) {

                                        IconData icon;

                                        Color color;

                                        switch (activity.type) {

                                          case "payment":

                                            icon = Icons.payments;

                                            color = const Color(0xFF18B26B);

                                            break;

                                          case "message":

                                            icon = Icons.message;

                                            color = const Color(0xFF2196F3);

                                            break;

                                          default:

                                            icon = Icons.notifications;

                                            color = const Color(0xFF6214BE);
                                        }

                                        return _activityTile(

                                          icon: icon,

                                          title: activity.title,

                                          subtitle:

                                              activity.studentName == null

                                                  ? activity.description

                                                  : "${activity.studentName} • ${activity.description}",

                                          color: color,

                                          time: DateFormatter.relative(
                                            activity.date,
                                          ),

                                          isRead: activity.isRead,

                                          onTap: () {

                                            switch (activity.type) {

                                              case "announcement":
                                                   ScaffoldMessenger.of(context).showSnackBar(

                                                    const SnackBar(

                                                      content: Text(
                                                        "Détail des annonces bientôt disponible",
                                                      ),
                                                    ),
                                                  );
                                               /* Navigator.push(

                                                  context,

                                                  MaterialPageRoute(

                                                    builder: (_) => AnnouncementDetailScreen(

                                                      announcementId:
                                                          activity.targetId,
                                                    ),
                                                  ),
                                                );**/

                                                break;

                                              case "payment":

                                                NavigationController.goTo(3);

                                                break;

                                              case "message":

                                                Navigator.push(

                                                  context,

                                                  MaterialPageRoute(

                                                    builder: (_) => ConversationScreen(

                                                      conversationId:
                                                          activity.targetId,
                                                    ),
                                                  ),
                                                );

                                                break;
                                            }
                                          },
                                        );

                                      }),
                                                                  

                          
                            ],
                          ),
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

                    ],
                  )
                 ),
              ],
            ),
          ),
        ),
      );

  }

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

    padding: const EdgeInsets.only(bottom: 12),

    child: Material(

      color: Colors.white,

      borderRadius: BorderRadius.circular(16),

      child: InkWell(

        borderRadius: BorderRadius.circular(16),

        onTap: onTap,

        child: Padding(

          padding: const EdgeInsets.all(14),

          child: Row(

            children: [

              Container(

                width: 48,

                height: 48,

                decoration: BoxDecoration(

                  color: color.withOpacity(.12),

                  borderRadius:
                      BorderRadius.circular(14),

                ),

                child: Icon(

                  icon,

                  color: color,

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
                                    left: 6),

                            decoration:
                                const BoxDecoration(

                              color:
                                  Color(0xFF6214BE),

                              shape: BoxShape.circle,
                            ),
                          ),

                        const SizedBox(width: 8),

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

                    const SizedBox(height: 5),

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

              const SizedBox(width: 10),

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