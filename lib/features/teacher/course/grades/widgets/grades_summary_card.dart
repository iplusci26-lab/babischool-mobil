import 'package:flutter/material.dart';

import '../../../../../shared/widgets/premium_card.dart';

class GradesSummaryCard extends StatelessWidget {

  final String title;

  final double maxScore;

  final int weight;

  final int students;

  const GradesSummaryCard({

    super.key,

    required this.title,

    required this.maxScore,

    required this.weight,

    required this.students,

  });

  @override
  Widget build(BuildContext context) {

    return PremiumCard(

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(

              fontSize: 22,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 18),

          Row(

            children: [

              const Icon(

                Icons.grade,

              ),

              const SizedBox(width: 8),

              Text(

                "Barème : ${maxScore.toStringAsFixed(0)}",

              ),

            ],

          ),

          const SizedBox(height: 10),

          Row(

            children: [

              const Icon(

                Icons.bar_chart,

              ),

              const SizedBox(width: 8),

              Text(

                "Coefficient : $weight",

              ),

            ],

          ),

          const SizedBox(height: 10),

          Row(

            children: [

              const Icon(

                Icons.groups,

              ),

              const SizedBox(width: 8),

              Text(

                "$students élève(s)",

              ),

            ],

          ),

        ],

      ),

    );

  }

}