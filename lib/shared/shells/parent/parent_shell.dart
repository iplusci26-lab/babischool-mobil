import 'package:flutter/material.dart';

import '../../../features/dashboard/dashboard_screen.dart';
import '../../../features/messaging/messaging_screen.dart';
import '../../../features/notifications/notification_screen.dart';
import '../../../features/payments/payments_screen.dart';
import '../../../features/profile/screens/profile_screen.dart';
import '../../../core/navigation/navigation_controller.dart';

final GlobalKey<_ParentShellState> parentShellKey =
    GlobalKey<_ParentShellState>();

class ParentShell extends StatefulWidget {
  ParentShell({
    super.key,
  });

  @override
  State<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState
    extends State<ParentShell> {

  final ValueNotifier<int> currentIndex =
    NavigationController.currentIndex;

  

  final List<Widget> pages = const  [

    DashboardScreen(),

    NotificationScreen(),

    MessagingScreen(),

    PaymentsScreen(),

    ProfileScreen(),

  ];

 

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<int>(
  valueListenable: currentIndex,
  builder: (context, index, _) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      body: IndexedStack(
        index: index,
        children: pages,
      ),

      bottomNavigationBar: NavigationBar(
        height: 72,
        elevation: 8,
        selectedIndex: index,
        backgroundColor: Colors.white,
        indicatorColor:
            const Color(0xff6214BE).withValues(alpha: .15),

        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,

        onDestinationSelected: (value) {
          currentIndex.value = value;
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Accueil",
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat),
            label: "Messages",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: "Paiements",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  },
);

  }

}