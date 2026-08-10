import '../../../../core/api/api_client.dart';

import '../models/teacher_attendance_response_model.dart';

class TeacherAttendanceService {
  const TeacherAttendanceService();

  //----------------------------------------------------------
  // ENDPOINTS
  //----------------------------------------------------------

  static const String _baseEndpoint =
      "/mobile/teacher/attendance";

  //----------------------------------------------------------
  // PRIMAIRE
  //----------------------------------------------------------

  Future<TeacherAttendanceResponseModel>
      openPrimarySession({
    required String classroomId,
    required String period,
  }) async {
    final response = await ApiClient.dio.post(
      "$_baseEndpoint/primary/",
      data: {
        "classroom_id": classroomId,
        "period": period,
      },
    );

    return TeacherAttendanceResponseModel.fromJson(
      response.data,
    );
    print("Primaire--------- $response");
  }
  

  //----------------------------------------------------------
  // SECONDAIRE
  //----------------------------------------------------------

  Future<TeacherAttendanceResponseModel>
      openScheduleSession({
    required String scheduleId,
  }) async {
    final response = await ApiClient.dio.post(
      "$_baseEndpoint/schedule/",
      data: {
        "schedule_id": scheduleId,
      },
    );

    return TeacherAttendanceResponseModel.fromJson(
      response.data,
    );
    print("Secondaire--------- $response");
  }
  
  //----------------------------------------------------------
  // CHARGER UNE SESSION
  //----------------------------------------------------------

  Future<TeacherAttendanceResponseModel>
      getSession({
    required String sessionId,
  }) async {
    final response = await ApiClient.dio.get(
      "$_baseEndpoint/$sessionId/",
    );

    return TeacherAttendanceResponseModel.fromJson(
      response.data,
    );
    print("Session--------- $response");
  }
  
  //----------------------------------------------------------
  // ENREGISTRER L'APPEL
  //----------------------------------------------------------

  Future<TeacherAttendanceResponseModel>
      saveAttendance({
    required String sessionId,
    required List<Map<String, dynamic>> records,
  }) async {
    final response = await ApiClient.dio.put(
      "$_baseEndpoint/$sessionId/",
      data: {
        "records": records,
      },
    );

    return TeacherAttendanceResponseModel.fromJson(
      response.data,
    );
  }

  //----------------------------------------------------------
  // CLÔTURER
  //----------------------------------------------------------

  Future<TeacherAttendanceResponseModel>
      closeSession({
    required String sessionId,
  }) async {
    final response = await ApiClient.dio.post(
      "$_baseEndpoint/$sessionId/close/",
    );

    return TeacherAttendanceResponseModel.fromJson(
      response.data,
    );
  }

  //----------------------------------------------------------
  // ANNULER
  //----------------------------------------------------------

  Future<TeacherAttendanceResponseModel>
      cancelSession({
    required String sessionId,
    String reason = "",
  }) async {
    final response = await ApiClient.dio.post(
      "$_baseEndpoint/$sessionId/cancel/",
      data: {
        "reason": reason,
      },
    );

    return TeacherAttendanceResponseModel.fromJson(
      response.data,
    );
  }

  //----------------------------------------------------------
  // RACCOURCI : PRÉSENT
  //----------------------------------------------------------

  Map<String, dynamic> presentRecord({
    required String enrollmentId,
    String remarks = "",
  }) {
    return {
      "enrollment_id": enrollmentId,
      "status": "PRESENT",
      "minutes_late": 0,
      "remarks": remarks,
    };
  }

  //----------------------------------------------------------
  // RACCOURCI : ABSENT
  //----------------------------------------------------------

  Map<String, dynamic> absentRecord({
    required String enrollmentId,
    String remarks = "",
  }) {
    return {
      "enrollment_id": enrollmentId,
      "status": "ABSENT",
      "minutes_late": 0,
      "remarks": remarks,
    };
  }

  //----------------------------------------------------------
  // RACCOURCI : RETARD
  //----------------------------------------------------------

  Map<String, dynamic> lateRecord({
    required String enrollmentId,
    required int minutesLate,
    String remarks = "",
  }) {
    return {
      "enrollment_id": enrollmentId,
      "status": "LATE",
      "minutes_late": minutesLate,
      "remarks": remarks,
    };
  }
}