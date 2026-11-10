
import '../../../core/api/api_client.dart';
import 'models/staff_class_absences_model.dart';

class StaffClassAbsencesService {
  /// Récupère les absences d'une classe accessible au Staff.
  static Future<StaffClassAbsencesModel> getClassAbsences({
    required String classroomId,
    DateTime? startDate,
    DateTime? endDate,
    String? justificationStatus,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (startDate != null) {
      queryParameters['start_date'] = _formatDate(startDate);
    }

    if (endDate != null) {
      queryParameters['end_date'] = _formatDate(endDate);
    }

    if (justificationStatus != null &&
        justificationStatus.isNotEmpty) {
      queryParameters['justification_status'] =
          justificationStatus;
    }

    final response = await ApiClient.dio.get(
      '/mobile/staff/classrooms/$classroomId/absences/',
      queryParameters: queryParameters,
    );

    return StaffClassAbsencesModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  /// Convertit une date au format YYYY-MM-DD.
  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
