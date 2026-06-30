import '../../core/api/api_client.dart';

class NotificationService {

  Future<List<dynamic>>
  getNotifications() async {

    final response =

    await ApiClient.dio.get(
      "/notifications/",
    );

    return response.data["results"];
  }

  Future<int>
  getUnreadCount() async {

    final response =

    await ApiClient.dio.get(
      "/notifications/unread-count/",
    );

    return response.data["count"];
  }

  Future<void>
  markAsRead(
    String id,
  ) async {

    await ApiClient.dio.post(
      "/notifications/read/$id/",
    );
  }

  Future<void>
  markAllRead() async {

    await ApiClient.dio.post(
      "/notifications/read-all/",
    );
  }
}