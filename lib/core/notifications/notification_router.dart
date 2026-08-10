import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../realtime/payment_realtime_service.dart';

class NotificationRouter {
  NotificationRouter._();

  static final NotificationRouter instance =
      NotificationRouter._();

  //----------------------------------------------------------
  // NAVIGATOR KEY
  //----------------------------------------------------------

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  //----------------------------------------------------------
  // CALLBACKS TEMPORAIRES
  //
  // Ils seront progressivement remplacés par
  // des services Realtime dédiés comme celui des paiements.
  //----------------------------------------------------------

  VoidCallback? onMessagesUpdated;

  VoidCallback? onAnnouncementsUpdated;

  VoidCallback? onHomeworkUpdated;

  VoidCallback? onAttendanceUpdated;

  VoidCallback? onReportCardUpdated;

  VoidCallback? onScheduleUpdated;

  //----------------------------------------------------------
  // ROUTER
  //----------------------------------------------------------

  Future<void> route(
    RemoteMessage message,
  ) async {
    final data = message.data;

    final type = data["type"];

    debugPrint(
      "======================================",
    );

    debugPrint(
      "NOTIFICATION ROUTER",
    );

    debugPrint(
      "TYPE : $type",
    );

    debugPrint(
      "DATA : $data",
    );

    debugPrint(
      "======================================",
    );

    switch (type) {

      //------------------------------------------------------
      // MESSAGERIE
      //------------------------------------------------------

      case "message":

        onMessagesUpdated?.call();

        final conversationId =
            data["conversation_id"];

        debugPrint(
          "MESSAGE RECEIVED : $conversationId",
        );

        break;

      //------------------------------------------------------
      // PAIEMENT
      //------------------------------------------------------

      case "payment":

        debugPrint(
          "PAYMENT RECEIVED",
        );

        debugPrint(
          "PAYMENT ID : ${data["payment_id"]}",
        );

        debugPrint(
          "STUDENT ID : ${data["student_id"]}",
        );

        //--------------------------------------------------
        // Informe tous les écrans intéressés par
        // les données financières.
        //--------------------------------------------------

        PaymentRealtimeService
            .instance
            .notify();

        break;

      //------------------------------------------------------
      // DEVOIRS
      //------------------------------------------------------

      case "homework":

        debugPrint(
          "HOMEWORK RECEIVED",
        );

        onHomeworkUpdated?.call();

        break;

      //------------------------------------------------------
      // ANNONCES
      //------------------------------------------------------

      case "announcement":

        debugPrint(
          "ANNOUNCEMENT RECEIVED",
        );

        onAnnouncementsUpdated?.call();

        break;

      //------------------------------------------------------
      // PRESENCE
      //------------------------------------------------------

      case "attendance":

        debugPrint(
          "ATTENDANCE RECEIVED",
        );

        onAttendanceUpdated?.call();

        break;

      //------------------------------------------------------
      // BULLETIN
      //------------------------------------------------------

      case "report_card":

        debugPrint(
          "REPORT CARD RECEIVED",
        );

        onReportCardUpdated?.call();

        break;

      //------------------------------------------------------
      // EMPLOI DU TEMPS
      //------------------------------------------------------

      case "schedule":

        debugPrint(
          "SCHEDULE RECEIVED",
        );

        onScheduleUpdated?.call();

        break;

      //------------------------------------------------------
      // TYPE INCONNU
      //------------------------------------------------------

      default:

        debugPrint(
          "UNKNOWN NOTIFICATION TYPE : $type",
        );

        break;
    }
  }

  //----------------------------------------------------------
  // OUVERTURE DEPUIS UNE NOTIFICATION
  //----------------------------------------------------------

  Future<void> open(
    RemoteMessage message,
  ) async {
    final navigator =
        navigatorKey.currentState;

    if (navigator == null) {
      debugPrint(
        "NotificationRouter : Navigator indisponible.",
      );

      return;
    }

    final data = message.data;

    final type = data["type"];

    switch (type) {

      //------------------------------------------------------
      // MESSAGE
      //------------------------------------------------------

      case "message":

        final conversationId =
            data["conversation_id"];

        debugPrint(
          "OPEN MESSAGE : $conversationId",
        );

        /*
        Plus tard :

        navigator.push(
          MaterialPageRoute(
            builder: (_) => ConversationScreen(
              conversationId: conversationId,
            ),
          ),
        );
        */

        break;

      //------------------------------------------------------
      // PAIEMENT
      //------------------------------------------------------

      case "payment":

        final paymentId =
            data["payment_id"];

        final studentId =
            data["student_id"];

        debugPrint(
          "OPEN PAYMENT : $paymentId",
        );

        debugPrint(
          "STUDENT : $studentId",
        );

        /*
        Plus tard nous pourrons ouvrir directement
        PaymentsScreen ou le détail du paiement.

        navigator.push(
          MaterialPageRoute(
            builder: (_) => const PaymentsScreen(),
          ),
        );
        */

        break;

      //------------------------------------------------------
      // DEVOIRS
      //------------------------------------------------------

      case "homework":

        debugPrint(
          "OPEN HOMEWORK",
        );

        break;

      //------------------------------------------------------
      // ANNONCES
      //------------------------------------------------------

      case "announcement":

        debugPrint(
          "OPEN ANNOUNCEMENT",
        );

        break;

      //------------------------------------------------------
      // PRESENCE
      //------------------------------------------------------

      case "attendance":

        debugPrint(
          "OPEN ATTENDANCE",
        );

        break;

      //------------------------------------------------------
      // BULLETIN
      //------------------------------------------------------

      case "report_card":

        debugPrint(
          "OPEN REPORT CARD",
        );

        break;

      //------------------------------------------------------
      // EMPLOI DU TEMPS
      //------------------------------------------------------

      case "schedule":

        debugPrint(
          "OPEN SCHEDULE",
        );

        break;

      //------------------------------------------------------
      // INCONNU
      //------------------------------------------------------

      default:

        debugPrint(
          "UNKNOWN NOTIFICATION TO OPEN : $type",
        );

        break;
    }
  }
}