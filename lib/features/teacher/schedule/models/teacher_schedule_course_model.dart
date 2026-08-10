import '../../classrooms/models/teacher_classroom_group_model.dart';
import '../../classrooms/models/teacher_classroom_model.dart';
import '../../classrooms/models/teacher_subject_model.dart';
import 'package:flutter/foundation.dart';
class TeacherScheduleCourseModel {
  //============================================================
  // IDENTIFIANTS
  //============================================================

  final String scheduleId;

  final String assignmentId;

  //============================================================
  // TYPE
  //============================================================

  final String assignmentType;

  final String attendanceMode;

  final bool isPrimary;

  //============================================================
  // DONNÉES
  //============================================================

  final TeacherClassroomModel classroom;

  final TeacherClassroomGroupModel? group;

  final TeacherSubjectModel subject;

  //============================================================
  // HORAIRES
  //============================================================

  final String startTime;

  final String endTime;

  final String? room;

  const TeacherScheduleCourseModel({
    required this.scheduleId,
    required this.assignmentId,
    required this.assignmentType,
    required this.attendanceMode,
    required this.isPrimary,
    required this.classroom,
    this.group,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.room,
  });

  //============================================================
  // JSON
  //============================================================

  factory TeacherScheduleCourseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    debugPrint(
    "========================================",
  );

  debugPrint(
    "SCHEDULE COURSE JSON:",
  );

  debugPrint(
    json.toString(),
  );

  debugPrint(
    "schedule_id = ${json["schedule_id"]}",
  );

  debugPrint(
    "assignment_id = ${json["assignment_id"]}",
  );

  debugPrint(
    "assignment_type = ${json["assignment_type"]}",
  );

  debugPrint(
    "attendance_mode = ${json["attendance_mode"]}",
  );

  debugPrint(
    "is_primary = ${json["is_primary"]}",
  );

  debugPrint(
    "classroom = ${json["classroom"]}",
  );

  debugPrint(
    "group = ${json["group"]}",
  );

  debugPrint(
    "subject = ${json["subject"]}",
  );

  debugPrint(
    "start_time = ${json["start_time"]}",
  );

  debugPrint(
    "end_time = ${json["end_time"]}",
  );

  debugPrint(
    "room = ${json["room"]}",
  );

  debugPrint(
    "========================================",
  );
    return TeacherScheduleCourseModel(
      scheduleId:
          json["schedule_id"]?.toString() ?? "",

      assignmentId:
          json["assignment_id"]?.toString() ?? "",

      assignmentType:
          json["assignment_type"]?.toString() ?? "SUBJECT",

      // -------------------------------------------------------
      // IMPORTANT
      // -------------------------------------------------------
      // Certaines anciennes réponses API peuvent ne pas encore
      // contenir attendance_mode.
      //
      // Pour le primaire, BY_PERIODS est le comportement attendu.
      // -------------------------------------------------------

      attendanceMode:
          json["attendance_mode"]?.toString() ??
          (json["is_primary"] == true
              ? "BY_PERIODS"
              : "BY_SCHEDULE"),

      isPrimary:
          json["is_primary"] == true,

      classroom:
          TeacherClassroomModel.fromJson(
        Map<String, dynamic>.from(
          json["classroom"] ?? {},
        ),
      ),

      group:
          json["group"] == null
              ? null
              : TeacherClassroomGroupModel.fromJson(
                  Map<String, dynamic>.from(
                    json["group"],
                  ),
                ),

      subject:
          TeacherSubjectModel.fromJson(
        Map<String, dynamic>.from(
          json["subject"] ?? {},
        ),
      ),

      startTime:
          json["start_time"]?.toString() ?? "",

      endTime:
          json["end_time"]?.toString() ?? "",

      // room PEUT être null.
      room:
          json["room"]?.toString(),
    );
  }

  //============================================================
  // TO JSON
  //============================================================

  Map<String, dynamic> toJson() {
    return {
      "schedule_id": scheduleId,
      "assignment_id": assignmentId,
      "assignment_type": assignmentType,
      "attendance_mode": attendanceMode,
      "is_primary": isPrimary,
      "classroom": classroom.toJson(),
      "group": group?.toJson(),
      "subject": subject.toJson(),
      "start_time": startTime,
      "end_time": endTime,
      "room": room,
    };
  }

  //============================================================
  // COPY WITH
  //============================================================

  TeacherScheduleCourseModel copyWith({
    String? scheduleId,
    String? assignmentId,
    String? assignmentType,
    String? attendanceMode,
    bool? isPrimary,
    TeacherClassroomModel? classroom,
    TeacherClassroomGroupModel? group,
    TeacherSubjectModel? subject,
    String? startTime,
    String? endTime,
    String? room,
  }) {
    return TeacherScheduleCourseModel(
      scheduleId:
          scheduleId ?? this.scheduleId,

      assignmentId:
          assignmentId ?? this.assignmentId,

      assignmentType:
          assignmentType ?? this.assignmentType,

      attendanceMode:
          attendanceMode ?? this.attendanceMode,

      isPrimary:
          isPrimary ?? this.isPrimary,

      classroom:
          classroom ?? this.classroom,

      group:
          group ?? this.group,

      subject:
          subject ?? this.subject,

      startTime:
          startTime ?? this.startTime,

      endTime:
          endTime ?? this.endTime,

      room:
          room ?? this.room,
    );
  }

  //============================================================
  // HELPERS
  //============================================================

  String get period {
    if (startTime.isEmpty && endTime.isEmpty) {
      return "";
    }

    return "$startTime - $endTime";
  }

  bool get hasGroup {
    return group != null;
  }

  bool get hasRoom {
    return room != null &&
        room!.trim().isNotEmpty;
  }

  String get classroomName {
    return classroom.name;
  }

  String get subjectName {
    return subject.name;
  }

  String? get groupName {
    return group?.name;
  }

  String get displayClassroom {
    if (group != null) {
      return "${classroom.name} (${group!.name})";
    }

    return classroom.name;
  }

  //============================================================
  // PRÉSENCE
  //============================================================

  bool get isPeriodAttendance {
    return attendanceMode == "BY_PERIODS";
  }

  bool get isScheduleAttendance {
    return attendanceMode == "BY_SCHEDULE";
  }

  bool get canTakeAttendance {
    if (isPeriodAttendance) {
      return true;
    }

    return isScheduleAttendance;
  }

  //============================================================
  // DEBUG
  //============================================================

  @override
  String toString() {
    return "TeacherScheduleCourseModel("
        "scheduleId: $scheduleId, "
        "assignmentId: $assignmentId, "
        "assignmentType: $assignmentType, "
        "attendanceMode: $attendanceMode, "
        "isPrimary: $isPrimary, "
        "classroom: ${classroom.name}, "
        "subject: ${subject.name}, "
        "period: $period)";
  }

  //============================================================
  // EQUALITY
  //============================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TeacherScheduleCourseModel &&
        other.scheduleId == scheduleId;
  }

  @override
  int get hashCode {
    return scheduleId.hashCode;
  }
}