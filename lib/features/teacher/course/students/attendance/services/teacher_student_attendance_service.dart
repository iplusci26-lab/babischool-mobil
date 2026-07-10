import '../../../../../../core/api/api_client.dart';
import '../../../../../../core/api/endpoints.dart';

import '../models/student_attendance_response.dart';

class TeacherStudentAttendanceService {

  Future<StudentAttendanceResponse> getAttendance(

    String studentId,

  ) async {

    final response = await ApiClient.dio.get(

      Endpoints.teacherStudentAttendance(

        studentId,

      ),

    );

    return StudentAttendanceResponse.fromJson(

      response.data,

    );

  }

}