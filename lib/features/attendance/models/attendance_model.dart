class AttendanceSummary {
  final int present;
  final int absent;
  final int late;
  final int excused;

  AttendanceSummary({
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
  });

  factory AttendanceSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceSummary(
      present: json["present"] ?? 0,
      absent: json["absent"] ?? 0,
      late: json["late"] ?? 0,
      excused: json["excused"] ?? 0,
    );
  }
}


// ==========================================================
// SUBJECT
// ==========================================================

class AttendanceSubject {
  final String id;
  final String name;

  AttendanceSubject({
    required this.id,
    required this.name,
  });

  factory AttendanceSubject.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceSubject(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}


// ==========================================================
// TEACHER
// ==========================================================

class AttendanceTeacher {
  final String id;
  final String name;

  AttendanceTeacher({
    required this.id,
    required this.name,
  });

  factory AttendanceTeacher.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceTeacher(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}


// ==========================================================
// TIME SLOT
// ==========================================================

class AttendanceTimeSlot {
  final String id;
  final String name;
  final String startTime;
  final String endTime;

  AttendanceTimeSlot({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory AttendanceTimeSlot.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceTimeSlot(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
    );
  }
}


// ==========================================================
// HISTORY
// ==========================================================

class AttendanceHistory {
  final String date;

  final String status;

  final int minutesLate;

  final String remarks;

  final String sessionType;

  final String? period;

  final AttendanceSubject? subject;

  final AttendanceTeacher? teacher;

  final AttendanceTimeSlot? timeSlot;

  final String room;

  AttendanceHistory({
    required this.date,
    required this.status,
    required this.minutesLate,
    required this.remarks,
    required this.sessionType,
    required this.period,
    required this.subject,
    required this.teacher,
    required this.timeSlot,
    required this.room,
  });

  factory AttendanceHistory.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceHistory(
      date: json["date"] ?? "",

      status: json["status"] ?? "",

      minutesLate:
          json["minutes_late"] ?? 0,

      remarks:
          json["remarks"] ?? "",

      sessionType:
          json["session_type"] ?? "",

      period:
          json["period"],

      subject:
          json["subject"] != null
              ? AttendanceSubject.fromJson(
                  json["subject"],
                )
              : null,

      teacher:
          json["teacher"] != null
              ? AttendanceTeacher.fromJson(
                  json["teacher"],
                )
              : null,

      timeSlot:
          json["time_slot"] != null
              ? AttendanceTimeSlot.fromJson(
                  json["time_slot"],
                )
              : null,

      room:
          json["room"] ?? "",
    );
  }
}


// ==========================================================
// MAIN MODEL
// ==========================================================

class AttendanceModel {
  final AttendanceSummary summary;

  final List<AttendanceHistory> history;

  AttendanceModel({
    required this.summary,
    required this.history,
  });

  factory AttendanceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceModel(
      summary:
          AttendanceSummary.fromJson(
        json["summary"] ?? {},
      ),

      history:
          ((json["history"] ?? []) as List)
              .map(
                (e) =>
                    AttendanceHistory.fromJson(
                  e,
                ),
              )
              .toList(),
    );
  }
}