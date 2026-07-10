import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/premium_card.dart';

import '../models/teacher_student_model.dart';

class TeacherStudentCard extends StatelessWidget {

  final TeacherStudentModel student;

  final VoidCallback? onAttendance;

  final VoidCallback? onGrades;

  final VoidCallback? onProfile;

  const TeacherStudentCard({

    super.key,

    required this.student,

    this.onAttendance,

    this.onGrades,

    this.onProfile,

  });

  @override
  Widget build(BuildContext context) {

    return PremiumCard(

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          //--------------------------------------------------
          // HEADER
          //--------------------------------------------------

          Row(

            children: [

              CircleAvatar(

                radius: 28,

                backgroundColor:
                    AppColors.primary.withOpacity(.12),

                backgroundImage:

                    student.avatar != null

                        ? NetworkImage(student.avatar!)

                        : null,

                child: student.avatar == null

                    ? const Icon(

                        Icons.person,

                        color: AppColors.primary,

                    )

                    : null,

              ),

              const SizedBox(width: 16),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      student.name,

                      style: const TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 17,

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      "Matricule : ${student.registration}",

                      style: TextStyle(

                        color:
                            Colors.grey.shade700,

                      ),

                    ),

                  ],

                ),

              ),

              _AttendanceChip(

                status:
                    student.attendance,

              ),

            ],

          ),

          const SizedBox(height: 20),

          //--------------------------------------------------
          // ACTIONS
          //--------------------------------------------------

          Row(

            children: [

              Expanded(

                child: FilledButton.icon(

                  onPressed:
                      onAttendance,

                  icon: const Icon(

                    Icons.fact_check,

                  ),

                  label: const Text(

                    "Appel",

                  ),

                ),

              ),

              const SizedBox(width: 10),

              Expanded(

                child: FilledButton.icon(

                  onPressed:
                      onGrades,

                  icon: const Icon(

                    Icons.edit_note,

                  ),

                  label: const Text(

                    "Notes",

                  ),

                ),

              ),

              const SizedBox(width: 10),

              Expanded(

                child: OutlinedButton.icon(

                  onPressed:
                      onProfile,

                  icon: const Icon(

                    Icons.visibility,

                  ),

                  label: const Text(

                    "Profil",

                  ),

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}

class _AttendanceChip extends StatelessWidget {

  final String? status;

  const _AttendanceChip({

    required this.status,

  });

  @override
  Widget build(BuildContext context) {

    Color color;

    IconData icon;

    String label;

    switch (status) {

      case "present":

        color = Colors.green;

        icon = Icons.check_circle;

        label = "Présent";

        break;

      case "late":

        color = Colors.orange;

        icon = Icons.access_time;

        label = "Retard";

        break;

      case "absent":

        color = Colors.red;

        icon = Icons.cancel;

        label = "Absent";

        break;

      default:

        color = Colors.grey;

        icon = Icons.help;

        label = "Non fait";

    }

    return Container(

      padding: const EdgeInsets.symmetric(

        horizontal: 10,

        vertical: 6,

      ),

      decoration: BoxDecoration(

        color: color.withOpacity(.12),

        borderRadius:

            BorderRadius.circular(30),

      ),

      child: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(

            icon,

            size: 16,

            color: color,

          ),

          const SizedBox(width: 6),

          Text(

            label,

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