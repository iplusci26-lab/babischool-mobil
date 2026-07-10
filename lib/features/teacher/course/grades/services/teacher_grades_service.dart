import '../../../../../../core/api/api_client.dart';

import '../models/grade_response_model.dart';

class TeacherGradesService {

  Future<GradesResponseModel> getGrades(

    String assessmentId,

  ) async {

    final response = await ApiClient.dio.get(

      "/mobile/teacher/assessments/$assessmentId/grades/",

    );

    return GradesResponseModel.fromJson(

      response.data,

    );

  }

  Future<void> saveGrades(

    String assessmentId,

    List<Map<String, dynamic>> grades,

  ) async {

    await ApiClient.dio.post(

      "/mobile/teacher/assessments/$assessmentId/grades/",

      data: {

        "grades": grades,

      },

    );

  }

}