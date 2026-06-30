import 'package:flutter/material.dart';

import '../../../shared/widgets/premium_card.dart';

import '../models/subject_grade_model.dart';

import 'assessment_tile.dart';

class SubjectGradeCard
    extends StatelessWidget {

  final SubjectGradeModel subject;

  const SubjectGradeCard({

    super.key,

    required this.subject,
  });

  @override
  Widget build(BuildContext context) {

    return PremiumCard(

      child: ExpansionTile(

        tilePadding: EdgeInsets.zero,

        childrenPadding:
            EdgeInsets.zero,

        title: Text(

          subject.subject,

          style: const TextStyle(

            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Text(

          subject.teacher,
        ),

        trailing: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Text(

              subject.average
                  .toStringAsFixed(2),

              style:
                  const TextStyle(

                fontWeight:
                    FontWeight.bold,

                fontSize: 18,
              ),
            ),

            const Text("/20"),
          ],
        ),

        children:

            subject.grades

                .map(

                  (e) =>

                      AssessmentTile(
                    assessment: e,
                  ),
                )

                .toList(),
      ),
    );
  }
}