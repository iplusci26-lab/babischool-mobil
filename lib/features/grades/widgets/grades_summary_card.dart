import 'package:flutter/material.dart';

import '../models/report_card_model.dart';

class GradesSummaryCard
    extends StatelessWidget {

  final ReportCardModel report;

  const GradesSummaryCard({

    super.key,

    required this.report,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration:
          BoxDecoration(

        color:
            const Color(
          0xff6214BE,
        ),

        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,

        children: [

          Column(

            children: [

              const Text(

                "Moyenne",

                style: TextStyle(

                  color:
                      Colors.white70,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(

                report.average
                    .toStringAsFixed(2),

                style:
                    const TextStyle(

                  color:
                      Colors.white,

                  fontSize: 30,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          Container(

            width: 1,

            height: 70,

            color:
                Colors.white24,
          ),

          Column(

            children: [

              const Text(

                "Classement",

                style: TextStyle(

                  color:
                      Colors.white70,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(

                report.rank == null

                    ? "--"

                    : "${report.rank}/${report.studentsCount}",

                style:
                    const TextStyle(

                  color:
                      Colors.white,

                  fontSize: 26,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}