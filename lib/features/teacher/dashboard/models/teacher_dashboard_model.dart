class TeacherDashboardModel {

  final String id;

  final String name;

  final int todayCourses;

  final int classes;

  final int students;

  final int pendingHomeworks;

  final int pendingAssessments;

  final int unreadMessages;

  const TeacherDashboardModel({

    required this.id,

    required this.name,

    required this.todayCourses,

    required this.classes,

    required this.students,

    required this.pendingHomeworks,

    required this.pendingAssessments,

    required this.unreadMessages,

  });

  factory TeacherDashboardModel.fromJson(

    Map<String, dynamic> json,

  ) {

    final teacher = json["teacher"];

    return TeacherDashboardModel(

      id: teacher["id"],

      name: teacher["name"],

      todayCourses: json["today_courses"],

      classes: json["classes"],

      students: json["students"],

      pendingHomeworks: json["pending_homeworks"],

      pendingAssessments: json["pending_assessments"],

      unreadMessages: json["unread_messages"],

    );

  }

}