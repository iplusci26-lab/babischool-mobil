import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../models/assessment_model.dart';

class AssessmentService {
  const AssessmentService();

  // ============================================
  // Evaluations programmées d'un élève
  // ============================================

  Future<List<AssessmentModel>> getStudentAssessments(
    String studentId,
  ) async {
    try {
      final response = await ApiClient.dio.get(
        "/mobile/students/$studentId/assessments/",
      );

      print("==========================================");
      print("ASSESSMENTS RESPONSE");
      print("STATUS: ${response.statusCode}");
      print("TYPE: ${response.data.runtimeType}");
      print("DATA: ${response.data}");
      print("==========================================");

      final List<dynamic> data =
          response.data["assessments"] ?? response.data;

      print("ASSESSMENTS LIST TYPE: ${data.runtimeType}");
      print("ASSESSMENTS COUNT: ${data.length}");

      return data
          .map(
            (e) {
              print("ASSESSMENT ITEM TYPE: ${e.runtimeType}");
              print("ASSESSMENT ITEM: $e");

              return AssessmentModel.fromJson(e);
            },
          )
          .toList();

    } on DioException catch (e, stackTrace) {

      print("==========================================");
      print("DIO ERROR - ASSESSMENTS");
      print("MESSAGE: ${e.message}");
      print("STATUS: ${e.response?.statusCode}");
      print("RESPONSE: ${e.response?.data}");
      print("STACKTRACE:");
      print(stackTrace);
      print("==========================================");

      throw Exception(
        e.response?.data is Map
            ? e.response?.data["detail"] ??
                "Impossible de charger les évaluations."
            : "Impossible de charger les évaluations.",
      );

    } catch (e, stackTrace) {

      print("==========================================");
      print("PARSING / FLUTTER ERROR - ASSESSMENTS");
      print("ERROR TYPE: ${e.runtimeType}");
      print("ERROR: $e");
      print("STACKTRACE:");
      print(stackTrace);
      print("==========================================");

      rethrow;
    }
  }
}