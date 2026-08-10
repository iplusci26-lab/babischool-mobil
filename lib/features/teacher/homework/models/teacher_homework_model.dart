class TeacherHomeworkScheduleModel {
  final String id;
  final String classroom;
  final String subject;
  final String assignmentType;

  const TeacherHomeworkScheduleModel({
    required this.id,
    required this.classroom,
    required this.subject,
    required this.assignmentType,
  });

  factory TeacherHomeworkScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherHomeworkScheduleModel(
      id: json["id"]?.toString() ?? "",
      classroom: json["classroom"]?.toString() ?? "",
      subject: json["subject"]?.toString() ?? "",
      assignmentType:
          json["assignment_type"]?.toString() ?? "",
    );
  }
}

// ============================================================
// HOMEWORK
// ============================================================

class TeacherHomeworkModel {
  final String id;
  final String title;
  final String description;
  final DateTime? assignedDate;
  final DateTime? dueDate;
  final bool published;
  final bool hasAttachment;

  const TeacherHomeworkModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedDate,
    required this.dueDate,
    required this.published,
    required this.hasAttachment,
  });

  factory TeacherHomeworkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherHomeworkModel(
      id: json["id"]?.toString() ?? "",

      title:
          json["title"]?.toString() ?? "",

      description:
          json["description"]?.toString() ?? "",

      assignedDate:
          _parseDate(json["assigned_date"]),

      dueDate:
          _parseDate(json["due_date"]),

      published:
          json["published"] == true,

      hasAttachment:
          json["has_attachment"] == true,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    final stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return null;
    }

    return DateTime.tryParse(stringValue);
  }

  bool get isOverdue {
    if (dueDate == null) {
      return false;
    }

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final due = DateTime(
      dueDate!.year,
      dueDate!.month,
      dueDate!.day,
    );

    return due.isBefore(today);
  }

  bool get isDueToday {
    if (dueDate == null) {
      return false;
    }

    final today = DateTime.now();

    return dueDate!.year == today.year &&
        dueDate!.month == today.month &&
        dueDate!.day == today.day;
  }

  String get dueDateLabel {
    if (dueDate == null) {
      return "Date non définie";
    }

    return "${dueDate!.day.toString().padLeft(2, '0')}/"
        "${dueDate!.month.toString().padLeft(2, '0')}/"
        "${dueDate!.year}";
  }

  TeacherHomeworkModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? assignedDate,
    DateTime? dueDate,
    bool? published,
    bool? hasAttachment,
  }) {
    return TeacherHomeworkModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedDate: assignedDate ?? this.assignedDate,
      dueDate: dueDate ?? this.dueDate,
      published: published ?? this.published,
      hasAttachment: hasAttachment ?? this.hasAttachment,
    );
  }
}

// ============================================================
// RESPONSE
// ============================================================

class TeacherHomeworkResponseModel {
  final TeacherHomeworkScheduleModel schedule;
  final List<TeacherHomeworkModel> homeworks;

  const TeacherHomeworkResponseModel({
    required this.schedule,
    required this.homeworks,
  });

  factory TeacherHomeworkResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawHomeworks =
        json["homeworks"] as List? ?? [];

    return TeacherHomeworkResponseModel(
      schedule:
          TeacherHomeworkScheduleModel.fromJson(
        json["schedule"] as Map<String, dynamic>? ?? {},
      ),
      homeworks: rawHomeworks
          .whereType<Map<String, dynamic>>()
          .map(
            TeacherHomeworkModel.fromJson,
          )
          .toList(),
    );
  }
}