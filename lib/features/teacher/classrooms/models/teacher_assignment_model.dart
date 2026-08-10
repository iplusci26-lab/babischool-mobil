import 'teacher_classroom_group_model.dart';
import 'teacher_classroom_model.dart';
import 'teacher_next_course_model.dart';
import 'teacher_subject_model.dart';

class TeacherAssignmentModel {
  //----------------------------------------------------------
  // IDENTIFIANTS
  //----------------------------------------------------------

  final String assignmentId;

  final String assignmentType;

  //----------------------------------------------------------
  // MODE DE PRÉSENCE
  //----------------------------------------------------------

  final String attendanceMode;

  //----------------------------------------------------------
  // ÉTAT
  //----------------------------------------------------------

  final bool isPrimary;

  final bool isHomeroomTeacher;

  //----------------------------------------------------------
  // DONNÉES
  //----------------------------------------------------------

  final TeacherClassroomModel classroom;

  final TeacherClassroomGroupModel? group;

  final TeacherSubjectModel subject;

  final TeacherNextCourseModel? nextCourse;

  //----------------------------------------------------------
  // STATISTIQUES
  //----------------------------------------------------------

  final int students;

  final int todayCourses;

  //----------------------------------------------------------
  // UI
  //----------------------------------------------------------

  final String color;

  const TeacherAssignmentModel({
    required this.assignmentId,
    required this.assignmentType,
    required this.attendanceMode,
    required this.isPrimary,
    required this.isHomeroomTeacher,
    required this.classroom,
    this.group,
    required this.subject,
    this.nextCourse,
    required this.students,
    required this.todayCourses,
    required this.color,
  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherAssignmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherAssignmentModel(
      assignmentId: json["assignment_id"],
      assignmentType: json["assignment_type"],
      attendanceMode: json["attendance_mode"],
      isPrimary: json["is_primary"],
      isHomeroomTeacher: json["is_homeroom_teacher"],
      classroom: TeacherClassroomModel.fromJson(
        json["classroom"],
      ),
      group: json["group"] == null
          ? null
          : TeacherClassroomGroupModel.fromJson(
              json["group"],
            ),
      subject: TeacherSubjectModel.fromJson(
        json["subject"],
      ),
      nextCourse: json["next_course"] == null
          ? null
          : TeacherNextCourseModel.fromJson(
              json["next_course"],
            ),
      students: json["students"],
      todayCourses: json["today_courses"],
      color: json["color"],
    );
  }

  //----------------------------------------------------------
  // TO JSON
  //----------------------------------------------------------

  Map<String, dynamic> toJson() {
    return {
      "assignment_id": assignmentId,
      "assignment_type": assignmentType,
      "attendance_mode": attendanceMode,
      "is_primary": isPrimary,
      "is_homeroom_teacher": isHomeroomTeacher,
      "classroom": classroom.toJson(),
      "group": group?.toJson(),
      "subject": subject.toJson(),
      "next_course": nextCourse?.toJson(),
      "students": students,
      "today_courses": todayCourses,
      "color": color,
    };
  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherAssignmentModel copyWith({
    String? assignmentId,
    String? assignmentType,
    String? attendanceMode,
    bool? isPrimary,
    bool? isHomeroomTeacher,
    TeacherClassroomModel? classroom,
    TeacherClassroomGroupModel? group,
    TeacherSubjectModel? subject,
    TeacherNextCourseModel? nextCourse,
    int? students,
    int? todayCourses,
    String? color,
  }) {
    return TeacherAssignmentModel(
      assignmentId: assignmentId ?? this.assignmentId,
      assignmentType:
          assignmentType ?? this.assignmentType,
      attendanceMode:
          attendanceMode ?? this.attendanceMode,
      isPrimary: isPrimary ?? this.isPrimary,
      isHomeroomTeacher:
          isHomeroomTeacher ?? this.isHomeroomTeacher,
      classroom: classroom ?? this.classroom,
      group: group ?? this.group,
      subject: subject ?? this.subject,
      nextCourse: nextCourse ?? this.nextCourse,
      students: students ?? this.students,
      todayCourses:
          todayCourses ?? this.todayCourses,
      color: color ?? this.color,
    );
  }

  //----------------------------------------------------------
  // MODE DE PRÉSENCE
  //----------------------------------------------------------
  //
  // ÉCOLE PRIMAIRE
  // ----------------
  // L'appel se fait par périodes :
  //
  // - Entrée matin
  // - Retour récréation matin
  // - Entrée après-midi
  // - Retour récréation après-midi
  //
  // On utilise donc isPrimary comme source de vérité.
  //
  //----------------------------------------------------------

  bool get isPeriodAttendance {
    return isPrimary ||
        attendanceMode == "BY_PERIODS";
  }

  //----------------------------------------------------------
  // ÉCOLE SECONDAIRE
  // ----------------
  // L'appel se fait à partir d'un cours de l'emploi
  // du temps.
  //----------------------------------------------------------

  bool get isScheduleAttendance {
    return !isPrimary &&
        attendanceMode == "BY_SCHEDULE";
  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  bool get hasGroup {
    return group != null;
  }

  bool get hasNextCourse {
    return nextCourse != null;
  }

  //----------------------------------------------------------
  // PEUT PRENDRE LES PRÉSENCES
  //----------------------------------------------------------

  bool get canTakeAttendance {
    //--------------------------------------------------------
    // PRIMAIRE
    //--------------------------------------------------------

    if (isPrimary) {
      return true;
    }

    //--------------------------------------------------------
    // SECONDAIRE
    //--------------------------------------------------------

    return isScheduleAttendance && hasNextCourse;
  }

  //----------------------------------------------------------
  // NOM DE LA CLASSE
  //----------------------------------------------------------

  String get classroomName {
    return classroom.name;
  }

  //----------------------------------------------------------
  // NOM DE LA MATIÈRE
  //----------------------------------------------------------

  String get subjectName {
    return subject.name;
  }

  //----------------------------------------------------------
  // NOM DU GROUPE
  //----------------------------------------------------------

  String? get groupName {
    return group?.name;
  }

  //----------------------------------------------------------
  // NOM D'AFFICHAGE
  //----------------------------------------------------------

  String get displayName {
    if (hasGroup) {
      return "${classroom.name} (${group!.name})";
    }

    return classroom.name;
  }

  //----------------------------------------------------------
  // TO STRING
  //----------------------------------------------------------

  @override
  String toString() {
    return "TeacherAssignmentModel("
        "assignmentId: $assignmentId, "
        "classroom: ${classroom.name}, "
        "subject: ${subject.name}, "
        "attendanceMode: $attendanceMode, "
        "isPrimary: $isPrimary)";
  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TeacherAssignmentModel &&
        other.assignmentId == assignmentId;
  }

  @override
  int get hashCode => assignmentId.hashCode;
}