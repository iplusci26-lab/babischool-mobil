import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';

class TeacherClassroomsSummary extends StatelessWidget {

  final String teacherName;

  final int classrooms;

  final int students;

  final int todayCourses;

  const TeacherClassroomsSummary({

    super.key,

    required this.teacherName,

    required this.classrooms,

    required this.students,

    required this.todayCourses,

  });

  @override
  Widget build(BuildContext context) {

    return PremiumCard(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          //--------------------------------------------------
          // TITRE
          //--------------------------------------------------

          Row(

            children: [

              Container(

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(

                  color: AppColors.primary.withOpacity(.10),

                  borderRadius: BorderRadius.circular(14),

                ),

                child: const Icon(

                  Icons.groups,

                  color: AppColors.primary,

                  size: 28,

                ),

              ),

              const SizedBox(width: 16),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "Mes classes",

                      style: TextStyle(

                        fontWeight: FontWeight.bold,

                        fontSize: 20,

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      teacherName,

                      style: TextStyle(

                        color: Colors.grey.shade600,

                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

          const SizedBox(height: 24),

          //--------------------------------------------------
          // STATISTIQUES
          //--------------------------------------------------

          Row(

            children: [

              Expanded(

                child: _StatItem(

                  icon: Icons.meeting_room,

                  color: Colors.blue,

                  value: classrooms.toString(),

                  label: "Classes",

                ),

              ),

              Expanded(

                child: _StatItem(

                  icon: Icons.school,

                  color: Colors.green,

                  value: students.toString(),

                  label: "Élèves",

                ),

              ),

              Expanded(

                child: _StatItem(

                  icon: Icons.schedule,

                  color: Colors.orange,

                  value: todayCourses.toString(),

                  label: "Aujourd'hui",

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}

class _StatItem extends StatelessWidget {

  final IconData icon;

  final String value;

  final String label;

  final Color color;

  const _StatItem({

    required this.icon,

    required this.value,

    required this.label,

    required this.color,

  });

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        CircleAvatar(

          radius: 22,

          backgroundColor: color.withOpacity(.12),

          child: Icon(

            icon,

            color: color,

          ),

        ),

        const SizedBox(height: 10),

        Text(

          value,

          style: const TextStyle(

            fontWeight: FontWeight.bold,

            fontSize: 22,

          ),

        ),

        const SizedBox(height: 4),

        Text(

          label,

          style: TextStyle(

            color: Colors.grey.shade600,

            fontSize: 13,

          ),

        ),

      ],

    );

  }

}