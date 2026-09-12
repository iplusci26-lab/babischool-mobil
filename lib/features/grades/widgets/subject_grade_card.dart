import 'package:flutter/material.dart';

import '../../../shared/widgets/premium_card.dart';

import '../models/subject_grade_model.dart';

import 'assessment_tile.dart';

class SubjectGradeCard extends StatelessWidget {
  final SubjectGradeModel subject;

  const SubjectGradeCard({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // NOTES : PLUS RÉCENTE → PLUS ANCIENNE
    // ==========================================================

    final sortedGrades = [...subject.grades];

    sortedGrades.sort(
      (a, b) {
        final dateA = DateTime.tryParse(a.date);
        final dateB = DateTime.tryParse(b.date);

        // Les deux dates sont invalides ou absentes.
        if (dateA == null && dateB == null) {
          return 0;
        }

        // Une note sans date passe après une note datée.
        if (dateA == null) {
          return 1;
        }

        if (dateB == null) {
          return -1;
        }

        // Plus récente en premier.
        return dateB.compareTo(dateA);
      },
    );

    return PremiumCard(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,

        // ======================================================
        // MATIÈRE
        // ======================================================

        title: Text(
          subject.subject,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // ======================================================
        // ENSEIGNANT
        // ======================================================

        subtitle: Text(
          subject.teacher,
        ),

        // ======================================================
        // MOYENNE + INDICATION NOTES
        // ======================================================

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --------------------------------------------------
            // MOYENNE
            // --------------------------------------------------

            Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                const Text(
                  'Moyenne',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                Text(
                  '${subject.average.toStringAsFixed(2)}/20',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 10),

            // --------------------------------------------------
            // NOTES
            // --------------------------------------------------

            Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                const Text(
                  '▼',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        // ======================================================
        // DÉTAIL DES NOTES
        // ======================================================

        children: sortedGrades
            .map(
              (grade) => AssessmentTile(
                assessment: grade,
              ),
            )
            .toList(),
      ),
    );
  }
}