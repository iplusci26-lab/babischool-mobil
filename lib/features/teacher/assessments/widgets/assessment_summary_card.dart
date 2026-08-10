import 'package:flutter/material.dart';

import '../../../../../shared/widgets/premium_card.dart';

class AssessmentSummaryCard extends StatelessWidget {

  final String classroom;

  final String subject;

  final int assessments;

  const AssessmentSummaryCard({

    super.key,

    required this.classroom,

    required this.subject,

    required this.assessments,

  });

  @override
  Widget build(BuildContext context) {

    return PremiumCard(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(

            classroom,

            style: const TextStyle(

              fontSize: 22,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 6),

          Text(

            subject,

            style: TextStyle(

              color: Colors.grey.shade700,

            ),

          ),

          const SizedBox(height: 18),

          Row(

            children: [

              const Icon(

                Icons.fact_check_outlined,

              ),

              const SizedBox(width: 8),

              Text(

                "$assessments évaluation(s)",

              ),

            ],

          ),

        ],

      ),

    );

  }

}