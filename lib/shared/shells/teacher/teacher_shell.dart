import 'package:flutter/material.dart';

import '../../../features/notifications/notification_screen.dart';

import '../../../features/profile/screens/profile_screen.dart';

import '../../../features/teacher/dashboard/teacher_dashboard_screen.dart';

import '../../../features/teacher/schedule/teacher_schedule_screen.dart';

import '../../../features/teacher/classrooms/teacher_classrooms_screen.dart';

class TeacherShell extends StatefulWidget {

  const TeacherShell({
    super.key,
  });

  @override
  State<TeacherShell> createState() =>
      _TeacherShellState();

}

class _TeacherShellState
    extends State<TeacherShell> {

  int currentIndex = 0;

  final List<Widget> pages = [

    TeacherDashboardScreen(),

    TeacherScheduleScreen(),

    TeacherClassroomsScreen(),

    NotificationScreen(),

    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF7F8FC),

      body: IndexedStack(

        index: currentIndex,

        children: pages,

      ),

      bottomNavigationBar: NavigationBar(

        height: 72,

        elevation: 8,

        backgroundColor: Colors.white,

        selectedIndex: currentIndex,

        indicatorColor:
            const Color(
              0xff6214BE,
            ).withValues(
              alpha: .15,
            ),

        labelBehavior:
            NavigationDestinationLabelBehavior
                .alwaysShow,

        onDestinationSelected: (index) {

          setState(() {

            currentIndex = index;

          });

        },

        destinations: const [

          NavigationDestination(

            icon: Icon(
              Icons.dashboard_outlined,
            ),

            selectedIcon: Icon(
              Icons.dashboard,
            ),

            label: "Accueil",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.calendar_month_outlined,
            ),

            selectedIcon: Icon(
              Icons.calendar_month,
            ),

            label: "Planning",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.class_outlined,
            ),

            selectedIcon: Icon(
              Icons.class_,
            ),

            label: "Classes",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.notifications_outlined,
            ),

            selectedIcon: Icon(
              Icons.notifications,
            ),

            label: "Notifications",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.person_outline,
            ),

            selectedIcon: Icon(
              Icons.person,
            ),

            label: "Profil",

          ),

        ],

      ),

    );

  }

}