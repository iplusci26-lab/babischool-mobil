class TeacherAssessmentModel {
  final String id;

  final String title;

  final String assessmentType;

  final String assessmentTypeLabel;

  final String category;

  final String categoryLabel;

  final double maxScore;

  final int weight;

  final String status;

  final String statusLabel;

  final DateTime dateAssessment;

  final TeacherAssessmentClassroomModel classroom;

  final TeacherAssessmentSubjectModel subject;

  final TeacherAssessmentTermModel term;

  const TeacherAssessmentModel({
    required this.id,
    required this.title,
    required this.assessmentType,
    required this.assessmentTypeLabel,
    required this.category,
    required this.categoryLabel,
    required this.maxScore,
    required this.weight,
    required this.status,
    required this.statusLabel,
    required this.dateAssessment,
    required this.classroom,
    required this.subject,
    required this.term,
  });

  factory TeacherAssessmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherAssessmentModel(
      id:
          json["id"]?.toString() ?? "",

      title:
          json["title"]?.toString() ?? "",

      assessmentType:
          json["assessment_type"]?.toString() ?? "",

      assessmentTypeLabel:
          json["assessment_type_label"]?.toString() ?? "",

      category:
          json["category"]?.toString() ?? "",

      categoryLabel:
          json["category_label"]?.toString() ?? "",

      maxScore:
          _toDouble(json["max_score"]),

      weight:
          _toInt(json["weight"]),

      status:
          json["status"]?.toString() ?? "",

      statusLabel:
          json["status_label"]?.toString() ?? "",

      dateAssessment:
          _parseDate(json["date_assessment"]),

      classroom:
          TeacherAssessmentClassroomModel.fromJson(
        Map<String, dynamic>.from(
          json["classroom"] is Map
              ? json["classroom"]
              : {},
        ),
      ),

      subject:
          TeacherAssessmentSubjectModel.fromJson(
        Map<String, dynamic>.from(
          json["subject"] is Map
              ? json["subject"]
              : {},
        ),
      ),

      term:
          TeacherAssessmentTermModel.fromJson(
        Map<String, dynamic>.from(
          json["term"] is Map
              ? json["term"]
              : {},
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "assessment_type": assessmentType,
      "assessment_type_label": assessmentTypeLabel,
      "category": category,
      "category_label": categoryLabel,
      "max_score": maxScore,
      "weight": weight,
      "status": status,
      "status_label": statusLabel,
      "date_assessment":
          dateAssessment.toIso8601String(),
      "classroom":
          classroom.toJson(),
      "subject":
          subject.toJson(),
      "term":
          term.toJson(),
    };
  }

  bool get isDraft {
    return status == "draft";
  }

  bool get isInProgress {
    return status == "in_progress";
  }

  bool get isReady {
    return status == "ready";
  }

  bool get isPublished {
    return status == "published";
  }

  bool get requiresRepublish {
    return status == "republish_required";
  }

  bool get canEdit {
    return !isPublished;
  }

  bool get canDelete {
    return !isPublished;
  }

  bool get canMarkReady {
    return !isPublished &&
        !isReady;
  }

  String get displayName {
    return "$title • ${subject.name}";
  }

  TeacherAssessmentModel copyWith({
    String? id,
    String? title,
    String? assessmentType,
    String? assessmentTypeLabel,
    String? category,
    String? categoryLabel,
    double? maxScore,
    int? weight,
    String? status,
    String? statusLabel,
    DateTime? dateAssessment,
    TeacherAssessmentClassroomModel? classroom,
    TeacherAssessmentSubjectModel? subject,
    TeacherAssessmentTermModel? term,
  }) {
    return TeacherAssessmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      assessmentType:
          assessmentType ?? this.assessmentType,
      assessmentTypeLabel:
          assessmentTypeLabel ??
              this.assessmentTypeLabel,
      category:
          category ?? this.category,
      categoryLabel:
          categoryLabel ?? this.categoryLabel,
      maxScore:
          maxScore ?? this.maxScore,
      weight:
          weight ?? this.weight,
      status:
          status ?? this.status,
      statusLabel:
          statusLabel ?? this.statusLabel,
      dateAssessment:
          dateAssessment ??
              this.dateAssessment,
      classroom:
          classroom ?? this.classroom,
      subject:
          subject ?? this.subject,
      term:
          term ?? this.term,
    );
  }

  @override
  String toString() {
    return "TeacherAssessmentModel("
        "id: $id, "
        "title: $title, "
        "subject: ${subject.name}, "
        "status: $status)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TeacherAssessmentModel &&
        other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

//============================================================
// CLASSROOM
//============================================================

class TeacherAssessmentClassroomModel {
  final String id;
  final String name;

  const TeacherAssessmentClassroomModel({
    required this.id,
    required this.name,
  });

  factory TeacherAssessmentClassroomModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherAssessmentClassroomModel(
      id:
          json["id"]?.toString() ?? "",
      name:
          json["name"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

//============================================================
// SUBJECT
//============================================================

class TeacherAssessmentSubjectModel {
  final String id;
  final String name;

  const TeacherAssessmentSubjectModel({
    required this.id,
    required this.name,
  });

  factory TeacherAssessmentSubjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherAssessmentSubjectModel(
      id:
          json["id"]?.toString() ?? "",
      name:
          json["name"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

//============================================================
// TERM
//============================================================

class TeacherAssessmentTermModel {
  final String id;
  final String name;

  const TeacherAssessmentTermModel({
    required this.id,
    required this.name,
  });

  factory TeacherAssessmentTermModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherAssessmentTermModel(
      id:
          json["id"]?.toString() ?? "",
      name:
          json["name"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

//============================================================
// HELPERS
//============================================================

double _toDouble(
  dynamic value,
) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
        value.toString().replaceAll(",", "."),
      ) ??
      0;
}

int _toInt(
  dynamic value,
) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
        value.toString(),
      ) ??
      0;
}

DateTime _parseDate(
  dynamic value,
) {
  if (value == null) {
    return DateTime.now();
  }

  return DateTime.tryParse(
        value.toString(),
      ) ??
      DateTime.now();
}