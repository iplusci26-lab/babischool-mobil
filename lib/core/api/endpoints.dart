class Endpoints {
  static const baseUrl = "https://iplus-api.onrender.com/api/v1";
  //"http://192.168.100.19:8000/api/v1";
  //"http://127.0.0.1:8000/api/v1";
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

  static const mobileAnnouncements =
    "/mobile/announcements";
}