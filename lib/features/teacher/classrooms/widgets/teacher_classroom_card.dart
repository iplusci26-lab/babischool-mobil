import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/subject_color.dart';
import '../../../../shared/widgets/premium_card.dart';

import '../models/teacher_course_model.dart';

class TeacherClassroomCard extends StatelessWidget {

  final TeacherCourseModel course;

  final VoidCallback? onTap;

  final VoidCallback? onAttendance;

  final VoidCallback? onGrades;

  final VoidCallback? onHomework;

  const TeacherClassroomCard({

    super.key,

    required this.course,

    this.onTap,

    this.onAttendance,

    this.onGrades,

    this.onHomework,

  });

  @override
  Widget build(BuildContext context) {

    final color = subjectColor(course.color);

    return PremiumCard(

      child: InkWell(

        borderRadius: BorderRadius.circular(22),

        onTap: onTap,

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

                  radius: 24,

                  backgroundColor:
                      color.withOpacity(.12),

                  child: Icon(

                    Icons.menu_book,

                    color: color,

                  ),

                ),

                const SizedBox(width: 14),

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(

                        course.name,

                        style: const TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                      const SizedBox(height: 4),

                      Text(

                        course.subject,

                        style: TextStyle(

                          color:
                              Colors.grey.shade700,

                        ),

                      ),

                    ],

                  ),

                ),

                if (course.today)

                  Container(

                    padding:
                        const EdgeInsets.symmetric(

                      horizontal: 10,

                      vertical: 6,

                    ),

                    decoration: BoxDecoration(

                      color: Colors.green
                          .withOpacity(.12),

                      borderRadius:
                          BorderRadius.circular(30),

                    ),

                    child: const Text(

                      "Aujourd'hui",

                      style: TextStyle(

                        color: Colors.green,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),

                  ),

              ],

            ),

            const SizedBox(height: 20),

            //--------------------------------------------------
            // INFOS
            //--------------------------------------------------

            Row(

              children: [

                const Icon(

                  Icons.groups,

                  color: AppColors.primary,

                ),

                const SizedBox(width: 8),

                Text(

                  "${course.students} élèves",

                ),

                const Spacer(),

                const Icon(

                  Icons.schedule,

                  color: AppColors.primary,

                ),

                const SizedBox(width: 8),

                Text(

                  course.nextCourse,

                ),

              ],

            ),

            const SizedBox(height: 22),

            //--------------------------------------------------
            // ACTIONS
            //--------------------------------------------------

            Row(

              children: [

                Expanded(

                  child: FilledButton.icon(

                    onPressed: onAttendance,

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

                    onPressed: onGrades,

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

                  child: FilledButton.icon(

                    onPressed: onHomework,

                    icon: const Icon(

                      Icons.assignment,

                    ),

                    label: const Text(

                      "Devoir",

                    ),

                  ),

                ),

              ],

            ),

          ],

        ),

      ),

    );

  }

}