class Endpoints {
  static const baseUrl =
    "http://127.0.0.1:8000/api/v1";
      //"https://iplus-api.onrender.com/api/v1";


  static const login =
      "/mobile/login/";

  static const dashboard =
   "/mobile/dashboard/";

  static String teacherStudentProfile(
    String studentId,) =>
    "/mobile/teacher/students/$studentId/";

  static String teacherStudentAttendance(
      String studentId,
    ) =>
        "/mobile/teacher/students/$studentId/attendance/";

  static String teacherStudentGrades(
    String studentId,
  ) =>
      "/mobile/teacher/students/$studentId/grades/";

  static const teacherSchedule =
    "/mobile/teacher/schedule/";
}