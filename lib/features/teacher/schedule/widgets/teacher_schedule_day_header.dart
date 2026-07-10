import 'package:flutter/material.dart';

class TeacherScheduleDayHeader extends StatelessWidget {

  final String day;

  const TeacherScheduleDayHeader({

    super.key,

    required this.day,

  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(

        top: 22,

        bottom: 12,

      ),

      child: Row(

        children: [

          const Icon(

            Icons.calendar_today,

            color: Color(0xff6214BE),

            size: 18,

          ),

          const SizedBox(width: 8),

          Text(

            day.toUpperCase(),

            style: const TextStyle(

              fontSize: 18,

              fontWeight: FontWeight.bold,

              color: Color(0xff6214BE),

            ),

          ),

        ],

      ),

    );

  }

}