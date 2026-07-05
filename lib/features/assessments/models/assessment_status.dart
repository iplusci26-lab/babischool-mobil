import 'package:flutter/material.dart';

/// =======================================================
///
/// Statuts métier des évaluations / devoirs.
///
/// Ce fichier est partagé par :
///
/// - Evaluations
/// - Devoirs
/// - Agenda scolaire
///
/// =======================================================

enum AssessmentStatus {

  upcoming,

  today,

  graded,

  late,

  cancelled,

}

/// =======================================================
///
/// Extensions UI
///
/// =======================================================

extension AssessmentStatusExtension
    on AssessmentStatus {

  /// -----------------------------
  /// Backend -> Enum
  /// -----------------------------

  static AssessmentStatus fromString(
    String value,
  ) {

    switch (value) {

      case "today":

        return AssessmentStatus.today;

      case "graded":

        return AssessmentStatus.graded;

      case "late":

        return AssessmentStatus.late;

      case "cancelled":

        return AssessmentStatus.cancelled;

      default:

        return AssessmentStatus.upcoming;

    }
  }

  /// -----------------------------
  /// Texte affiché
  /// -----------------------------

  String get label {

    switch (this) {

      case AssessmentStatus.today:

        return "Aujourd'hui";

      case AssessmentStatus.upcoming:

        return "À venir";

      case AssessmentStatus.graded:

        return "Corrigée";

      case AssessmentStatus.late:

        return "En retard";

      case AssessmentStatus.cancelled:

        return "Annulée";
    }
  }

  /// -----------------------------
  /// Couleur principale
  /// -----------------------------

  Color get color {

    switch (this) {

      case AssessmentStatus.today:

        return Colors.orange;

      case AssessmentStatus.upcoming:

        return Colors.blue;

      case AssessmentStatus.graded:

        return Colors.green;

      case AssessmentStatus.late:

        return Colors.red;

      case AssessmentStatus.cancelled:

        return Colors.grey;
    }
  }

  /// -----------------------------
  /// Couleur de fond
  /// -----------------------------

  Color get backgroundColor {

    return color.withValues(
      alpha: .10,
    );
  }

  /// -----------------------------
  /// Icône
  /// -----------------------------

  IconData get icon {

    switch (this) {

      case AssessmentStatus.today:

        return Icons.schedule;

      case AssessmentStatus.upcoming:

        return Icons.event;

      case AssessmentStatus.graded:

        return Icons.check_circle;

      case AssessmentStatus.late:

        return Icons.warning_amber_rounded;

      case AssessmentStatus.cancelled:

        return Icons.cancel;
    }
  }

  /// -----------------------------
  /// Affichage du score ?
  /// -----------------------------

  bool get showScore {

    return this ==
        AssessmentStatus.graded;
  }

  /// -----------------------------
  /// Affichage du badge ?
  /// -----------------------------

  bool get showBadge => true;
}