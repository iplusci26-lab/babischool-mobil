import '../../../../core/api/api_client.dart';

import '../models/teacher_dashboard_model.dart';

class TeacherDashboardService {

  Future<TeacherDashboardModel> getDashboard() async {

    final response = await ApiClient.dio.get(

      "/mobile/teacher/dashboard/",

    );

    return TeacherDashboardModel.fromJson(

      response.data,

    );

  }

}