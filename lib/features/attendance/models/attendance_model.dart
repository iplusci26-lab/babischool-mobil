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
    Map<String,dynamic> json,
  ){

    return AttendanceSummary(

      present:
      json["present"] ?? 0,

      absent:
      json["absent"] ?? 0,

      late:
      json["late"] ?? 0,

      excused:
      json["excused"] ?? 0,
    );
  }
}

class AttendanceHistory {

  final String date;

  final String status;

  final int minutesLate;

  final String remarks;

  AttendanceHistory({

    required this.date,

    required this.status,

    required this.minutesLate,

    required this.remarks,
  });

  factory AttendanceHistory.fromJson(
    Map<String,dynamic> json,
  ){

    return AttendanceHistory(

      date:
      json["date"],

      status:
      json["status"],

      minutesLate:
      json["minutes_late"] ?? 0,

      remarks:
      json["remarks"] ?? "",
    );
  }
}

class AttendanceModel {

  final AttendanceSummary summary;

  final List<AttendanceHistory> history;

  AttendanceModel({

    required this.summary,

    required this.history,
  });

  factory AttendanceModel.fromJson(
    Map<String,dynamic> json,
  ){

    return AttendanceModel(

      summary:

      AttendanceSummary.fromJson(
        json["summary"],
      ),

      history:

      (json["history"] as List)

      .map(
        (e)=>

        AttendanceHistory
        .fromJson(e),
      )

      .toList(),
    );
  }
}