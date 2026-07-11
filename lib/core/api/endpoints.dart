class Endpoints {
  static const baseUrl = "https://iplus-api.onrender.com/api/v1";
    


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