import '../../../../core/api/api_client.dart';
import 'models/staff_student_detail_model.dart';

class StaffStudentDetailService {
  static Future<StaffStudentDetailModel> getStudentDetail(
    String studentId,
  ) async {
    final response = await ApiClient.dio.get(
      '/mobile/staff/students/$studentId/',
    );

    return StaffStudentDetailModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}