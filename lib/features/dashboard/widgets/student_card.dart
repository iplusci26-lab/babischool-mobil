import 'package:flutter/material.dart';

import '../../../shared/models/student_model.dart';

class StudentCard extends StatelessWidget {

  final StudentModel student;

  const StudentCard({

    super.key,

    required this.student,
  });

  Color _attendanceColor() {

    switch (
      student.attendanceToday
    ) {

      case "present":
        return Colors.green;

      case "absent":
        return Colors.red;

      case "late":
        return Colors.orange;

      case "excused":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  String _attendanceLabel() {

    switch (
      student.attendanceToday
    ) {

      case "present":
        return "Présent";

      case "absent":
        return "Absent";

      case "late":
        return "Retard";

      case "excused":
        return "Justifié";

      default:
        return "Non renseigné";
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
      const EdgeInsets.all(
        16,
      ),

      decoration:
      BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          20,
        ),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(
              0.05,
            ),

            blurRadius: 8,

            offset:
            const Offset(
              0,
              2,
            ),
          )
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// NOM

          Text(

            student.name,

            style:
            const TextStyle(

              fontSize: 18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(

            student.classroom,

            style:
            const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          /// PRESENCE

          Container(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration:
            BoxDecoration(

              color:
              _attendanceColor()
              .withOpacity(
                0.15,
              ),

              borderRadius:
              BorderRadius.circular(
                30,
              ),
            ),

            child: Text(

              _attendanceLabel(),

              style: TextStyle(

                color:
                _attendanceColor(),

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              _Item(

                title:
                "Moyenne",

                value:
                student.average
                .toStringAsFixed(
                  2,
                ),
              ),

              _Item(

                title:
                "Solde",

                value:
                "${student.balance.toStringAsFixed(0)} FCFA",
              ),

              _Item(

                title:
                "Messages",

                value:
                student.unreadMessages
                .toString(),
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

  final String value;

  const _Item({

    required this.title,

    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Column(

      children: [

        Text(

          value,

          style:
          const TextStyle(

            fontWeight:
            FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        Text(

          title,

          style:
          const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}