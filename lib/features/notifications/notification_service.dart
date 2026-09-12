import '../../core/api/api_client.dart';

class NotificationService {
  // ============================================================
  // RÉCUPÉRER LES NOTIFICATIONS
  // ============================================================

  Future<List<dynamic>> getNotifications() async {
    final response = await ApiClient.dio.get(
      "/notifications/",
    );

    return response.data["results"] ?? [];
  }

  // ============================================================
  // RÉCUPÉRER LE NOMBRE DE NOTIFICATIONS NON LUES
  // ============================================================

  Future<int> getUnreadCount() async {
    final response = await ApiClient.dio.get(
      "/notifications/unread-count/",
    );

    return (response.data["count"] as num?)?.toInt() ?? 0;
  }

  // ============================================================
  // MARQUER UNE NOTIFICATION COMME LUE
  // ============================================================

  Future<void> markAsRead(
    String id,
  ) async {
    await ApiClient.dio.post(
      "/notifications/read/$id/",
    );
  }

  // ============================================================
  // MARQUER TOUTES LES NOTIFICATIONS COMME LUES
  // ============================================================

  Future<void> markAllRead() async {
    await ApiClient.dio.post(
      "/notifications/read-all/",
    );
  }
}