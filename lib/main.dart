import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/api/api_client.dart';
import 'core/navigation/navigation_service.dart';
import 'core/notifications/notification_service.dart';

import 'features/auth/splash_screen.dart';

import 'firebase_options.dart';

/// =======================================================
/// Notifications reçues en arrière-plan
/// =======================================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //----------------------------------------------------------
  // FIREBASE
  //----------------------------------------------------------

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  //----------------------------------------------------------
  // API
  //----------------------------------------------------------

  await ApiClient.initialize();

  //----------------------------------------------------------
  // NOTIFICATIONS
  //----------------------------------------------------------

  await NotificationService.instance.initialize();

  //----------------------------------------------------------
  // APPLICATION
  //----------------------------------------------------------

  runApp(
    const BabiSchoolApp(),
  );
}

class BabiSchoolApp extends StatelessWidget {
  const BabiSchoolApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,

      debugShowCheckedModeBanner: false,

      title: "BABISCHOOL",

      home: const SplashScreen(),
    );
  }
}