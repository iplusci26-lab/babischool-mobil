import 'package:flutter/material.dart';

import '../../../features/dashboard/dashboard_screen.dart';
import '../../../features/messaging/messaging_screen.dart';
import '../../../features/notifications/notification_screen.dart';
import '../../../features/payments/payments_screen.dart';
import '../../../features/profile/screens/profile_screen.dart';

class ParentShell extends StatefulWidget {

  const ParentShell({
    super.key,
  });

  @override
  State<ParentShell> createState() =>
      _ParentShellState();

}

class _ParentShellState
    extends State<ParentShell> {

  int currentIndex = 0;

  final List<Widget> pages = const [

    DashboardScreen(),

    NotificationScreen(),

    MessagingScreen(),

    PaymentsScreen(),

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

        selectedIndex: currentIndex,

        backgroundColor: Colors.white,

        indicatorColor:
            const Color(0xff6214BE).withValues(alpha: .15),

        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,

        onDestinationSelected: (index) {

          setState(() {

            currentIndex = index;

          });

        },

        destinations: const [

          NavigationDestination(

            icon: Icon(
              Icons.home_outlined,
            ),

            selectedIcon: Icon(
              Icons.home,
            ),

            label: "Accueil",

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
              Icons.chat_bubble_outline,
            ),

            selectedIcon: Icon(
              Icons.chat,
            ),

            label: "Messages",

          ),

          NavigationDestination(

            icon: Icon(
              Icons.account_balance_wallet_outlined,
            ),

            selectedIcon: Icon(
              Icons.account_balance_wallet,
            ),

            label: "Paiements",

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