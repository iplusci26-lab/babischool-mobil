import 'package:flutter/material.dart';

import '../models/attendance_model.dart';

class AttendanceSummaryCard
    extends StatelessWidget {

  final AttendanceSummary summary;

  const AttendanceSummaryCard({

    super.key,

    required this.summary,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      padding:
      const EdgeInsets.all(
        20,
      ),

      decoration:
      BoxDecoration(

        color: const Color(
          0xff6214BE,
        ),

        borderRadius:
        BorderRadius.circular(
          24,
        ),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(

            "Résumé de présence",

            style: TextStyle(

              color: Colors.white70,

              fontSize: 14,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(

            children: [

              Expanded(
                child: _Item(
                  "Présent",
                  summary.present,
                  Colors.green,
                ),
              ),

              Expanded(
                child: _Item(
                  "Absent",
                  summary.absent,
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          Row(

            children: [

              Expanded(
                child: _Item(
                  "Retard",
                  summary.late,
                  Colors.orange,
                ),
              ),

              Expanded(
                child: _Item(
                  "Justifié",
                  summary.excused,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Item
    extends StatelessWidget {

  final String title;

  final int value;

  final Color color;

  const _Item(

    this.title,

    this.value,

    this.color,
  );

  @override
  Widget build(
    BuildContext context,
  ) {

    return Column(

      children: [

        Container(

          width: 46,

          height: 46,

          decoration:
          BoxDecoration(

            color:
            color.withValues(
              alpha: 0.20,
            ),

            shape:
            BoxShape.circle,
          ),

          child: Icon(

            Icons.check,

            color: color,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        Text(

          value.toString(),

          style:
          const TextStyle(

            color: Colors.white,

            fontSize: 22,

            fontWeight:
            FontWeight.bold,
          ),
        ),

        Text(

          title,

          style:
          const TextStyle(

            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}