import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../core/utils/subject_color.dart';
import '../models/schedule_model.dart';

class ScheduleCard extends StatelessWidget {

  final ScheduleModel course;

  const ScheduleCard({

    super.key,

    required this.course,

  });

  @override
  Widget build(BuildContext context) {

    final Color color = subjectColor(course.color);

    return Row(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        //--------------------------------------------------
        // TIMELINE
        //--------------------------------------------------

        SizedBox(

          width: 72,

          child: Column(

            children: [

              Text(

                course.startTime,

                style: const TextStyle(

                  fontWeight: FontWeight.bold,

                ),

              ),

              const SizedBox(height: 6),

              Container(

                width: 14,

                height: 14,

                decoration: BoxDecoration(

                  color: color,

                  shape: BoxShape.circle,

                ),

              ),

              Container(

                width: 2,

                height: 120,

                color: Colors.grey.shade300,

              ),

            ],

          ),

        ),

        //--------------------------------------------------
        // CARD
        //--------------------------------------------------

        Expanded(
            child: Padding(
            padding: const EdgeInsets.only(

              bottom: 18,

            ),
          child: PremiumCard(

           

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                //------------------------------------------------
                // MATIERE
                //------------------------------------------------

                Row(

                  children: [

                    CircleAvatar(

                      radius: 20,

                      backgroundColor:

                          color.withValues(alpha: .15),

                      child: Icon(

                        Icons.menu_book,

                        color: color,

                      ),

                    ),

                    const SizedBox(width: 12),

                    Expanded(

                      child: Text(

                        course.subject,

                        style: const TextStyle(

                          fontWeight:

                              FontWeight.bold,

                          fontSize: 17,

                        ),

                      ),

                    ),

                  ],

                ),

                const SizedBox(height: 18),

                //------------------------------------------------
                // PROF
                //------------------------------------------------

                Row(

                  children: [

                    const Icon(

                      Icons.person,

                      color: AppColors.primary,

                    ),

                    const SizedBox(width: 8),

                    Expanded(

                      child: Text(

                        course.teacher,

                      ),

                    ),

                  ],

                ),

                const SizedBox(height: 12),

                //------------------------------------------------
                // HORAIRE
                //------------------------------------------------

                Row(

                  children: [

                    const Icon(

                      Icons.schedule,

                      color: AppColors.primary,

                    ),

                    const SizedBox(width: 8),

                    Text(

                      "${course.startTime} - ${course.endTime}",

                    ),

                    const Spacer(),

                    Text(

                      course.duration,

                    ),

                  ],

                ),

                //------------------------------------------------
                // ETAT
                //------------------------------------------------

                if (course.isCurrent) ...[

                  const SizedBox(height: 18),

                  _StatusBanner(

                    color: Colors.green,

                    icon: Icons.play_circle_fill,

                    text: "Cours en cours",

                  ),

                ]

                else if (course.isNext) ...[

                  const SizedBox(height: 18),

                  _StatusBanner(

                    color: Colors.orange,

                    icon: Icons.schedule,

                    text: "Prochain cours",

                  ),

                ],

              ],

            ),

          ),
        ),
        ),

      ],

    );

  }

  

}

class _StatusBanner extends StatelessWidget {

  final Color color;

  final IconData icon;

  final String text;

  const _StatusBanner({

    required this.color,

    required this.icon,

    required this.text,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: color.withValues(alpha: .10),

        borderRadius:

            BorderRadius.circular(14),

      ),

      child: Row(

        children: [

          Icon(

            icon,

            color: color,

          ),

          const SizedBox(width: 10),

          Text(

            text,

            style: TextStyle(

              color: color,

              fontWeight: FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }

}