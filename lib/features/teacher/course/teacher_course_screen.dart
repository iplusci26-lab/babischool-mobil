import 'package:flutter/material.dart';

import '../../../shared/widgets/action_tile.dart';
import '../../../shared/widgets/dashboard_header.dart';

import 'attendance/teacher_attendance_screen.dart';
import 'grades/teacher_grades_screen.dart';
import 'homework/teacher_homeworks_screen.dart';
import 'students/teacher_students_screen.dart';
import 'assessments/teacher_assessments_screen.dart';

class TeacherCourseScreen extends StatelessWidget {

  final String classroomId;

  final String scheduleId;

  final String classroomName;

  const TeacherCourseScreen({

    super.key,

    required this.classroomId,

    required this.classroomName,

    required this.scheduleId,

  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(

          classroomName,

        ),

      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          //------------------------------------------------------
          // HEADER
          //------------------------------------------------------

          DashboardHeader(

            username: classroomName,

            subtitle: "Choisissez une action",

          ),

          const SizedBox(height: 24),

          //------------------------------------------------------
          // APPEL
          //------------------------------------------------------

          ActionTile(

            icon: Icons.fact_check,

            title: "Faire l'appel",

            subtitle:
                "Enregistrer la présence des élèves",

            color: Colors.green,

            onTap: () {
              // TeacherAttendanceScreen
               Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) => TeacherAttendanceScreen(

                    scheduleId: scheduleId,

                  ),

                ),

              );

            },

          ),

          //------------------------------------------------------
          // NOTES
          //------------------------------------------------------

          ActionTile(

            icon: Icons.edit_note,

            title: "Saisir les notes",

            subtitle:
                "Ajouter les notes des élèves",

            color: Colors.orange,

            onTap: () {

              // TeacherGradesScreen
              Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => TeacherAssessmentsScreen(

                      scheduleId: scheduleId,

                    ),

                  ),

                );
            },

          ),

          //------------------------------------------------------
          // DEVOIRS
          //------------------------------------------------------

          ActionTile(

            icon: Icons.assignment,

            title: "Gérer les devoirs",

            subtitle:
                "Créer ou modifier les devoirs",

            color: Colors.deepPurple,

            onTap: () {

              // TeacherHomeworkScreen
              Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => TeacherHomeworksScreen(

                      scheduleId: scheduleId,

                    ),

                  ),

                );

            },

          ),

          //------------------------------------------------------
          // ELEVES
          //------------------------------------------------------

          ActionTile(

            icon: Icons.groups,

            title: "Liste des élèves",

            subtitle:
                "Consulter les informations des élèves",

            color: Colors.blue,

            onTap: () {
              // TeacherStudentsScreen
               Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => TeacherStudentsScreen(

                      classroomId: classroomId,

                      

                    ),

                  ),

                );


            },

          ),

        ],

      ),

    );

  }

}