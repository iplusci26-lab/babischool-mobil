import 'package:flutter/material.dart';
import '../../../shared/models/student_model.dart';

class ChildrenSection extends StatelessWidget {
  final List<StudentModel> students;
  final Function(StudentModel student) onStudentTap;

  const ChildrenSection({
    super.key,
    required this.students,
    required this.onStudentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: students.map((student) {
        final double average = student.average;
        //--------------------------------------------------
        // Couleur des absences
        //--------------------------------------------------

        final int absenceHours = student.absenceHours;

        Color indicatorColor;

        String indicatorLabel;

        IconData indicatorIcon;

        if (absenceHours == 0) {

          indicatorColor = Colors.green;

          indicatorLabel = "Excellent";

          indicatorIcon = Icons.verified_rounded;

        }
        else if (absenceHours <= 5) {

          indicatorColor = Colors.orange;

          indicatorLabel = "À surveiller";

          indicatorIcon = Icons.visibility_rounded;

        }
        else if (absenceHours <= 10) {

          indicatorColor = Colors.deepOrange;

          indicatorLabel = "Attention";

          indicatorIcon = Icons.warning_amber_rounded;

        }
        else {

          indicatorColor = Colors.red;

          indicatorLabel = "Critique";

          indicatorIcon = Icons.error_outline_rounded;

        }

         //--------------------------------------------------
        // Couleur de la moyenne
        //--------------------------------------------------
        Color averageColor;

        if (average < 10) {
          averageColor = Colors.red;
        } else if (average <= 12) {
          averageColor = Colors.orange;
        } else {
          averageColor = Colors.green;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Material(
            color: Colors.white,
            elevation: 2,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => onStudentTap(student),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border(
                    left: BorderSide(
                      color: averageColor,
                      width: 5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      //--------------------------------------------------
                      // Avatar
                      //--------------------------------------------------

                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            const Color(0xff6214BE).withOpacity(.12),
                        child: Text(
                          student.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xff6214BE),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      //--------------------------------------------------
                      // Informations
                      //--------------------------------------------------

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1F2937),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              student.classroom,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 8),
                              //--------------------------------------------------
                              // Moyenne
                              //--------------------------------------------------
                              Row(
                                children: [

                                  const Icon(
                                    Icons.school_rounded,
                                    size: 16,
                                    color: Color(0xff6214BE),
                                  ),

                                  const SizedBox(width: 5),

                                  Text(
                                    "Moyenne : ${average.toStringAsFixed(1)}/20",
                                    style: const TextStyle(
                                      color: Color(0xff6214BE),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                ],
                              ),


                            const SizedBox(height: 10),

                            const Row(
                              children: [
                                Text(
                                  "Voir le détail",
                                  style: TextStyle(
                                    color: Color(0xff6214BE),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                SizedBox(width: 4),

                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: Color(0xff6214BE),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      
                      
                      Column(

                        children: [

                          Container(

                            width: 76,

                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),

                            decoration: BoxDecoration(

                              color: indicatorColor,

                              borderRadius:
                                  BorderRadius.circular(18),

                            ),

                            child: Column(

                              children: [

                                Text(

                                  "${absenceHours} h",

                                  style: const TextStyle(

                                    color: Colors.white,

                                    fontWeight: FontWeight.bold,

                                    fontSize: 20,

                                  ),

                                ),

                                const SizedBox(height: 4),

                                const Text(

                                  "Absences",

                                  textAlign: TextAlign.center,

                                  style: TextStyle(

                                    color: Colors.white,

                                    fontSize: 11,

                                    fontWeight: FontWeight.w600,

                                  ),

                                ),

                                const SizedBox(height: 8),

                                Icon(

                                  indicatorIcon,

                                  color: Colors.white,

                                  size: 18,

                                ),

                                const SizedBox(height: 3),

                                Text(

                                  indicatorLabel,

                                  textAlign: TextAlign.center,

                                  style: const TextStyle(

                                    color: Colors.white,

                                    fontSize: 10,

                                    fontWeight: FontWeight.w600,

                                  ),

                                ),

                              ],

                            ),

                          ),

                        ],

                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}