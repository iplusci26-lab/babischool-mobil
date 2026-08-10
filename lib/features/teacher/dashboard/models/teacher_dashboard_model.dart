class TeacherDashboardModel {
  final TeacherModel teacher;

  final TeacherSummaryModel summary;

  final TeacherNextCourseModel? nextCourse;

  final List<TeacherScheduleModel> todaySchedule;

  TeacherDashboardModel({
    required this.teacher,
    required this.summary,
    required this.nextCourse,
    required this.todaySchedule,
  });

  factory TeacherDashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherDashboardModel(
      teacher: TeacherModel.fromJson(
        json["teacher"],
      ),
      summary: TeacherSummaryModel.fromJson(
        json["summary"],
      ),
      nextCourse: json["next_course"] == null
          ? null
          : TeacherNextCourseModel.fromJson(
              json["next_course"],
            ),
      todaySchedule: (json["today_schedule"] as List)
          .map(
            (e) => TeacherScheduleModel.fromJson(
              e,
            ),
          )
          .toList(),
    );
  }
}

////////////////////////////////////////////////////////////
/// TEACHER
////////////////////////////////////////////////////////////

class TeacherModel {
  final String id;

  final String name;

  TeacherModel({
    required this.id,
    required this.name,
  });

  factory TeacherModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherModel(
      id: json["id"],
      name: json["name"],
    );
  }
}

////////////////////////////////////////////////////////////
/// SUMMARY
////////////////////////////////////////////////////////////

class TeacherSummaryModel {
  final int todayCourses;

  final int classes;

  final int students;

  final int pendingHomeworks;

  final int pendingAssessments;

  final int unreadMessages;

  TeacherSummaryModel({
    required this.todayCourses,
    required this.classes,
    required this.students,
    required this.pendingHomeworks,
    required this.pendingAssessments,
    required this.unreadMessages,
  });

  factory TeacherSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherSummaryModel(
      todayCourses: json["today_courses"],
      classes: json["classes"],
      students: json["students"],
      pendingHomeworks: json["pending_homeworks"],
      pendingAssessments: json["pending_assessments"],
      unreadMessages: json["unread_messages"],
    );
  }
}

////////////////////////////////////////////////////////////
/// SCHEDULE
////////////////////////////////////////////////////////////

class TeacherScheduleModel {
  final String id;

  final String title;

  final String classroom;

  final String classroomId;

  final String? subjectId;

  final String assignmentType;

  final String? room;

  final String startTime;

  final String endTime;

  TeacherScheduleModel({
    required this.id,
    required this.title,
    required this.classroom,
    required this.classroomId,
    required this.subjectId,
    required this.assignmentType,
    required this.room,
    required this.startTime,
    required this.endTime,
  });

  factory TeacherScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherScheduleModel(
      id: json["id"],
      title: json["title"],
      classroom: json["classroom"],
      classroomId: json["classroom_id"],
      subjectId: json["subject_id"],
      assignmentType: json["assignment_type"],
      room: json["room"],
      startTime: json["start_time"],
      endTime: json["end_time"],
    );
  }
}

////////////////////////////////////////////////////////////
/// NEXT COURSE
////////////////////////////////////////////////////////////

class TeacherNextCourseModel
    extends TeacherScheduleModel {
  final String status;

  final bool canTakeAttendance;

  TeacherNextCourseModel({
    required super.id,
    required super.title,
    required super.classroom,
    required super.classroomId,
    required super.subjectId,
    required super.assignmentType,
    required super.room,
    required super.startTime,
    required super.endTime,
    required this.status,
    required this.canTakeAttendance,
  });

  factory TeacherNextCourseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherNextCourseModel(
      id: json["id"],
      title: json["title"],
      classroom: json["classroom"],
      classroomId: json["classroom_id"],
      subjectId: json["subject_id"],
      assignmentType: json["assignment_type"],
      room: json["room"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      status: json["status"],
      canTakeAttendance:
          json["can_take_attendance"],
    );
  }
}