import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_notification_service.dart';
import 'notification_router.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance =
      NotificationService._();

  //----------------------------------------------------------
  // INITIALISATION
  //----------------------------------------------------------

  Future<void> initialize() async {
    await FirebaseNotificationService.instance.initialize(
      onNotificationTap: _onNotificationTap,
    );
  }

  //----------------------------------------------------------
  // ENREGISTREMENT DE L'APPAREIL
  //----------------------------------------------------------

  Future<void> registerDevice() async {
    await FirebaseNotificationService.instance.registerDevice();
  }

  //----------------------------------------------------------
  // TOKEN
  //----------------------------------------------------------

  Future<String?> getToken() {
    return FirebaseNotificationService.instance.getToken();
  }

  //----------------------------------------------------------
  // CLIC SUR UNE NOTIFICATION
  //----------------------------------------------------------

  Future<void> _onNotificationTap(
    RemoteMessage message,
  ) async {
    await NotificationRouter.instance.route(
      message,
    );
  }
}