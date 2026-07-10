import 'package:flutter/material.dart';

import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';

import 'models/teacher_student_model.dart';
import 'models/teacher_students_response.dart';

import 'services/teacher_students_service.dart';

import 'widgets/teacher_student_card.dart';
import 'widgets/teacher_students_summary.dart';

import 'attendance/teacher_student_attendance_screen.dart';
import 'grades/teacher_student_grades_screen.dart';

class TeacherStudentsScreen extends StatefulWidget {

  final String classroomId;

  const TeacherStudentsScreen({

    super.key,

    required this.classroomId,

  });

  @override
  State<TeacherStudentsScreen> createState() =>
      _TeacherStudentsScreenState();

}

class _TeacherStudentsScreenState
    extends State<TeacherStudentsScreen> {

  final TeacherStudentsService _service =
      TeacherStudentsService();

  TeacherStudentsResponse? response;

  bool loading = true;

  String? error;

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getStudents(

        widget.classroomId,

      );

    } catch (e) {

      error = e.toString();

    }

    if (!mounted) return;

    setState(() {

      loading = false;

    });

  }

  @override
  void initState() {

    super.initState();

    loadData();

  }

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

    final students = response!.students;

    return RefreshIndicator(

      onRefresh: loadData,

      child: ListView(

        physics:
            const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.all(20),

        children: [

          TeacherStudentsSummary(

            classroom:
                response!.classroomName,

            students:
                students.length,

          ),

          const SizedBox(height: 24),

          ...students.map(

            (TeacherStudentModel student) {

              return Padding(

                padding: const EdgeInsets.only(

                  bottom: 18,

                ),

                child: TeacherStudentCard(

                  student: student,

                  onAttendance: () {

                    // TODO
                    Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>

                              TeacherStudentAttendanceScreen(

                            studentId: student.id,

                          ),

                        ),

                      );


                  },

                  onGrades: () {

                    // TODO
                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>

                            TeacherStudentGradesScreen(

                          studentId: student.id,

                        ),

                      ),

                    );

                  },

                  onProfile: () {

                    // TODO
                    // TeacherStudentProfile

                  },

                ),

              );

            },

          ),

          const SizedBox(height: 30),

        ],

      ),

    );

  }

}