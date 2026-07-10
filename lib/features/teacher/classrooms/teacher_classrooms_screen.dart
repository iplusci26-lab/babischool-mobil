import 'package:flutter/material.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import 'models/teacher_course_model.dart';
import 'models/teacher_classrooms_response.dart';

import 'services/teacher_classrooms_service.dart';

import 'widgets/teacher_classroom_card.dart';
import 'widgets/teacher_classrooms_summary.dart';

import '../course/teacher_course_screen.dart';

import '../course/attendance/teacher_attendance_screen.dart';
import '../course/grades/teacher_grades_screen.dart';
import '../course/homework/teacher_homeworks_screen.dart';
import '../course/assessments/teacher_assessments_screen.dart';

class TeacherClassroomsScreen extends StatefulWidget {

  const TeacherClassroomsScreen({

    super.key,

  });

  @override
  State<TeacherClassroomsScreen> createState() =>
      _TeacherClassroomsScreenState();

}

class _TeacherClassroomsScreenState
    extends State<TeacherClassroomsScreen> {

  final TeacherClassroomsService _service =
      TeacherClassroomsService();

  TeacherClassroomsResponse? response;

  bool loading = true;

  String? error;

  //--------------------------------------------------------
  // LOAD
  //--------------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getClassrooms();

    } catch (e) {

      error = e.toString();

    }

    if (!mounted) return;

    setState(() {

      loading = false;

    });

  }

  //--------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

  }

  //--------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const LoadingView();

    }

    if (error != null) {

      return ErrorView(

        message: error!,

        onRetry: () {

          setState(() {

            loading = true;

          });

          loadData();

        },

      );

    }

    final classrooms = response!.classrooms;

    final todayCourses = classrooms

        .where(

          (e) => e.today,

        )

        .length;

    final students = classrooms.fold<int>(

      0,

      (total, item) => total + item.students,

    );

    return RefreshIndicator(

      onRefresh: loadData,

      child: ListView(

        physics:
            const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.all(20),

        children: [

          //--------------------------------------------------
          // SUMMARY
          //--------------------------------------------------

          TeacherClassroomsSummary(

            teacherName: response!.teacherName,

            classrooms: classrooms.length,

            students: students,

            todayCourses: todayCourses,

          ),

          const SizedBox(

            height: 24,

          ),

          //--------------------------------------------------
          // LISTE DES CLASSES
          //--------------------------------------------------

          ...classrooms.map(

            (TeacherCourseModel classroom) {

              return Padding(

                padding: const EdgeInsets.only(

                  bottom: 18,

                ),

                child: TeacherClassroomCard(

                  course: classroom,

                  //------------------------------------------------
                  // OUVRIR LA CLASSE
                  //------------------------------------------------

                  onTap: () {

                     Navigator.push(

                        context,

                        MaterialPageRoute(

                        builder: (_) => TeacherCourseScreen(

                            classroomId: classroom.classroomId,
                            scheduleId: classroom.scheduleId,
                            classroomName: classroom.name,

                        ),

                        ),

                    );


                  },

                  //------------------------------------------------
                  // APPEL
                  //------------------------------------------------

                  onAttendance: () {
                      print("classroomId = ${classroom.classroomId}");
                      print("scheduleId  = ${classroom.scheduleId}");
                    // TeacherAttendanceScreen
                    Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) => TeacherAttendanceScreen(

                            scheduleId: classroom.scheduleId,

                          ),

                        ),

                      );
                  },

                  //------------------------------------------------
                  // NOTES
                  //------------------------------------------------

                  onGrades: () {

                    // TeacherGradesScreen

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) => TeacherAssessmentsScreen(

                          scheduleId: classroom.scheduleId,

                        ),

                      ),

                    );


                  },

                  //------------------------------------------------
                  // DEVOIRS
                  //------------------------------------------------

                  onHomework: () {

                    // TeacherHomeworkScreen
                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) => TeacherHomeworksScreen(

                          scheduleId: classroom.scheduleId,

                        ),

                      ),

                    );

                  },

                ),

              );

            },

          ),

          const SizedBox(

            height: 30,

          ),

        ],

      ),

    );

  }

}