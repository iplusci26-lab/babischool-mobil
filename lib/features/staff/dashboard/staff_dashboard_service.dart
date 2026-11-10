
import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import 'models/staff_dashboard_model.dart';

class StaffDashboardService {
  static Future<StaffDashboardModel> getDashboard() async {
    try {
      final response = await ApiClient.dio.get(
        '/mobile/staff/dashboard/',
      );

      if (response.data is! Map) {
        throw Exception('Format de réponse du serveur invalide.');
      }

      return StaffDashboardModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      String message = 'Impossible de charger le tableau de bord.';

      if (data is Map) {
        message = data['detail']?.toString() ??
            data['message']?.toString() ??
            message;
      }

      throw Exception(message);
    }
  }
}
