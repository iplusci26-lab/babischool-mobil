import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import '../models/schedule_model.dart';

class ScheduleSummaryCard extends StatelessWidget {

  final String today;

  final List<ScheduleModel> courses;

  const ScheduleSummaryCard({

    super.key,

    required this.today,

    required this.courses,

  });

  @override
  Widget build(BuildContext context) {

    final total = courses.length;

    ScheduleModel? current;

    ScheduleModel? next;

    if (courses.isNotEmpty) {

      for (final course in courses) {

        if (course.isCurrent) {

          current = course;

        }

        if (course.isNext) {

          next ??= course;

        }

      }

    }

    final firstCourse =
        courses.isEmpty ? null : courses.first;

    final lastCourse =
        courses.isEmpty ? null : courses.last;

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(24),

        gradient: const LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [

            AppColors.primary,

            Color(0xff7C3AED),

          ],

        ),

      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          //------------------------------------------------
          // TITRE
          //------------------------------------------------

          Row(

            children: [

              const Icon(

                Icons.calendar_month,

                color: Colors.white,

                size: 28,

              ),

              const SizedBox(width: 10),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "Emploi du temps",

                      style: TextStyle(

                        color: Colors.white,

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 21,

                      ),

                    ),

                    Text(

                      today,

                      style: const TextStyle(

                        color: Colors.white70,

                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

          const SizedBox(height: 24),

          //------------------------------------------------
          // STATS
          //------------------------------------------------

          Row(

            children: [

              Expanded(

                child: _InfoTile(

                  icon: Icons.menu_book,

                  value: "$total",

                  label: "Cours",

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                child: _InfoTile(

                  icon: Icons.login,

                  value:

                      firstCourse?.startTime ?? "--",

                  label: "Début",

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                child: _InfoTile(

                  icon: Icons.logout,

                  value:

                      lastCourse?.endTime ?? "--",

                  label: "Fin",

                ),

              ),

            ],

          ),

          //------------------------------------------------

          if (current != null) ...[

            const SizedBox(height: 24),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:

                    BorderRadius.circular(18),

              ),

              child: Row(

                children: [

                  const Icon(

                    Icons.play_circle_fill,

                    color: Colors.green,

                  ),

                  const SizedBox(width: 10),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Cours en cours",

                          style: TextStyle(

                            fontWeight:

                                FontWeight.bold,

                          ),

                        ),

                        Text(

                          current.subject,

                        ),

                      ],

                    ),

                  ),

                  Text(

                    current.startTime,

                    style: const TextStyle(

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                ],

              ),

            ),

          ]

          else if (next != null) ...[

            const SizedBox(height: 24),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:

                    BorderRadius.circular(18),

              ),

              child: Row(

                children: [

                  const Icon(

                    Icons.schedule,

                    color: Colors.orange,

                  ),

                  const SizedBox(width: 10),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Prochain cours",

                          style: TextStyle(

                            fontWeight:

                                FontWeight.bold,

                          ),

                        ),

                        Text(

                          next.subject,

                        ),

                      ],

                    ),

                  ),

                  Text(

                    next.startTime,

                    style: const TextStyle(

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                ],

              ),

            ),

          ]

          else ...[

            const SizedBox(height: 24),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:

                    BorderRadius.circular(18),

              ),

              child: const Row(

                children: [

                  Icon(

                    Icons.celebration,

                    color: Colors.green,

                  ),

                  SizedBox(width: 10),

                  Expanded(

                    child: Text(

                      "Aucun cours pour cette journée.",

                    ),

                  ),

                ],

              ),

            ),

          ],

        ],

      ),

    );

  }

}

class _InfoTile extends StatelessWidget {

  final IconData icon;

  final String value;

  final String label;

  const _InfoTile({

    required this.icon,

    required this.value,

    required this.label,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

      ),

      child: Column(

        children: [

          Icon(

            icon,

            color: AppColors.primary,

          ),

          const SizedBox(height: 10),

          Text(

            value,

            style: const TextStyle(

              fontWeight: FontWeight.bold,

              fontSize: 20,

            ),

          ),

          const SizedBox(height: 4),

          Text(

            label,

            style: const TextStyle(

              fontSize: 12,

            ),

          ),

        ],

      ),

    );

  }

}