import '../../../core/api/api_client.dart';

import '../models/grades_model.dart';

class GradesService {

  Future<GradesModel> getGrades(
    String studentId,
  ) async {
    print("studentId $studentId");
    final response =
        await ApiClient.dio.get(
      "/mobile/students/$studentId/grades/",
    );
    print("reponses ${response.data}");
    return GradesModel.fromJson(
      response.data,
    );
  }
}