class TeacherCourseModel {

  final String classroomId;

  final String scheduleId;

  final String classroomName;

  final String name;

  final String subject;

  final int students;

  final bool today;

  final String startTime;

  final String endTime;

  final String nextCourse;

  final String color;

  const TeacherCourseModel({

    required this.classroomId,

    required this.classroomName,

    required this.scheduleId,

    required this.startTime,

    required this.endTime,

    required this.name,

    required this.subject,

    required this.students,

    required this.today,

    required this.nextCourse,

    required this.color,

  });

  factory TeacherCourseModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TeacherCourseModel(

      classroomId: json["classroom_id"] ?? "" ,

      scheduleId: json["schedule_id"] ?? "" ,

      name: json["name"] ?? "" ,

      subject: json["subject"] ?? "" ,

      students: json["students"] ?? 0,

      today: json["today"] ?? false,

      nextCourse: json["next_course"] ?? "",

      color: json["color"] ?? "#6214BE",

      classroomName: json["classroom_name"] ?? "",

      startTime: json["start_time"] ?? "",

      endTime: json["end_time"] ?? "",

    );

  }

}