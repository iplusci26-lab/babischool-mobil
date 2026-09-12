import 'package:flutter/material.dart';

import '../models/assessment_grade_model.dart';

class AssessmentTile extends StatelessWidget {
  final AssessmentGradeModel assessment;

  const AssessmentTile({
    super.key,
    required this.assessment,
  });

  // ==========================================================
  // COULEUR DU TYPE
  // ==========================================================

  Color get typeColor {
    switch (assessment.type) {
      case "exam":
        return Colors.red;

      case "test":
        return Colors.orange;

      default:
        return Colors.blue;
    }
  }

  // ==========================================================
  // LIBELLÉ DU TYPE
  // ==========================================================

  String get typeLabel {
    switch (assessment.type) {
      case "exam":
        return "Examen";

      case "test":
        return "Interrogation";

      default:
        return "Devoir";
    }
  }

  // ==========================================================
  // DATE FORMATÉE
  // ==========================================================

  String get formattedDate {
    if (assessment.date.isEmpty) {
      return "Date non disponible";
    }

    try {
      final date = DateTime.parse(assessment.date);

      const months = [
        "janvier",
        "février",
        "mars",
        "avril",
        "mai",
        "juin",
        "juillet",
        "août",
        "septembre",
        "octobre",
        "novembre",
        "décembre",
      ];

      return "${date.day} ${months[date.month - 1]} ${date.year}";
    } catch (_) {
      return assessment.date;
    }
  }

  // ==========================================================
  // NOTE FORMATÉE
  // ==========================================================

  String get formattedScore {
    return "${assessment.score.toStringAsFixed(2).replaceAll('.', ',')} / "
        "${assessment.maxScore.toStringAsFixed(0).replaceAll('.', ',')}";
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),

      // ======================================================
      // ICÔNE
      // ======================================================

      leading: CircleAvatar(
        radius: 19,

        backgroundColor: typeColor.withValues(
          alpha: .15,
        ),

        child: Icon(
          Icons.assignment_outlined,
          color: typeColor,
          size: 19,
        ),
      ),

      // ======================================================
      // INFORMATIONS
      // ======================================================

      title: Text(
        assessment.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(
          top: 4,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ------------------------------------------------
            // TYPE + COEFFICIENT
            // ------------------------------------------------

            Text(
              "$typeLabel • Coef ${assessment.weight}",
              style: TextStyle(
                fontSize: 12,
                color: typeColor,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(
              height: 3,
            ),

            // ------------------------------------------------
            // DATE
            // ------------------------------------------------

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Colors.grey,
                ),

                const SizedBox(
                  width: 4,
                ),

                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // ======================================================
      // NOTE
      // ======================================================

      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          const Text(
            "Note",
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            formattedScore,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}