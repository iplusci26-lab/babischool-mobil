import 'package:flutter/material.dart';

import '../models/attendance_student_model.dart';

class AttendanceStudentTile extends StatelessWidget {

  final AttendanceStudentModel student;

  final ValueChanged<String> onStatusChanged;

  const AttendanceStudentTile({

    super.key,

    required this.student,

    required this.onStatusChanged,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.only(bottom: 14),

      elevation: 0,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(18),

      ),

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(

              student.name,

              style: const TextStyle(

                fontWeight: FontWeight.bold,

                fontSize: 16,

              ),

            ),

            const SizedBox(height: 14),

            Row(

              children: [

                _StatusButton(

                  label: "Présent",

                  color: Colors.green,

                  icon: Icons.check_circle,

                  selected:
                      student.status == "present",

                  onTap: () {

                    onStatusChanged("present");

                  },

                ),

                const SizedBox(width: 8),

                _StatusButton(

                  label: "Absent",

                  color: Colors.red,

                  icon: Icons.cancel,

                  selected:
                      student.status == "absent",

                  onTap: () {

                    onStatusChanged("absent");

                  },

                ),

                const SizedBox(width: 8),

                _StatusButton(

                  label: "Retard",

                  color: Colors.orange,

                  icon: Icons.schedule,

                  selected:
                      student.status == "late",

                  onTap: () {

                    onStatusChanged("late");

                  },

                ),

              ],

            ),

          ],

        ),

      ),

    );

  }

}

class _StatusButton extends StatelessWidget {

  final String label;

  final Color color;

  final IconData icon;

  final bool selected;

  final VoidCallback onTap;

  const _StatusButton({

    required this.label,

    required this.color,

    required this.icon,

    required this.selected,

    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    return Expanded(

      child: InkWell(

        onTap: onTap,

        borderRadius: BorderRadius.circular(14),

        child: AnimatedContainer(

          duration: const Duration(milliseconds: 180),

          padding: const EdgeInsets.symmetric(

            vertical: 12,

          ),

          decoration: BoxDecoration(

            color: selected

                ? color.withOpacity(.15)

                : Colors.grey.shade100,

            borderRadius:

                BorderRadius.circular(14),

            border: Border.all(

              color: selected

                  ? color

                  : Colors.grey.shade300,

            ),

          ),

          child: Column(

            children: [

              Icon(

                icon,

                color: color,

              ),

              const SizedBox(height: 4),

              Text(

                label,

                style: TextStyle(

                  color: color,

                  fontWeight: FontWeight.w600,

                  fontSize: 12,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}