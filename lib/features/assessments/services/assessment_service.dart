import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

import '../models/assessment_model.dart';

class AssessmentService {

  const AssessmentService();

  /// ============================================
  /// Evaluations programmées d'un élève
  /// ============================================

  Future<List<AssessmentModel>>
  getStudentAssessments(

    String studentId,

  ) async {

    try {

      final response =

          await ApiClient.dio.get(

        "/mobile/students/$studentId/assessments/",

      );
      print("response ------ $response.data");
      final List<dynamic> data = response.data["assessments"] ?? response.data;

      return data

          .map(

            (e) =>

                AssessmentModel.fromJson(e),

          )

          .toList();

    } on DioException catch (e) {

      throw Exception(

        e.response?.data["detail"] ??

        "Impossible de charger les évaluations.",

      );

    } catch (_) {

      throw Exception(

        "Une erreur est survenue.",

      );

    }
  }
}