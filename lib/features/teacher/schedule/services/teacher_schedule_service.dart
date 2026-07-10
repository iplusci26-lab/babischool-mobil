import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';

import '../models/teacher_schedule_response.dart';

class TeacherScheduleService {

  Future<TeacherScheduleResponse> getSchedule() async {

    final response = await ApiClient.dio.get(

      Endpoints.teacherSchedule,

    );

    return TeacherScheduleResponse.fromJson(

      response.data,

    );

  }

}