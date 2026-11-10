
class StaffStudentAbsenceModel {
  final String id;
  final DateTime date;
  final String? subject;
  final String? period;
  final String? periodDisplay;
  final String? startTime;
  final String? endTime;
  final String sessionStatus;
  final String justificationStatus;
  final String justificationReason;
  final String remarks;

  StaffStudentAbsenceModel({
    required this.id,
    required this.date,
    this.subject,
    this.period,
    this.periodDisplay,
    this.startTime,
    this.endTime,
    required this.sessionStatus,
    required this.justificationStatus,
    required this.justificationReason,
    required this.remarks,
  });

  factory StaffStudentAbsenceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StaffStudentAbsenceModel(
      id: json['id']?.toString() ?? '',
      date: DateTime.parse(json['date'].toString()),
      subject: json['subject']?.toString(),
      period: json['period']?.toString(),
      periodDisplay: json['period_display']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      sessionStatus: json['session_status']?.toString() ?? '',
      justificationStatus:
          json['justification_status']?.toString() ?? '',
      justificationReason:
          json['justification_reason']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
    );
  }
}

class StaffStudentAbsencesModel {
  final String studentId;
  final DateTime startDate;
  final DateTime endDate;
  final int totalAbsences;
  final int justifiedAbsences;
  final int pendingJustifications;
  final List<StaffStudentAbsenceModel> absences;

  StaffStudentAbsencesModel({
    required this.studentId,
    required this.startDate,
    required this.endDate,
    required this.totalAbsences,
    required this.justifiedAbsences,
    required this.pendingJustifications,
    required this.absences,
  });

  factory StaffStudentAbsencesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final absencesJson = json['absences'] as List<dynamic>? ?? [];

    return StaffStudentAbsencesModel(
      studentId: json['student_id']?.toString() ?? '',
      startDate: DateTime.parse(json['start_date'].toString()),
      endDate: DateTime.parse(json['end_date'].toString()),
      totalAbsences: _toInt(json['total_absences']),
      justifiedAbsences: _toInt(json['justified_absences']),
      pendingJustifications:
          _toInt(json['pending_justifications']),
      absences: absencesJson
          .map(
            (item) => StaffStudentAbsenceModel.fromJson(
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
