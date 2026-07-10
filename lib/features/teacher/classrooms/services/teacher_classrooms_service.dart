import '../../../../core/api/api_client.dart';

import '../models/teacher_classrooms_response.dart';

class TeacherClassroomsService {

  Future<TeacherClassroomsResponse> getClassrooms() async {

    final response = await ApiClient.dio.get(

      "/mobile/teacher/classrooms/",

    );
    print("response data $response.data");
    return TeacherClassroomsResponse.fromJson(

      response.data,

    );

  }

}