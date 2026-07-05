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

  });

  factory HomeworkModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return HomeworkModel(

      id: json["id"],

      title: json["title"],

      description: json["description"] ?? "",

      subject: json["subject"],

      teacher: json["teacher"],

      type: "homework",

      assignedDate: json["assigned_date"],

      dueDate: json["due_date"],

      dateGroup: json["date_group"],

      dateLabel: json["date_label"],

      status: json["status"],

      statusLabel: json["status_label"],

      color: json["color"],

      attachment: json["attachment"],

      submittedAt: json["submitted_at"],

      teacherComment:

          json["teacher_comment"] ?? "",

    );

  }

  //-------------------------------------------------------
  // COMPATIBILITÉ AVEC LE DESIGN SYSTEM
  //-------------------------------------------------------

  bool get hasScore => false;

  double? get score => null;

  double get maxScore => 20;

  int get weight => 1;

  String get time => "";

  //-------------------------------------------------------
  // STATUT
  //-------------------------------------------------------

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

  //-------------------------------------------------------
  // AIDES UI
  //-------------------------------------------------------

  bool get hasAttachment =>

      attachment != null &&

      attachment!.isNotEmpty;

  bool get hasTeacherComment =>

      teacherComment.trim().isNotEmpty;

  bool get isPending =>

      status == "pending";

  bool get isLate =>

      status == "late";

  bool get isSubmitted =>

      status == "submitted";

  bool get isMissing =>

      status == "missing";

  //-------------------------------------------------------
  // COULEUR PRINCIPALE
  //-------------------------------------------------------

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