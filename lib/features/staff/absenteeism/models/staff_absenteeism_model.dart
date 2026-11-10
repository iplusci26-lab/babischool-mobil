
class StaffDailyAbsenteeismModel {
  final DateTime date;
  final int total;
  final int absent;
  final int late;

  const StaffDailyAbsenteeismModel({
    required this.date,
    required this.total,
    required this.absent,
    required this.late,
  });

  factory StaffDailyAbsenteeismModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StaffDailyAbsenteeismModel(
      date: DateTime.parse(
        json['session__attendance_date'].toString(),
      ),
      total: _toInt(json['total']),
      absent: _toInt(json['absent']),
      late: _toInt(json['late']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}

class StaffAbsenteeismModel {
  final DateTime startDate;
  final DateTime endDate;

  final int totalRecords;
  final int totalAbsences;
  final int totalLates;

  final int justifiedAbsences;
  final int pendingJustifications;

  final int totalAbsencePeriods;
  final int totalAbsenceMinutes;
  final double totalAbsenceHours;

  final int totalLateMinutes;

  final List<StaffDailyAbsenteeismModel> dailyStatistics;

  const StaffAbsenteeismModel({
    required this.startDate,
    required this.endDate,
    required this.totalRecords,
    required this.totalAbsences,
    required this.totalLates,
    required this.justifiedAbsences,
    required this.pendingJustifications,
    required this.totalAbsencePeriods,
    required this.totalAbsenceMinutes,
    required this.totalAbsenceHours,
    required this.totalLateMinutes,
    required this.dailyStatistics,
  });

  factory StaffAbsenteeismModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dailyData = json['daily_statistics'] as List? ?? [];

    return StaffAbsenteeismModel(
      startDate: DateTime.parse(json['start_date'].toString()),
      endDate: DateTime.parse(json['end_date'].toString()),

      totalRecords: _toInt(json['total_records']),
      totalAbsences: _toInt(json['total_absences']),
      totalLates: _toInt(json['total_lates']),

      justifiedAbsences: _toInt(json['justified_absences']),
      pendingJustifications: _toInt(json['pending_justifications']),

      totalAbsencePeriods: _toInt(json['total_absence_periods']),
      totalAbsenceMinutes: _toInt(json['total_absence_minutes']),
      totalAbsenceHours: _toDouble(json['total_absence_hours']),

      totalLateMinutes: _toInt(json['total_late_minutes']),

      dailyStatistics: dailyData
          .map(
            (item) => StaffDailyAbsenteeismModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
