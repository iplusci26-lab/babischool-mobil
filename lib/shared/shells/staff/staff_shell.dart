import 'package:flutter/material.dart';

import '../../../features/messaging/messaging_screen.dart';
import '../../../features/notifications/notification_screen.dart';
import '../../../features/profile/screens/profile_screen.dart';

import '../../../features/staff/dashboard/staff_dashboard_screen.dart';
import '../../../features/staff/announcements/staff_announcements_screen.dart';

class StaffShell extends StatefulWidget {

  const StaffShell({
    super.key,
  });

  @override
  State<StaffShell> createState() =>
      _StaffShellState();

}

class _StaffShellState
    extends State<StaffShell> {

  int currentIndex = 0;

  final List<Widget> pages = const [

    StaffDashboardScreen(),

    StaffAnnouncementsScreen(),

    MessagingScreen(),

    NotificationScreen(),

    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FC),

      body: IndexedStack(

        index: currentIndex,

        children: pages,

      ),

      bottomNavigationBar: NavigationBar(

        height: 72,

        elevation: 8,

        backgroundColor: Colors.white,

        selectedIndex: currentIndex,

        indicatorColor: const Color(
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
              Icons.campaign_outlined,
            ),

            selectedIcon: Icon(
              Icons.campaign,
            ),

            label: "Annonces",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.chat_bubble_outline,
            ),

            selectedIcon: Icon(
              Icons.chat,
            ),

            label: "Messages",

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