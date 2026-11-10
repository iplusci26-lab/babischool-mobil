
import '../../../core/api/api_client.dart';
import 'models/staff_student_absences_model.dart';

class StaffStudentAbsencesService {
  static Future<StaffStudentAbsencesModel> getStudentAbsences({
    required String studentId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (startDate != null) {
      queryParameters['start_date'] = _formatDate(startDate);
    }

    if (endDate != null) {
      queryParameters['end_date'] = _formatDate(endDate);
    }

    final response = await ApiClient.dio.get(
      '/mobile/staff/students/$studentId/absences/',
      queryParameters: queryParameters,
    );

    return StaffStudentAbsencesModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
