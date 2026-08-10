import 'teacher_schedule_course_model.dart';

class TeacherScheduleDayModel {

  //----------------------------------------------------------
  // JOUR
  //----------------------------------------------------------

  final String weekday;

  final String label;

  //----------------------------------------------------------
  // COURS
  //----------------------------------------------------------

  final List<TeacherScheduleCourseModel> courses;

  const TeacherScheduleDayModel({

    required this.weekday,

    required this.label,

    required this.courses,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherScheduleDayModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherScheduleDayModel(

      weekday: json["weekday"],

      label: json["label"],

      courses:

          (json["courses"] as List)

              .map(

                (course) =>

                    TeacherScheduleCourseModel.fromJson(

                      course,

                    ),

              )

              .toList(),

    );

  }

  //----------------------------------------------------------
  // TO JSON
  //----------------------------------------------------------

  Map<String, dynamic> toJson() {

    return {

      "weekday": weekday,

      "label": label,

      "courses":

          courses

              .map(

                (course) =>

                    course.toJson(),

              )

              .toList(),

    };

  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherScheduleDayModel copyWith({

    String? weekday,

    String? label,

    List<TeacherScheduleCourseModel>? courses,

  }) {

    return TeacherScheduleDayModel(

      weekday: weekday ?? this.weekday,

      label: label ?? this.label,

      courses: courses ?? this.courses,

    );

  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  bool get isEmpty => courses.isEmpty;

  bool get isNotEmpty => courses.isNotEmpty;

  int get totalCourses => courses.length;

  TeacherScheduleCourseModel? get firstCourse {

    if (courses.isEmpty) {

      return null;

    }

    return courses.first;

  }

  TeacherScheduleCourseModel? get lastCourse {

    if (courses.isEmpty) {

      return null;

    }

    return courses.last;

  }

  String get timeRange {

    if (courses.isEmpty) {

      return "";

    }

    return "${courses.first.startTime} - ${courses.last.endTime}";

  }

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherScheduleDayModel("
        "weekday: $weekday, "
        "courses: ${courses.length})";

  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) {

      return true;

    }

    return other is TeacherScheduleDayModel &&
        other.weekday == weekday &&
        other.courses == courses;

  }

  @override
  int get hashCode {

    return Object.hash(

      weekday,

      Object.hashAll(courses),

    );

  }

}