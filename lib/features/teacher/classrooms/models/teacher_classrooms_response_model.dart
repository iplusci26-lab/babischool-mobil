import 'teacher_assignment_model.dart';
import 'teacher_info_model.dart';

class TeacherClassroomsResponseModel {

  //----------------------------------------------------------
  // DONNEES
  //----------------------------------------------------------

  final TeacherInfoModel teacher;

  final List<TeacherAssignmentModel> classes;

  const TeacherClassroomsResponseModel({

    required this.teacher,

    required this.classes,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherClassroomsResponseModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherClassroomsResponseModel(

      teacher: TeacherInfoModel.fromJson(

        json["teacher"],

      ),

      classes:

          (json["classes"] as List)

              .map(

                (item) =>

                    TeacherAssignmentModel.fromJson(

                      item,

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

      "classes":

          classes

              .map(

                (e) => e.toJson(),

              )

              .toList(),

    };

  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherClassroomsResponseModel copyWith({

    TeacherInfoModel? teacher,

    List<TeacherAssignmentModel>? classes,

  }) {

    return TeacherClassroomsResponseModel(

      teacher:

          teacher ?? this.teacher,

      classes:

          classes ?? this.classes,

    );

  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  bool get isEmpty => classes.isEmpty;

  bool get isNotEmpty => classes.isNotEmpty;

  int get totalClasses => classes.length;

  int get totalStudents {

    return classes.fold(

      0,

      (sum, assignment) =>

          sum + assignment.students,

    );

  }

  int get totalTodayCourses {

    return classes.fold(

      0,

      (sum, assignment) =>

          sum + assignment.todayCourses,

    );

  }

  List<TeacherAssignmentModel> get primaryAssignments {

    return classes.where(

      (assignment) =>

          assignment.isPrimary,

    ).toList();

  }

  List<TeacherAssignmentModel> get secondaryAssignments {

    return classes.where(

      (assignment) =>

          !assignment.isPrimary,

    ).toList();

  }

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherClassroomsResponseModel("
        "teacher: ${teacher.name}, "
        "classes: ${classes.length})";

  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) {

      return true;

    }

    return other is TeacherClassroomsResponseModel &&
        other.teacher == teacher &&
        other.classes == classes;

  }

  @override
  int get hashCode {

    return Object.hash(

      teacher,

      Object.hashAll(classes),

    );

  }

}