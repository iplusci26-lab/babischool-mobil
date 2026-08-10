import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';

import '../models/announcement_model.dart';

class AnnouncementService {
  Future<AnnouncementModel> getAnnouncement(
    String id,
  ) async {
    final response = await ApiClient.dio.get(
      "${Endpoints.mobileAnnouncements}/$id/",
    );

    return AnnouncementModel.fromJson(
      response.data,
    );
  }

  Future<List<AnnouncementModel>>
      getAnnouncements() async {
    final response = await ApiClient.dio.get(
      Endpoints.mobileAnnouncements,
    );

    return (response.data as List)
        .map(
          (e) =>
              AnnouncementModel.fromJson(e),
        )
        .toList();
  }
}