import '../../../core/api/api_client.dart';
import '../models/grades_model.dart';

class GradesService {
  Future<GradesModel> getGrades(
    String studentId, {
    String? termId,
  }) async {
    final response = await ApiClient.dio.get(
      "/mobile/students/$studentId/grades/",
      queryParameters: {
        if (termId != null) "term_id": termId,
      },
    );

    return GradesModel.fromJson(
      response.data,
    );
  }
}