import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance =
      LocalNotificationService._();

  //----------------------------------------------------------
  // Plugin
  //----------------------------------------------------------

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  //----------------------------------------------------------
  // Android Channel
  //----------------------------------------------------------

  static const AndroidNotificationChannel channel =
      AndroidNotificationChannel(
    "babischool_notifications",
    "BABISCHOOL Notifications",
    description:
        "Notifications de messagerie, paiements, devoirs, annonces et présences.",
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  //----------------------------------------------------------
  // INITIALISATION
  //----------------------------------------------------------

  Future<void> initialize({
    Function(String?)? onNotificationTap,
  }) async {
    if (kIsWeb) {
      return;
    }

    //--------------------------------------------------------
    // Android
    //--------------------------------------------------------

    const androidSettings =
        AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    //--------------------------------------------------------
    // iOS
    //--------------------------------------------------------

    const iosSettings =
        DarwinInitializationSettings();

    //--------------------------------------------------------
    // Initialisation
    //--------------------------------------------------------

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) {
        onNotificationTap?.call(
          response.payload,
        );
      },
    );

    //--------------------------------------------------------
    // Création du Channel Android
    //--------------------------------------------------------

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          channel,
        );
  }

  //----------------------------------------------------------
  // AFFICHER UNE NOTIFICATION
  //----------------------------------------------------------

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      DateTime.now()
          .millisecondsSinceEpoch
          .remainder(100000),

      title,

      body,

      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription:
              channel.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          ticker: "BABISCHOOL",
          icon: "@mipmap/ic_launcher",
        ),

        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      payload: payload,
    );
  }

  //----------------------------------------------------------
  // ANNULER UNE NOTIFICATION
  //----------------------------------------------------------

  Future<void> cancel(
    int id,
  ) async {
    await _plugin.cancel(id);
  }

  //----------------------------------------------------------
  // ANNULER TOUTES LES NOTIFICATIONS
  //----------------------------------------------------------

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}