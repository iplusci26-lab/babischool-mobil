import '../../classrooms/models/teacher_info_model.dart';

import 'teacher_schedule_day_model.dart';
import 'teacher_schedule_course_model.dart';

class TeacherScheduleResponseModel {

  //----------------------------------------------------------
  // ENSEIGNANT
  //----------------------------------------------------------

  final TeacherInfoModel teacher;

  //----------------------------------------------------------
  // EMPLOI DU TEMPS
  //----------------------------------------------------------

  final List<TeacherScheduleDayModel> days;

  const TeacherScheduleResponseModel({

    required this.teacher,

    required this.days,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherScheduleResponseModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherScheduleResponseModel(

      teacher: TeacherInfoModel.fromJson(

        json["teacher"],

      ),

      days:

          (json["days"] as List)

              .map(

                (day) =>

                    TeacherScheduleDayModel.fromJson(

                      day,

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

      "teacher": teacher.toJson(),

      "days":

          days

              .map(

                (day) =>

                    day.toJson(),

              )

              .toList(),

    };

  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherScheduleResponseModel copyWith({

    TeacherInfoModel? teacher,

    List<TeacherScheduleDayModel>? days,

  }) {

    return TeacherScheduleResponseModel(

      teacher: teacher ?? this.teacher,

      days: days ?? this.days,

    );

  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  bool get isEmpty => days.isEmpty;

  bool get isNotEmpty => days.isNotEmpty;

  int get totalDays => days.length;

  int get totalCourses {

    return days.fold(

      0,

      (sum, day) =>

          sum + day.totalCourses,

    );

  }

  List<TeacherScheduleCourseModel> get allCourses {

    return days.expand(

      (day) => day.courses,

    ).toList();

  }

  TeacherScheduleDayModel? dayOf(

    String weekday,

  ) {

    try {

      return days.firstWhere(

        (day) =>

            day.weekday == weekday,

      );

    } catch (_) {

      return null;

    }

  }

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherScheduleResponseModel("
        "teacher: ${teacher.name}, "
        "days: ${days.length})";

  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) {

      return true;

    }

    return other is TeacherScheduleResponseModel &&
        other.teacher == teacher &&
        other.days == days;

  }

  @override
  int get hashCode {

    return Object.hash(

      teacher,

      Object.hashAll(days),

    );

  }

}