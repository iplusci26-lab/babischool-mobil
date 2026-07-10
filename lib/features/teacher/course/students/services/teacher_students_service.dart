import '../../../../../core/api/api_client.dart';

import '../models/teacher_students_response.dart';

class TeacherStudentsService {

  Future<TeacherStudentsResponse> getStudents(

    
    String classroomId,

  ) async {

    final response = await ApiClient.dio.get(

      "/mobile/teacher/classrooms/$classroomId/students/",

    );

    return TeacherStudentsResponse.fromJson(

      response.data,

    );

  }

}