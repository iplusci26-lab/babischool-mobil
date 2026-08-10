import 'package:flutter/material.dart';

import '../models/teacher_schedule_day_model.dart';
import 'schedule_course_card.dart';

class ScheduleDayCard extends StatelessWidget {
  final TeacherScheduleDayModel day;

  final Function(int index)? onCourseTap;

  const ScheduleDayCard({
    super.key,
    required this.day,
    this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 22,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(
                      0xff6214BE,
                    ).withOpacity(.10),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Color(0xff6214BE),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.label,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${day.totalCourses} cours",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                if (day.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Colors.green.withOpacity(.10),
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: Text(
                      day.timeRange,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            // ==================================================
            // LISTE DES COURS
            // ==================================================

            if (day.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 35,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 60,
                        color: Colors.grey.shade300,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Aucun cours",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Profitez de cette journée libre.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              const SizedBox(height: 22),

              ...List.generate(
                day.courses.length,
                (index) {
                  return ScheduleCourseCard(
                    course: day.courses[index],
                    onTap: () {
                      onCourseTap?.call(index);
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}