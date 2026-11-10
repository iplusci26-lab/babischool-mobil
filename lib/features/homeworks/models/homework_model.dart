
import 'package:flutter/material.dart';
import '../models/homework_status.dart';

class HomeworkModel {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String teacher;
  final String type;
  final String assignedDate;
  final String dueDate;
  final String dateGroup;
  final String dateLabel;
  final String status;
  final String statusLabel;
  final String color;
  final String? attachment;
  final String? submittedAt;
  final String teacherComment;

  // Notes publiées
  final double? score;
  final double maxScore;
  final bool isGradePublished;
  final String? gradePublishedAt;

  const HomeworkModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.teacher,
    required this.type,
    required this.assignedDate,
    required this.dueDate,
    required this.dateGroup,
    required this.dateLabel,
    required this.status,
    required this.statusLabel,
    required this.color,
    required this.attachment,
    required this.submittedAt,
    required this.teacherComment,
    required this.score,
    required this.maxScore,
    required this.isGradePublished,
    required this.gradePublishedAt,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    return HomeworkModel(
      id: json["id"]?.toString() ?? "",
      title: json["title"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      subject: json["subject"]?.toString() ?? "",
      teacher: json["teacher"]?.toString() ?? "",
      type: "homework",
      assignedDate: json["assigned_date"]?.toString() ?? "",
      dueDate: json["due_date"]?.toString() ?? "",
      dateGroup: json["date_group"]?.toString() ?? "",
      dateLabel: json["date_label"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "pending",
      statusLabel: json["status_label"]?.toString() ?? "",
      color: json["color"]?.toString() ?? "gray",
      attachment: json["attachment"]?.toString(),
      submittedAt: json["submitted_at"]?.toString(),

      // Le backend transmet uniquement le commentaire publié.
      teacherComment: json["teacher_comment"]?.toString() ?? "",

      // Le backend transmet uniquement la note publiée dans "score".
      score: _toDouble(json["score"]),
      maxScore: _toDouble(json["max_score"]) ?? 20,
      isGradePublished: json["is_grade_published"] == true,
      gradePublishedAt: json["grade_published_at"]?.toString(),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  bool get hasScore =>
      isGradePublished && score != null;

  int get weight => 1;

  String get time => "";

  HomeworkStatus get homeworkStatus {
    switch (status) {
      case "submitted":
        return HomeworkStatus.submitted;
      case "late":
        return HomeworkStatus.late;
      case "missing":
        return HomeworkStatus.missing;
      default:
        return HomeworkStatus.pending;
    }
  }

  bool get hasAttachment =>
      attachment != null && attachment!.isNotEmpty;

  bool get hasTeacherComment =>
      isGradePublished && teacherComment.trim().isNotEmpty;

  bool get isPending => status == "pending";
  bool get isLate => status == "late";
  bool get isSubmitted => status == "submitted";
  bool get isMissing => status == "missing";

  Color get accentColor {
    switch (color) {
      case "green":
        return Colors.green;
      case "orange":
        return Colors.orange;
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
