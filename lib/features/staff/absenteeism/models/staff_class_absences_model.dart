
class StaffClassAbsenceModel {
  final String id;
  final String studentId;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String fullName;
  final DateTime date;
  final String? period;
  final String? periodDisplay;
  final String? subject;
  final String sessionStatus;
  final String justificationStatus;
  final String justificationReason;
  final String remarks;
  final String? startTime;
  final String? endTime;

  StaffClassAbsenceModel({
    required this.id,
    required this.studentId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.date,
    this.period,
    this.periodDisplay,
    this.subject,
    required this.sessionStatus,
    required this.justificationStatus,
    required this.justificationReason,
    required this.remarks,
    this.startTime,
    this.endTime,
  });

  factory StaffClassAbsenceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StaffClassAbsenceModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      studentNumber: json['student_number']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      date: DateTime.parse(json['date'].toString()),
      period: json['period']?.toString(),
      periodDisplay: json['period_display']?.toString(),
      subject: json['subject']?.toString(),
      sessionStatus: json['session_status']?.toString() ?? '',
      justificationStatus:
          json['justification_status']?.toString() ?? '',
      justificationReason:
          json['justification_reason']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
    );
  }
}

class StaffClassAbsencesModel {
  final String classroomId;
  final String classroomName;
  final String? classroomLevel;
  final DateTime startDate;
  final DateTime endDate;
  final int totalAbsences;
  final int totalStudentsAbsent;
  final List<StaffClassAbsenceModel> absences;

  StaffClassAbsencesModel({
    required this.classroomId,
    required this.classroomName,
    this.classroomLevel,
    required this.startDate,
    required this.endDate,
    required this.totalAbsences,
    required this.totalStudentsAbsent,
    required this.absences,
  });

  factory StaffClassAbsencesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final classroom = json['classroom'] as Map<String, dynamic>;
    final absencesJson = json['absences'] as List<dynamic>? ?? [];

    return StaffClassAbsencesModel(
      classroomId: classroom['id']?.toString() ?? '',
      classroomName: classroom['name']?.toString() ?? '',
      classroomLevel: classroom['level']?.toString(),
      startDate: DateTime.parse(json['start_date'].toString()),
      endDate: DateTime.parse(json['end_date'].toString()),
      totalAbsences: _toInt(json['total_absences']),
      totalStudentsAbsent: _toInt(json['total_students_absent']),
      absences: absencesJson
          .map(
            (item) => StaffClassAbsenceModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
