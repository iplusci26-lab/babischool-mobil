import 'package:flutter/material.dart';

import '../models/teacher_schedule_course_model.dart';

class ScheduleCourseCard extends StatelessWidget {

  final TeacherScheduleCourseModel course;

  final VoidCallback? onTap;

  const ScheduleCourseCard({

    super.key,

    required this.course,

    this.onTap,

  });

  //----------------------------------------------------------

  Color get accentColor {

    if (course.isPrimary) {

      return Colors.green;

    }

    return Colors.blue;

  }

  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      elevation: 0,

      shape: RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(22),

      ),

      child: InkWell(

        borderRadius:
            BorderRadius.circular(22),

        onTap: onTap,

        child: Container(

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(22),

          ),

          child: Row(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              //--------------------------------------------------
              // HEURE
              //--------------------------------------------------

              Container(

                width: 72,

                padding: const EdgeInsets.symmetric(

                  vertical: 10,

                ),

                decoration: BoxDecoration(

                  color:
                      accentColor.withOpacity(.10),

                  borderRadius:
                      BorderRadius.circular(16),

                ),

                child: Column(

                  children: [

                    Text(

                      course.startTime,

                      style: TextStyle(

                        color: accentColor,

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 18,

                      ),

                    ),

                    const SizedBox(height: 6),

                    Text(

                      course.endTime,

                      style: TextStyle(

                        color: Colors.grey.shade700,

                        fontSize: 13,

                      ),

                    ),

                  ],

                ),

              ),

              const SizedBox(width: 18),

              //--------------------------------------------------
              // INFORMATIONS
              //--------------------------------------------------

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    //--------------------------------------------------
                    // MATIERE
                    //--------------------------------------------------

                    Text(

                      course.subjectName,

                      style: const TextStyle(

                        fontSize: 19,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 8),

                    //--------------------------------------------------
                    // CLASSE
                    //--------------------------------------------------

                    Row(

                      children: [

                        const Icon(

                          Icons.groups,

                          size: 18,

                          color: Colors.grey,

                        ),

                        const SizedBox(width: 8),

                        Expanded(

                          child: Text(

                            course.displayClassroom,

                            style: const TextStyle(

                              fontSize: 15,

                            ),

                          ),

                        ),

                      ],

                    ),

                    const SizedBox(height: 8),

                    //--------------------------------------------------
                    // SALLE
                    //--------------------------------------------------

                    if (course.hasRoom)

                      Row(

                        children: [

                          const Icon(

                            Icons.meeting_room,

                            size: 18,

                            color: Colors.grey,

                          ),

                          const SizedBox(width: 8),

                          Expanded(

                            child: Text(

                              course.room!,

                            ),

                          ),

                        ],

                      ),

                    if (course.hasRoom)

                      const SizedBox(height: 8),

                    //--------------------------------------------------
                    // BADGES
                    //--------------------------------------------------

                    Wrap(

                      spacing: 8,

                      runSpacing: 8,

                      children: [

                        _Badge(

                          text: course.isPrimary

                              ? "Primaire"

                              : "Secondaire",

                          color: accentColor,

                        ),

                        if (course.hasGroup)

                          const _Badge(

                            text: "Groupe",

                            color: Colors.orange,

                          ),

                      ],

                    ),

                  ],

                ),

              ),

              //--------------------------------------------------
              // FLECHE
              //--------------------------------------------------

              const Icon(

                Icons.chevron_right,

                color: Colors.grey,

              ),

            ],

          ),

        ),

      ),

    );

  }

}

//////////////////////////////////////////////////////////////
// BADGE
//////////////////////////////////////////////////////////////

class _Badge extends StatelessWidget {

  final String text;

  final Color color;

  const _Badge({

    required this.text,

    required this.color,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.symmetric(

        horizontal: 12,

        vertical: 6,

      ),

      decoration: BoxDecoration(

        color: color.withOpacity(.10),

        borderRadius:
            BorderRadius.circular(20),

      ),

      child: Text(

        text,

        style: TextStyle(

          color: color,

          fontWeight: FontWeight.w600,

          fontSize: 12,

        ),

      ),

    );

  }

}