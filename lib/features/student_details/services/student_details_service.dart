import '../../../core/api/api_client.dart';

import '../models/student_detail_model.dart';

class StudentDetailsService {

  Future<StudentDetailModel>
  getStudentDetails(
    String studentId,
  ) async {

    final response =

    await ApiClient.dio.get(

      "/mobile/students/$studentId/",
    );

    return StudentDetailModel
        .fromJson(
      response.data,
    );
  }
}