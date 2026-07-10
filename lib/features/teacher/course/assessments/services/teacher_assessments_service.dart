import '../../../../../core/api/api_client.dart';

import '../models/assessments_response_model.dart';

class TeacherAssessmentsService {

  Future<TeacherAssessmentsResponse> getAssessments(

    String scheduleId,

  ) async {

    final response = await ApiClient.dio.get(

      "/mobile/teacher/schedules/$scheduleId/assessments/",

    );

    return TeacherAssessmentsResponse.fromJson(

      response.data,

    );

  }

  Future<void> deleteAssessment(

    String assessmentId,

  ) async {

    await ApiClient.dio.delete(

      "/mobile/teacher/assessments/$assessmentId/",

    );

  }

  Future<void> createAssessment(

  String scheduleId,

  Map<String, dynamic> data,

) async {

  await ApiClient.dio.post(

    "/mobile/teacher/schedules/$scheduleId/assessments/",

    data: data,

  );

}

Future<void> updateAssessment(

  String assessmentId,

  Map<String, dynamic> data,

) async {

  await ApiClient.dio.put(

    "/mobile/teacher/assessments/$assessmentId/",

    data: data,

  );

}

}