class TeacherAttendanceSessionModel {

  //----------------------------------------------------------
  // IDENTIFIANT
  //----------------------------------------------------------

  final String id;

  //----------------------------------------------------------
  // CLASSE
  //----------------------------------------------------------

  final String classroomId;

  final String classroomName;

  //----------------------------------------------------------
  // DATE
  //----------------------------------------------------------

  final DateTime attendanceDate;

  //----------------------------------------------------------
  // PRIMAIRE
  //----------------------------------------------------------

  final String? period;

  final String? periodLabel;

  //----------------------------------------------------------
  // SESSION
  //----------------------------------------------------------

  final String status;

  //----------------------------------------------------------
  // SECONDAIRE
  //----------------------------------------------------------

  final String? scheduleId;

  final String? subject;

  const TeacherAttendanceSessionModel({

    required this.id,

    required this.classroomId,

    required this.classroomName,

    required this.attendanceDate,

    this.period,

    this.periodLabel,

    required this.status,

    this.scheduleId,

    this.subject,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherAttendanceSessionModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TeacherAttendanceSessionModel(

      id:
          json["id"].toString(),

      classroomId:
          json["classroom_id"].toString(),

      classroomName:
          json["classroom_name"] ?? "",

      attendanceDate:
          DateTime.parse(
            json["attendance_date"],
          ),

      period:
          json["period"]?.toString(),

      periodLabel:
          json["period_label"]?.toString(),

      status:
          json["status"] ?? "OPEN",

      scheduleId:
          json["schedule_id"]?.toString(),

      subject:
          json["subject"]?.toString(),

    );

  }

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  Map<String, dynamic> toJson() {

    return {

      "id":
          id,

      "classroom_id":
          classroomId,

      "classroom_name":
          classroomName,

      "attendance_date":
          attendanceDate
              .toIso8601String()
              .split("T")
              .first,

      "period":
          period,

      "period_label":
          periodLabel,

      "status":
          status,

      "schedule_id":
          scheduleId,

      "subject":
          subject,

    };

  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  bool get isPrimary {

    return period != null;

  }

  bool get isSecondary {

    return scheduleId != null;

  }

  bool get isOpen {

    return status == "OPEN";

  }

  bool get isClosed {

    return status == "CLOSED";

  }

  bool get isCancelled {

    return status == "CANCELLED";

  }

  bool get canEdit {

    return isOpen;

  }

  //----------------------------------------------------------
  // LIBELLÉ DU TYPE
  //----------------------------------------------------------

  String get typeLabel {

    if (isPrimary) {

      return "Primaire";

    }

    return "Secondaire";

  }

  //----------------------------------------------------------
  // LIBELLÉ DE LA SESSION
  //----------------------------------------------------------

  String get sessionLabel {

    if (isPrimary) {

      return periodLabel ?? "Appel";

    }

    if (subject != null &&
        subject!.trim().isNotEmpty) {

      return subject!;

    }

    return "Appel";

  }

  //----------------------------------------------------------
  // LIBELLÉ COMPLET
  //----------------------------------------------------------

  String get displayTitle {

    if (isPrimary) {

      return "$classroomName • "
          "${periodLabel ?? "Appel"}";

    }

    return "$classroomName • "
        "${subject ?? "Appel"}";

  }

  //----------------------------------------------------------
  // STATUT
  //----------------------------------------------------------

  String get statusLabel {

    switch (status) {

      case "OPEN":
        return "En cours";

      case "CLOSED":
        return "Clôturé";

      case "CANCELLED":
        return "Annulé";

      default:
        return status;

    }

  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherAttendanceSessionModel copyWith({

    String? id,

    String? classroomId,

    String? classroomName,

    DateTime? attendanceDate,

    String? period,

    String? periodLabel,

    String? status,

    String? scheduleId,

    String? subject,

  }) {

    return TeacherAttendanceSessionModel(

      id:
          id ?? this.id,

      classroomId:
          classroomId ?? this.classroomId,

      classroomName:
          classroomName ?? this.classroomName,

      attendanceDate:
          attendanceDate ?? this.attendanceDate,

      period:
          period ?? this.period,

      periodLabel:
          periodLabel ?? this.periodLabel,

      status:
          status ?? this.status,

      scheduleId:
          scheduleId ?? this.scheduleId,

      subject:
          subject ?? this.subject,

    );

  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) {

      return true;

    }

    return other
            is TeacherAttendanceSessionModel &&
        other.id == id;

  }

  @override
  int get hashCode =>
      id.hashCode;

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherAttendanceSessionModel("
        "id: $id, "
        "classroom: $classroomName, "
        "type: $typeLabel, "
        "status: $status)";

  }

}