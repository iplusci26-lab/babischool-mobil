import 'package:flutter/material.dart';
import '../models/assessment_model.dart';

class AssessmentDetails extends StatelessWidget {

  final AssessmentModel assessment;

  const AssessmentDetails({

    super.key,

    required this.assessment,

  });

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        //--------------------------------------------------
        // DATE + HEURE
        //--------------------------------------------------

        Row(

          children: [

            Icon(

              Icons.calendar_today_outlined,

              size: 18,

              color: Colors.grey.shade600,

            ),

            const SizedBox(width: 8),

            Expanded(

              child: Text(

                assessment.dateLabel,

                style: TextStyle(

                  color: Colors.grey.shade700,

                ),

              ),

            ),

            if (assessment.time.isNotEmpty) ...[

              Icon(

                Icons.schedule_outlined,

                size: 18,

                color: Colors.grey.shade600,

              ),

              const SizedBox(width: 6),

              Text(

                assessment.time,

                style: const TextStyle(

                  fontWeight: FontWeight.w500,

                ),

              ),

            ],

          ],

        ),

        const SizedBox(height: 12),

        //--------------------------------------------------
        // COEFFICIENT + BAREME
        //--------------------------------------------------

        Row(

          children: [

            Icon(

              Icons.bar_chart,

              size: 18,

              color: Colors.grey.shade600,

            ),

            const SizedBox(width: 8),

            Text(

              "Coefficient ${assessment.weight}",

            ),

            const Spacer(),

            Icon(

              Icons.grade_outlined,

              size: 18,

              color: Colors.grey.shade600,

            ),

            const SizedBox(width: 6),

            Text(

              "/${assessment.maxScore.toStringAsFixed(0)}",

            ),

          ],

        ),

      ],

    );

  }

}