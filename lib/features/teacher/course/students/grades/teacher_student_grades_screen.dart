import 'package:flutter/material.dart';

import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/loading_view.dart';

import 'models/student_grade_model.dart';
import 'models/student_grades_response.dart';

import 'services/teacher_student_grades_service.dart';

class TeacherStudentGradesScreen
    extends StatefulWidget {

  final String studentId;

  const TeacherStudentGradesScreen({

    super.key,

    required this.studentId,

  });

  @override
  State<TeacherStudentGradesScreen>
      createState() =>
          _TeacherStudentGradesScreenState();

}

class _TeacherStudentGradesScreenState
    extends State<TeacherStudentGradesScreen> {

  final TeacherStudentGradesService _service =
      TeacherStudentGradesService();

  StudentGradesResponse? response;

  bool loading = true;

  String? error;

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getGrades(

        widget.studentId,

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

      return const Scaffold(

        body: LoadingView(),

      );

    }

    if (error != null) {

      return Scaffold(

        body: ErrorView(

          message: error!,

          onRetry: () {

            setState(() {

              loading = true;

            });

            loadData();

          },

        ),

      );

    }

    return Scaffold(

      appBar: AppBar(

        title: const Text(

          "Historique des notes",

        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView.builder(

          padding: const EdgeInsets.all(20),

          itemCount: response!.grades.length,

          itemBuilder: (_, index) {

            final grade = response!.grades[index];

            return Card(

              margin: const EdgeInsets.only(

                bottom: 14,

              ),

              child: ListTile(

                leading: const CircleAvatar(

                  backgroundColor:

                      Color(0xff6214BE),

                  child: Icon(

                    Icons.school,

                    color: Colors.white,

                  ),

                ),

                title: Text(

                  grade.assessment,

                ),

                subtitle: Text(

                  "${grade.score} / ${grade.maxScore}",

                ),

              ),

            );

          },

        ),

      ),

    );

  }

}