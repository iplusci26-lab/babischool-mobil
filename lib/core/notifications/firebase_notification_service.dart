import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_router.dart';
import '../api/api_client.dart';
import 'local_notification_service.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  //----------------------------------------------------------
  // INITIALISATION
  //----------------------------------------------------------

  Future<void> initialize({
    Function(RemoteMessage)? onNotificationTap,
  }) async {
    if (kIsWeb) {
      return;
    }

    //------------------------------------------------------
    // Permissions
    //------------------------------------------------------

    final settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print(
      "Notification permission : "
      "${settings.authorizationStatus}",
    );

    //------------------------------------------------------
    // Notification locale
    //------------------------------------------------------

    await LocalNotificationService.instance.initialize(
      onNotificationTap: (_) {
        debugPrint(

      "LOCAL NOTIFICATION CLICK",

    );
      },
    );

    //------------------------------------------------------
    // Token
    //------------------------------------------------------

    final token = await getToken();

    print("=================================");
    print("FCM TOKEN");
    print(token);
    print("=================================");

    //------------------------------------------------------
    // Rafraîchissement Token
    //------------------------------------------------------

    _messaging.onTokenRefresh.listen(
      (newToken) async {
        await registerDevice(
          token: newToken,
        );
      },
    );

    //------------------------------------------------------
    // APP OUVERTE
    //------------------------------------------------------

    FirebaseMessaging.onMessage.listen(
      (message) async {
        await _onForegroundMessage(
          message,
        );
      },
    );

    //------------------------------------------------------
    // Notification cliquée
    //------------------------------------------------------

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        _onMessageOpened(
          message,
          onNotificationTap,
        );
      },
    );

    //------------------------------------------------------
    // Application ouverte depuis notification
    //------------------------------------------------------

    final initialMessage =
        await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _onMessageOpened(
        initialMessage,
        onNotificationTap,
      );
    }
  }

  //----------------------------------------------------------
// FOREGROUND
//----------------------------------------------------------

Future<void> _onForegroundMessage(
  RemoteMessage message,
) async {

  debugPrint(
    "=========== FOREGROUND ===========",
  );

  debugPrint(
    message.data.toString(),
  );

  //------------------------------------------------------
  // Notification locale
  //------------------------------------------------------

  await LocalNotificationService.instance.show(

    title:

        message.notification?.title ??

        message.data["title"] ??

        "BABISCHOOL",

    body:

        message.notification?.body ??

        message.data["body"] ??

        "",

    payload:

        message.data["type"],

  );

  //------------------------------------------------------
  // Temps réel
  //------------------------------------------------------

  await NotificationRouter.instance.route(
    message,
  );

}

  //----------------------------------------------------------
  // CLICK
  //----------------------------------------------------------

    Future<void> _onMessageOpened(
    RemoteMessage message,
    Function(RemoteMessage)? callback,
    ) async {

    debugPrint(
        "=========== CLICK ===========",
    );

    debugPrint(
        message.data.toString(),
    );

    //------------------------------------------------------
    // Callback éventuel
    //------------------------------------------------------

    callback?.call(
        message,
    );

    //------------------------------------------------------
    // Navigation
    //------------------------------------------------------

    await NotificationRouter.instance.open(
        message,
    );

    }

  //----------------------------------------------------------
  // TOKEN
  //----------------------------------------------------------

  Future<String?> getToken() async {
    if (kIsWeb) {
      return null;
    }

    return _messaging.getToken();
  }

  //----------------------------------------------------------
  // REGISTER DEVICE
  //----------------------------------------------------------

  Future<void> registerDevice({
    String? token,
  }) async {
    if (kIsWeb) {
      return;
    }

    token ??= await getToken();

    if (token == null) {
      return;
    }

    try {
      print("============== REGISTER DEVICE ==============");
        
      print(token);

      final response = await ApiClient.dio.post(
        "/mobile/device-token/",
        data: {
        "token": token,
        "platform": platform,
        },
    );

   
    } on DioException catch (e) {
      debugPrint("REGISTER DEVICE ERROR");
  debugPrint("Status: ${e.response?.statusCode}");
  debugPrint("Body: ${e.response?.data}");
    } catch (e) {
      print(e);
    }
  }

  //----------------------------------------------------------
  // PLATFORM
  //----------------------------------------------------------

  String get platform {
    if (kIsWeb) {
      return "web";
    }

    if (Platform.isAndroid) {
      return "android";
    }

    if (Platform.isIOS) {
      return "ios";
    }

    return "unknown";
  }
}