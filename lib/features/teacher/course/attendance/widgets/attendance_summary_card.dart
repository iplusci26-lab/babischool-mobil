import 'package:flutter/material.dart';

import '../../../../../shared/widgets/premium_card.dart';

class AttendanceSummaryCard extends StatelessWidget {

  final String classroom;

  final String date;

  final int students;

  const AttendanceSummaryCard({

    super.key,

    required this.classroom,

    required this.date,

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

            classroom,

            style: const TextStyle(

              fontSize: 22,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 8),

          Text(date),

          const SizedBox(height: 18),

          Row(

            children: [

              const Icon(

                Icons.groups,

              ),

              const SizedBox(width: 8),

              Text(

                "$students élèves",

              ),

            ],

          ),

        ],

      ),

    );

  }

}