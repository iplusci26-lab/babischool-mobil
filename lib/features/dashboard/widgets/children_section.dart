import 'package:flutter/material.dart';
import '../../../shared/models/student_model.dart';

class ChildrenSection
extends StatelessWidget {

  final List<StudentModel> students;
  final Function(StudentModel student,) onStudentTap;

  const ChildrenSection({
    super.key,
    required this.students,
    required this.onStudentTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(24),

        gradient: const LinearGradient(

          colors: [

            Color(0xff6214BE),

            Color(0xff7B3FF2),
          ],
        ),
      ),

      child: Column(

        children: students.map((student) {

          return GestureDetector(
            onTap: () {

                onStudentTap(
                student,
                );
            },
          child: Padding(

            padding:
            const EdgeInsets.only(
              bottom: 16,
            ),

            child: Row(

              children: [

                CircleAvatar(

                  radius: 24,

                  child: Text(
                    student.name[0],
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(

                        student.name,

                        style:
                        const TextStyle(

                          color: Colors.white,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Text(

                        student.classroom,

                        style:
                        const TextStyle(

                          color:
                          Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(

                  width: 55,

                  height: 55,

                  decoration:
                  BoxDecoration(

                    shape:
                    BoxShape.circle,

                    color:
                    Colors.white24,
                  ),

                  child: Center(

                    child: Text(

                      student.average
                          .toStringAsFixed(
                        1,
                      ),

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          );
        }).toList(),
      ),
    );
  }
}