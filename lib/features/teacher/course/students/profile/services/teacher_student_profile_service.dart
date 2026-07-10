import '../../../../../../core/api/api_client.dart';
import '../../../../../../core/api/endpoints.dart';

import '../models/teacher_student_profile_model.dart';

class TeacherStudentProfileService {

  Future<TeacherStudentProfileModel> getProfile(

    String studentId,

  ) async {

    final response = await ApiClient.dio.get(

      Endpoints.teacherStudentProfile(studentId),

    );

    return TeacherStudentProfileModel.fromJson(

      response.data,

    );

  }

}