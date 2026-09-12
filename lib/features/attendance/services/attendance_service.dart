import 'dart:convert';

import '../../../core/api/api_client.dart';

import '../models/attendance_model.dart';

class AttendanceService {

  Future<AttendanceModel>
  getAttendance(
    String studentId,
  ) async {

    try {

      final response =

      await ApiClient.dio.get(

        "/mobile/students/$studentId/attendance/",

      );


      // ======================================================
      // DEBUG
      // ======================================================

      return AttendanceModel.fromJson(

        response.data,

      );

    } catch (e) {

      print(
        "ATTENDANCE API ERROR",
      );

      print(
        e.toString(),
      );

     
      rethrow;

    }

  }

}