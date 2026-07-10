import '../../../../../core/api/api_client.dart';

import '../models/teacher_homeworks_response_model.dart';

class TeacherHomeworksService {

  Future<TeacherHomeworksResponse> getHomeworks(

    String scheduleId,

  ) async {

    final response = await ApiClient.dio.get(

      "/mobile/teacher/schedules/$scheduleId/homeworks/",

    );

    return TeacherHomeworksResponse.fromJson(

      response.data,

    );

  }

  Future<void> createHomework(

    String scheduleId,

    Map<String, dynamic> data,

  ) async {

    await ApiClient.dio.post(

      "/mobile/teacher/schedules/$scheduleId/homeworks/",

      data: data,

    );

  }

  Future<void> updateHomework(

    String homeworkId,

    Map<String, dynamic> data,

  ) async {

    await ApiClient.dio.put(

      "/mobile/teacher/homeworks/$homeworkId/",

      data: data,

    );

  }

  Future<void> deleteHomework(

    String homeworkId,

  ) async {

    await ApiClient.dio.delete(

      "/mobile/teacher/homeworks/$homeworkId/",

    );

  }

}