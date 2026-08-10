import '../../core/api/api_client.dart';

import '../../core/api/endpoints.dart';

class DashboardService {

  Future<Map<String,dynamic>>
  getDashboard() async {
   
    final response =
    await ApiClient.dio.get(
      Endpoints.dashboard,
    );

    print(
      "DASHBOARD RESPONSE => ${response.data}"
    );

    
    return response.data;
  }
}