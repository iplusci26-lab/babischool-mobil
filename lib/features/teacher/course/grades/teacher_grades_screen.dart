import 'package:flutter/material.dart';

import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';

import 'models/grade_student_model.dart';
import 'models/grade_response_model.dart';

import 'services/teacher_grades_service.dart';

import 'widgets/grade_student_tile.dart';
import 'widgets/grades_summary_card.dart';

class TeacherGradesScreen extends StatefulWidget {

  final String assessmentId;

  const TeacherGradesScreen({

    super.key,

    required this.assessmentId,

  });

  @override
  State<TeacherGradesScreen> createState() =>
      _TeacherGradesScreenState();

}

class _TeacherGradesScreenState
    extends State<TeacherGradesScreen> {

  final TeacherGradesService _service =
      TeacherGradesService();

  GradesResponseModel? response;

  bool loading = true;

  bool saving = false;

  String? error;

  //--------------------------------------------------------
  // LOAD
  //--------------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getGrades(

        widget.assessmentId,

      );

    } catch (e) {

      error = e.toString();

    }

    if (!mounted) return;

    setState(() {

      loading = false;

    });

  }

  //--------------------------------------------------------
  // SAVE
  //--------------------------------------------------------

  Future<void> saveGrades() async {

    if (response == null) return;

    setState(() {

      saving = true;

    });

    try {

      await _service.saveGrades(

        widget.assessmentId,

        response!.students

            .where(

              (e) => e.score != null,

            )

            .map(

              (e) => e.toJson(),

            )

            .toList(),

      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)

          .showSnackBar(

        const SnackBar(

          content: Text(

            "Notes enregistrées.",

          ),

        ),

      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)

          .showSnackBar(

        SnackBar(

          content: Text(

            e.toString(),

          ),

        ),

      );

    }

    if (!mounted) return;

    setState(() {

      saving = false;

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

    final grades = response!.students;

    return Scaffold(

      appBar: AppBar(

        title: Text(

          response!.title,

        ),

      ),

      floatingActionButton:

          FloatingActionButton.extended(

        onPressed:

            saving ? null : saveGrades,

        icon: saving

            ? const SizedBox(

                width: 18,

                height: 18,

                child:

                    CircularProgressIndicator(

                  strokeWidth: 2,

                ),

              )

            : const Icon(

                Icons.save,

              ),

        label: const Text(

          "Enregistrer",

        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          padding: const EdgeInsets.all(20),

          children: [

            //--------------------------------------------------
            // RESUME
            //--------------------------------------------------

            GradesSummaryCard(

              title: response!.title,

              maxScore: response!.maxScore,

              weight: response!.weight,

              students: grades.length,

            ),

            const SizedBox(

              height: 24,

            ),

            //--------------------------------------------------
            // NOTES
            //--------------------------------------------------

            ...grades.map(

              (GradeStudentModel student) {

                return GradeStudentTile(

                  student: student,

                  maxScore:

                      response!.maxScore,

                  onChanged: (

                    score,

                  ) {

                    setState(() {

                      student.score = score;

                    });

                  },

                );

              },

            ),

            const SizedBox(

              height: 100,

            ),

          ],

        ),

      ),

    );

  }

}