import 'package:flutter/material.dart';

import '../../../../../shared/widgets/premium_card.dart';

class TeacherHomeworksSummaryCard extends StatelessWidget {

  final String classroom;
  final String subject;
  final int total;

  const TeacherHomeworksSummaryCard({

    super.key,

    required this.classroom,

    required this.subject,

    required this.total,

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

          Text(subject),

          const SizedBox(height: 18),

          Row(

            children: [

              const Icon(Icons.assignment),

              const SizedBox(width: 8),

              Text(

                "$total devoir(s)",

              ),

            ],

          ),

        ],

      ),

    );

  }

}