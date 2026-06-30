import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';

import '../features/notifications/notification_screen.dart';

import '../features/messaging/messaging_screen.dart';

import '../features/payments/payments_screen.dart';

import '../features/profile/screens/profile_screen.dart';

class AppShell
extends StatefulWidget {

  const AppShell({
    super.key,
  });

  @override
  State<AppShell>
  createState() =>
  _AppShellState();
}

class _AppShellState
extends State<AppShell> {

  int currentIndex = 0;

  final pages = const [

    DashboardScreen(),

    NotificationScreen(),

    MessagingScreen(),

    PaymentsScreen(),

    ProfileScreen(),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar:

      NavigationBar(

        selectedIndex:
        currentIndex,

        onDestinationSelected:
        (index) {

          setState(() {

            currentIndex =
            index;
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