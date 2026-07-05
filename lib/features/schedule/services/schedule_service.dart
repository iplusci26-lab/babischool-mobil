import '../../../core/api/api_client.dart';

import '../models/schedule_response_model.dart';

class ScheduleService {

  Future<ScheduleResponseModel> getSchedule(
    String studentId,
  ) async {

    final response = await ApiClient.dio.get(

      "/mobile/students/$studentId/schedule/",

    );

    return ScheduleResponseModel.fromJson(

      response.data,

    );

  }

}