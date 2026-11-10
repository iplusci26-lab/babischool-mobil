
class StaffDashboardModel {
  final String? academicYear;
  final int totalClassrooms;
  final int totalStudents;
  final StaffAttendanceStats attendance;

  const StaffDashboardModel({
    this.academicYear,
    required this.totalClassrooms,
    required this.totalStudents,
    required this.attendance,
  });

  factory StaffDashboardModel.fromJson(Map<String, dynamic> json) {
    return StaffDashboardModel(
      academicYear: json['academic_year']?.toString(),
      totalClassrooms: _toInt(json['total_classrooms']),
      totalStudents: _toInt(json['total_students']),
      attendance: StaffAttendanceStats.fromJson(
        json['attendance'] is Map
            ? Map<String, dynamic>.from(json['attendance'])
            : {},
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class StaffAttendanceStats {
  final String? date;
  final int sessions;
  final int studentsRecorded;
  final int present;
  final int absent;
  final int late;

  const StaffAttendanceStats({
    this.date,
    required this.sessions,
    required this.studentsRecorded,
    required this.present,
    required this.absent,
    required this.late,
  });

  factory StaffAttendanceStats.fromJson(Map<String, dynamic> json) {
    return StaffAttendanceStats(
      date: json['date']?.toString(),
      sessions: StaffDashboardModel._toInt(json['sessions']),
      studentsRecorded:
          StaffDashboardModel._toInt(json['students_recorded']),
      present: StaffDashboardModel._toInt(json['present']),
      absent: StaffDashboardModel._toInt(json['absent']),
      late: StaffDashboardModel._toInt(json['late']),
    );
  }
}
