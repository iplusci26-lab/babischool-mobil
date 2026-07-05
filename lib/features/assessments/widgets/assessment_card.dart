import 'package:flutter/material.dart';

import '../../../shared/widgets/premium_card.dart';

import '../models/assessment_model.dart';
import 'assessment_icon.dart';
import 'assessment_status_chip.dart';
import 'assessment_header.dart';
import 'assessment_details.dart';



class AssessmentCard   extends StatelessWidget {

  final AssessmentModel assessment;

  const AssessmentCard ({

    super.key,

    required this.assessment,

  });

  @override
  Widget build(BuildContext context) {

    final status = assessment.status;

    return PremiumCard(

      padding: const EdgeInsets.all(18),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          //-------------------------------------------------------
          // HEADER
          //-------------------------------------------------------

            AssessmentHeader(

                assessment: assessment,

            ),

            const SizedBox(
            height: 18,
            ),

          //-------------------------------------------------------
          // PROFESSEUR
          //-------------------------------------------------------

          Row(

            children: [

              Icon(

                Icons.person,

                size: 18,

                color: Colors.grey.shade600,

              ),

              const SizedBox(width: 8),

              Expanded(

                child: Text(

                  assessment.teacher,

                  style: TextStyle(

                    color: Colors.grey.shade700,

                  ),

                ),

              ),

            ],

          ),

          const SizedBox(height: 12),

          //-------------------------------------------------------
          // DATE et COEFFICIENT
          //-------------------------------------------------------

         AssessmentDetails(

            assessment: assessment,
            ),

            const SizedBox(
            height: 18,
            ),

          //-------------------------------------------------------
          // FOOTER
          //-------------------------------------------------------

         Align(

        alignment: Alignment.centerRight,

        child: AssessmentStatusChip(

            status: assessment.status,

        ),

        ),
        ],

      ),

    );

  }

}