/*import 'package:babischool/core/api/api.dart';
import 'package:babischool/features/dashboard/models/activity_model.dart';

class ActivityService {
  final Api _api = Api();

  Future<List<ActivityModel>> getActivities() async {
    final response = await _api.get("/mobile/activities/");

    return (response.data as List)
        .map((e) => ActivityModel.fromJson(e))
        .toList();
  }

  Future<void> markAsRead({
    required String type,
    required int targetId,
  }) async {
    await _api.post(
      "/mobile/activities/read/",
      data: {
        "type": type,
        "target_id": targetId,
      },
    );
  }

  Future<void> markAllAsRead() async {
    await _api.post(
      "/mobile/activities/read-all/",
    );
  }
}*/