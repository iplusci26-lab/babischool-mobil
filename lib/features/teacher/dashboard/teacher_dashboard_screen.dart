import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import '../../../shared/widgets/dashboard_header.dart';
import '../../../shared/widgets/dashboard_stat_card.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import 'models/teacher_dashboard_model.dart';
import 'services/teacher_dashboard_service.dart';
import '../classrooms/teacher_classrooms_screen.dart';
import '../schedule/teacher_schedule_screen.dart';

import '../../messaging/messaging_screen.dart';
class TeacherDashboardScreen extends StatefulWidget {

  const TeacherDashboardScreen({
    super.key,
  });

  @override
  State<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends State<TeacherDashboardScreen> {

  final TeacherDashboardService _service =
      TeacherDashboardService();

  TeacherDashboardModel? dashboard;

  bool loading = true;

  String? error;

  Future<void> loadData() async {

    try {

      error = null;

      dashboard = await _service.getDashboard();

    } catch (e) {

      error = e.toString();

    }

    if (!mounted) return;

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
  Widget build(BuildContext context) {

    if (loading) {

      return const LoadingView();

    }

    if (error != null) {

      return ErrorView(

        message: error!,

        onRetry: () {

          setState(() {

            loading = true;

          });

          loadData();

        },

      );

    }

    return RefreshIndicator(

      onRefresh: loadData,

      child: ListView(

        physics:
            const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.all(20),

        children: [

          //---------------------------------------------------
          // HEADER
          //---------------------------------------------------

          DashboardHeader(

            username: dashboard!.name,

            subtitle:
                "Passez une excellente journée de cours",

          ),

          const SizedBox(height: 24),

          //---------------------------------------------------
          // STATISTIQUES
          //---------------------------------------------------

          DashboardStatCard(

            title: "Cours aujourd'hui",

            value:
                dashboard!.todayCourses.toString(),

            icon: Icons.schedule,

            color: Colors.blue,

            onTap: () {

              // TODO
              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) => const TeacherScheduleScreen(),

                ),

              );

            },

          ),

          const SizedBox(height: 16),

          DashboardStatCard(

            title: "Mes classes",

            value:
                dashboard!.classes.toString(),

            icon: Icons.groups,

            color: Colors.orange,

            onTap: () {

              // TODO
               Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) => const TeacherClassroomsScreen(),

                ),

              );

            },

          ),

          const SizedBox(height: 16),

          DashboardStatCard(

            title: "Elèves",

            value:
                dashboard!.students.toString(),

            icon: Icons.school,

            color: Colors.green,
            onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => const TeacherClassroomsScreen(),

                  ),

                );

              },
          ),

          const SizedBox(height: 16),

          DashboardStatCard(

            title: "Devoirs à publier",

            value: dashboard!
                .pendingHomeworks
                .toString(),

            icon: Icons.assignment,

            color: Colors.deepPurple,

            onTap: () {

               Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => const TeacherClassroomsScreen(),

                  ),

                );


            },

          ),

          const SizedBox(height: 16),

          DashboardStatCard(

            title: "Evaluations à publier",

            value: dashboard!
                .pendingAssessments
                .toString(),

            icon: Icons.fact_check,

            color: Colors.red,

            onTap: () {

               Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => const TeacherClassroomsScreen(),

                  ),

                );

            },

          ),

          const SizedBox(height: 16),

          DashboardStatCard(

            title: "Messages non lus",

            value: dashboard!
                .unreadMessages
                .toString(),

            icon: Icons.chat,

            color: AppColors.primary,

            onTap: () {

               Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => const MessagingScreen(),

                  ),

                );

            },

          ),

          const SizedBox(height: 30),

        ],

      ),

    );

  }

} 