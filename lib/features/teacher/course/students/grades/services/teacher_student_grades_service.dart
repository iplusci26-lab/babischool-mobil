import '../../../../../../core/api/api_client.dart';
import '../../../../../../core/api/endpoints.dart';

import '../models/student_grades_response.dart';

class TeacherStudentGradesService {

  Future<StudentGradesResponse> getGrades(

    String studentId,

  ) async {

    final response = await ApiClient.dio.get(

      Endpoints.teacherStudentGrades(

        studentId,

      ),

    );

    return StudentGradesResponse.fromJson(

      response.data,

    );

  }

}