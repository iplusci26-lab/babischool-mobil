import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import 'models/staff_absenteeism_model.dart';

class StaffAbsenteeismService {
    
  static Future<StaffAbsenteeismModel> getAbsenteeism({
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
      '/mobile/staff/absenteeism/',
      queryParameters: queryParameters,
    );

    debugPrint("========== ABSENTEEISM RESPONSE DEBUG ==========");
    debugPrint("RESPONSE: ${response.data}");
    debugPrint("==================================================");

    return StaffAbsenteeismModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
