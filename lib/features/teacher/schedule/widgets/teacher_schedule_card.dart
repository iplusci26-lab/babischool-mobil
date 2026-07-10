import 'package:flutter/material.dart';

import '../models/teacher_schedule_model.dart';

class TeacherScheduleCard extends StatelessWidget {

  final TeacherScheduleModel course;

  const TeacherScheduleCard({

    super.key,

    required this.course,

  });

    IconData _getSubjectIcon(String subject) {

    final value = subject.toLowerCase();

    if (value.contains("math")) {
        return Icons.calculate;
    }

    if (value.contains("français") ||
        value.contains("francais")) {
        return Icons.menu_book;
    }

    if (value.contains("anglais")) {
        return Icons.language;
    }

    if (value.contains("physique")) {
        return Icons.science;
    }

    if (value.contains("chimie")) {
        return Icons.biotech;
    }

    if (value.contains("svt") ||
        value.contains("science")) {
        return Icons.eco;
    }

    if (value.contains("informatique")) {
        return Icons.computer;
    }

    if (value.contains("histoire")) {
        return Icons.history_edu;
    }

    if (value.contains("géographie") ||
        value.contains("geographie")) {
        return Icons.public;
    }

    if (value.contains("philosophie")) {
        return Icons.psychology;
    }

    if (value.contains("éducation physique") ||
        value.contains("education physique") ||
        value.contains("eps")) {
        return Icons.sports_soccer;
    }

    if (value.contains("musique")) {
        return Icons.music_note;
    }

    if (value.contains("dessin") ||
        value.contains("art")) {
        return Icons.palette;
    }

    return Icons.menu_book_rounded;

    }

    Color _getSubjectColor(String subject) {

    final value = subject.toLowerCase();

    if (value.contains("math")) {
        return Colors.blue;
    }

    if (value.contains("français") ||
        value.contains("francais")) {
        return Colors.deepPurple;
    }

    if (value.contains("anglais")) {
        return Colors.green;
    }

    if (value.contains("physique")) {
        return Colors.orange;
    }

    if (value.contains("chimie")) {
        return Colors.red;
    }

    if (value.contains("svt") ||
        value.contains("science")) {
        return Colors.teal;
    }

    if (value.contains("informatique")) {
        return Colors.indigo;
    }

    if (value.contains("histoire")) {
        return Colors.brown;
    }

    if (value.contains("géographie") ||
        value.contains("geographie")) {
        return Colors.cyan;
    }

    if (value.contains("philosophie")) {
        return Colors.blueGrey;
    }

    if (value.contains("éducation physique") ||
        value.contains("education physique") ||
        value.contains("eps")) {
        return Colors.redAccent;
    }

    if (value.contains("musique")) {
        return Colors.pink;
    }

    if (value.contains("dessin") ||
        value.contains("art")) {
        return Colors.purple;
    }

    return const Color(0xff6214BE);

    }
  @override
  Widget build(BuildContext context) {

    final subjectColor = _getSubjectColor(course.subject,);

    return Container(


      margin: const EdgeInsets.only(

        bottom: 16,

      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border(

        left: BorderSide(

            color: subjectColor,

            width: 6,

        ),

        ),

        boxShadow: const [

        BoxShadow(

            color: Color(0x11000000),

            blurRadius: 10,

            offset: Offset(0, 3),

        ),

        ],

    ),

      child: Padding(

        padding: const EdgeInsets.all(18,),

        child: Row(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            //---------------------------------------------------
            // ICONE
            //---------------------------------------------------

            Container(

              width: 52,

              height: 52,

              decoration: BoxDecoration(

                color: subjectColor.withValues(alpha: .12,),

                borderRadius:

                    BorderRadius.circular(

                  14,

                ),

              ),

              child: Icon(

                _getSubjectIcon(
                    course.subject,
                ),

                color: subjectColor,

                size: 28,

                ),

            ),

            const SizedBox(

              width: 18,

            ),

            //---------------------------------------------------
            // INFORMATIONS
            //---------------------------------------------------

            Expanded(

              child: Column(

                crossAxisAlignment:

                    CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                        Expanded(

                        child: Text(

                            course.subject,

                            style: TextStyle(

                            fontSize: 18,

                            fontWeight: FontWeight.bold,

                            color: subjectColor,

                            ),

                        ),

                        ),

                        Container(

                        padding: const EdgeInsets.symmetric(

                            horizontal: 10,

                            vertical: 5,

                        ),

                        decoration: BoxDecoration(

                            color: subjectColor.withValues(

                            alpha: .10,

                            ),

                            borderRadius:

                                BorderRadius.circular(30),

                        ),

                        child: Text(

                            course.weekday,

                            style: TextStyle(

                            color: subjectColor,

                            fontWeight: FontWeight.bold,

                            fontSize: 11,

                            ),

                        ),

                        ),

                    ],

                    ),

                  const SizedBox(

                    height: 8,

                  ),

                  Row(

                    children: [

                      const Icon(

                        Icons.groups,

                        size: 18,

                        color: Colors.grey,

                      ),

                      const SizedBox(

                        width: 6,

                      ),

                      Text(

                        course.classroom,

                        style:

                            const TextStyle(

                          fontSize: 15,

                        ),

                      ),

                    ],

                  ),

                  const SizedBox(

                    height: 8,

                  ),

                  Row(

                    children: [

                      const Icon(

                        Icons.schedule,

                        size: 18,

                        color: Colors.grey,

                      ),

                      const SizedBox(

                        width: 6,

                      ),

                      Text(

                        "${course.startTime} - ${course.endTime}",

                        style:

                            const TextStyle(

                          fontWeight:

                              FontWeight.w600,

                        ),

                      ),

                    ],

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

}