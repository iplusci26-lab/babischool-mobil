import 'package:flutter/material.dart';

enum HomeworkStatus {

  pending,

  submitted,

  late,

  missing,

}

extension HomeworkStatusExtension on HomeworkStatus {

  String get value {

    switch (this) {

      case HomeworkStatus.pending:
        return "pending";

      case HomeworkStatus.submitted:
        return "submitted";

      case HomeworkStatus.late:
        return "late";

      case HomeworkStatus.missing:
        return "missing";
    }

  }

  String get label {

    switch (this) {

      case HomeworkStatus.pending:
        return "À rendre";

      case HomeworkStatus.submitted:
        return "Remis";

      case HomeworkStatus.late:
        return "En retard";

      case HomeworkStatus.missing:
        return "Non remis";
    }

  }

  IconData get icon {

    switch (this) {

      case HomeworkStatus.pending:
        return Icons.schedule;

      case HomeworkStatus.submitted:
        return Icons.check_circle;

      case HomeworkStatus.late:
        return Icons.warning_amber_rounded;

      case HomeworkStatus.missing:
        return Icons.cancel;
    }

  }

  Color get color {

    switch (this) {

      case HomeworkStatus.pending:
        return Colors.orange;

      case HomeworkStatus.submitted:
        return Colors.green;

      case HomeworkStatus.late:
        return Colors.red;

      case HomeworkStatus.missing:
        return Colors.red.shade700;
    }

  }

  Color get backgroundColor {

    return color.withValues(
      alpha: .10,
    );

  }

}