import 'package:flutter/material.dart';

import '../models/teacher_dashboard_model.dart';


class TodayScheduleCard extends StatelessWidget {

  final List<TeacherScheduleModel> schedules;

  final Function(
    TeacherScheduleModel schedule,
  )? onCourseTap;


  const TodayScheduleCard({

    super.key,

    required this.schedules,

    this.onCourseTap,

  });


  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: const [

          BoxShadow(

            color:
                Colors.black12,

            blurRadius:
                12,

            offset:
                Offset(0, 4),

          ),

        ],

      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          //--------------------------------------------------
          // HEADER
          //--------------------------------------------------

          Row(

            children: const [

              Icon(

                Icons.calendar_today,

                color:
                    Color(0xff6214BE),

              ),

              SizedBox(
                width: 10,
              ),

              Text(

                "Planning du jour",

                style: TextStyle(

                  fontSize:
                      20,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),

            ],

          ),


          const SizedBox(
            height: 22,
          ),


          //--------------------------------------------------
          // VIDE
          //--------------------------------------------------

          if (schedules.isEmpty)

            const Padding(

              padding:
                  EdgeInsets.symmetric(
                vertical: 40,
              ),

              child: Center(

                child: Text(

                  "Aucun cours aujourd'hui",

                  style: TextStyle(

                    fontSize:
                        16,

                  ),

                ),

              ),

            )


          //--------------------------------------------------
          // LISTE
          //--------------------------------------------------

          else

            ...List.generate(

              schedules.length,

              (index) {

                final schedule =
                    schedules[index];


                return _ScheduleTile(

                  schedule:
                      schedule,

                  isLast:
                      index ==
                      schedules.length - 1,

                  onTap: () {

                    onCourseTap?.call(
                      schedule,
                    );

                  },

                );

              },

            ),

        ],

      ),

    );

  }

}


//============================================================
// TILE
//============================================================

class _ScheduleTile
    extends StatelessWidget {

  final TeacherScheduleModel schedule;

  final bool isLast;

  final VoidCallback? onTap;


  const _ScheduleTile({

    required this.schedule,

    required this.isLast,

    this.onTap,

  });


  @override
  Widget build(BuildContext context) {

    return InkWell(

      borderRadius:
          BorderRadius.circular(18),

      onTap:
          onTap,

      child: Padding(

        padding:
            const EdgeInsets.symmetric(
          vertical: 12,
        ),

        child: Row(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            //--------------------------------------------------
            // TIMELINE
            //--------------------------------------------------

            Column(

              children: [

                Container(

                  width:
                      14,

                  height:
                      14,

                  decoration:
                      const BoxDecoration(

                    color:
                        Color(0xff6214BE),

                    shape:
                        BoxShape.circle,

                  ),

                ),

                if (!isLast)

                  Container(

                    width:
                        2,

                    height:
                        60,

                    color:
                        Colors.grey.shade300,

                  ),

              ],

            ),


            const SizedBox(
              width: 18,
            ),


            //--------------------------------------------------
            // CONTENU
            //--------------------------------------------------

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    "${schedule.startTime} - ${schedule.endTime}",

                    style: TextStyle(

                      color:
                          Colors.grey.shade600,

                    ),

                  ),


                  const SizedBox(
                    height: 6,
                  ),


                  Text(

                    schedule.title,

                    style: const TextStyle(

                      fontSize:
                          18,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),


                  const SizedBox(
                    height: 6,
                  ),


                  Text(

                    schedule.classroom,

                    style: TextStyle(

                      color:
                          Colors.grey.shade700,

                    ),

                  ),


                  if (schedule.room != null &&
                      schedule.room!.isNotEmpty)

                    Padding(

                      padding:
                          const EdgeInsets.only(
                        top: 6,
                      ),

                      child: Row(

                        children: [

                          const Icon(

                            Icons.meeting_room,

                            size:
                                16,

                            color:
                                Colors.grey,

                          ),

                          const SizedBox(
                            width: 6,
                          ),

                          Text(

                            schedule.room!,

                            style: TextStyle(

                              color:
                                  Colors.grey.shade600,

                            ),

                          ),

                        ],

                      ),

                    ),

                ],

              ),

            ),


            //--------------------------------------------------
            // CHEVRON
            //--------------------------------------------------

            const Icon(

              Icons.chevron_right,

              color:
                  Colors.grey,

            ),

          ],

        ),

      ),

    );

  }

}