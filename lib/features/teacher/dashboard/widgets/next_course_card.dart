import 'package:flutter/material.dart';

import '../models/teacher_dashboard_model.dart';

class NextCourseCard extends StatelessWidget {

  final TeacherNextCourseModel? course;

  final VoidCallback? onAttendance;

  const NextCourseCard({

    super.key,

    required this.course,

    this.onAttendance,

  });

  @override
  Widget build(BuildContext context) {

    if (course == null) {

      return Container(

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius: BorderRadius.circular(24),

          boxShadow: const [

            BoxShadow(

              color: Colors.black12,

              blurRadius: 12,

              offset: Offset(0, 4),

            ),

          ],

        ),

        child: const Column(

          children: [

            Icon(

              Icons.event_busy,

              size: 60,

              color: Colors.grey,

            ),

            SizedBox(height: 16),

            Text(

              "Aucun cours prévu aujourd'hui",

              style: TextStyle(

                fontSize: 18,

                fontWeight: FontWeight.bold,

              ),

            ),

          ],

        ),

      );

    }

    final Color statusColor =

        course!.status == "current"

            ? Colors.green

            : Colors.blue;

    final String statusText =

        course!.status == "current"

            ? "En cours"

            : "Prochain cours";

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: const [

          BoxShadow(

            color: Colors.black12,

            blurRadius: 12,

            offset: Offset(0, 4),

          ),

        ],

      ),

      child: Column(

        crossAxisAlignment:

            CrossAxisAlignment.start,

        children: [

          //------------------------------------------------
          // HEADER
          //------------------------------------------------

          Row(

            children: [

              Container(

                padding:

                    const EdgeInsets.all(12),

                decoration: BoxDecoration(

                  color:

                      statusColor.withOpacity(.12),

                  borderRadius:

                      BorderRadius.circular(14),

                ),

                child: Icon(

                  Icons.menu_book,

                  color: statusColor,

                ),

              ),

              const SizedBox(width: 14),

              Expanded(

                child: Column(

                  crossAxisAlignment:

                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      statusText,

                      style: TextStyle(

                        color: statusColor,

                        fontWeight:

                            FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      course!.title,

                      style: const TextStyle(

                        fontSize: 22,

                        fontWeight:

                            FontWeight.bold,

                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

          const SizedBox(height: 22),

          //------------------------------------------------
          // CLASSE
          //------------------------------------------------

          Row(

            children: [

              const Icon(

                Icons.groups,

                size: 20,

              ),

              const SizedBox(width: 10),

              Text(

                course!.classroom,

                style: const TextStyle(

                  fontSize: 16,

                ),

              ),

            ],

          ),

          const SizedBox(height: 12),

          //------------------------------------------------
          // HEURE
          //------------------------------------------------

          Row(

            children: [

              const Icon(

                Icons.schedule,

                size: 20,

              ),

              const SizedBox(width: 10),

              Text(

                "${course!.startTime} - ${course!.endTime}",

                style: const TextStyle(

                  fontSize: 16,

                ),

              ),

            ],

          ),

          //------------------------------------------------
          // SALLE
          //------------------------------------------------

          if (course!.room != null &&
              course!.room!.isNotEmpty) ...[

            const SizedBox(height: 12),

            Row(

              children: [

                const Icon(

                  Icons.meeting_room,

                  size: 20,

                ),

                const SizedBox(width: 10),

                Expanded(

                  child: Text(

                    course!.room!,

                    style: const TextStyle(

                      fontSize: 16,

                    ),

                  ),

                ),

              ],

            ),

          ],

          //------------------------------------------------
          // APPEL
          //------------------------------------------------

          if (course!.canTakeAttendance) ...[

            const SizedBox(height: 24),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton.icon(

                onPressed: onAttendance,

                icon: const Icon(

                  Icons.fact_check,

                ),

                label: const Text(

                  "Faire l'appel",

                ),

                style: ElevatedButton.styleFrom(

                  padding:

                      const EdgeInsets.symmetric(

                    vertical: 14,

                  ),

                  backgroundColor: Colors.green,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(

                    borderRadius:

                        BorderRadius.circular(14),

                  ),

                ),

              ),

            ),

          ],

        ],

      ),

    );

  }

}