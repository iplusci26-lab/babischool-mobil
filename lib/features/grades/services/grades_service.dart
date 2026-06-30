import '../../../core/api/api_client.dart';

import '../models/grades_model.dart';

class GradesService {

  Future<GradesModel> getGrades(
    String studentId,
  ) async {

    final response =
        await ApiClient.dio.get(
      "/mobile/students/$studentId/grades/",
    );

    return GradesModel.fromJson(
      response.data,
    );
  }
}