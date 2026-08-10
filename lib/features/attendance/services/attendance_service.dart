import '../../../core/api/api_client.dart';

import '../models/attendance_model.dart';

class AttendanceService {

  Future<AttendanceModel>
  getAttendance(
    String studentId,
  ) async {

    final response =

    await ApiClient.dio.get(

      "/mobile/students/$studentId/attendance/",
    );
    print("-------------- ${response.data}");
    return AttendanceModel.fromJson(
      response.data,
    );
  }
}