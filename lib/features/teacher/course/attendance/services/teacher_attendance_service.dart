import '../../../../../core/api/api_client.dart';

import '../models/attendance_response_model.dart';

class TeacherAttendanceService {

  Future<AttendanceResponseModel> getAttendance(

    String scheduleId,

  ) async {

    final response = await ApiClient.dio.get(

      "/mobile/teacher/schedules/$scheduleId/attendance/",

    );

    return AttendanceResponseModel.fromJson(

      response.data,

    );

  }

  Future<void> saveAttendance(

    String scheduleId,

    List<Map<String, dynamic>> students,

  ) async {

    await ApiClient.dio.post(

      "/mobile/teacher/schedules/$scheduleId/attendance/",

      data: {

        "students": students,

      },

    );

  }

}