import 'package:flutter/material.dart';

import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';

import 'models/assessment_model.dart';
import 'models/assessments_response_model.dart';

import 'services/teacher_assessments_service.dart';

import 'widgets/assessment_card.dart';
import 'widgets/assessment_summary_card.dart';
import 'create_assessment_screen.dart';
import '../grades/teacher_grades_screen.dart';

class TeacherAssessmentsScreen extends StatefulWidget {

  final String scheduleId;

  const TeacherAssessmentsScreen({

    super.key,

    required this.scheduleId,

  });

  @override
  State<TeacherAssessmentsScreen> createState() =>
      _TeacherAssessmentsScreenState();

}

class _TeacherAssessmentsScreenState
    extends State<TeacherAssessmentsScreen> {

  final TeacherAssessmentsService _service =
      TeacherAssessmentsService();

  TeacherAssessmentsResponse? response;

  bool loading = true;

  String? error;

  //-------------------------------------------------------
  // LOAD
  //-------------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getAssessments(
        widget.scheduleId,
      );

    } catch (e) {

      error = e.toString();

    }

    if (!mounted) return;

    setState(() {

      loading = false;

    });

  }

  //-------------------------------------------------------
  // DELETE
  //-------------------------------------------------------

  Future<void> deleteAssessment(
    String id,
  ) async {

    final confirm = await showDialog<bool>(

      context: context,

      builder: (_) {

        return AlertDialog(

          title: const Text(
            "Supprimer",
          ),

          content: const Text(
            "Voulez-vous vraiment supprimer cette évaluation ?",
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  false,
                );

              },

              child: const Text(
                "Annuler",
              ),

            ),

            FilledButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  true,
                );

              },

              child: const Text(
                "Supprimer",
              ),

            ),

          ],

        );

      },

    );

    if (confirm != true) return;

    await _service.deleteAssessment(id);

    await loadData();

  }

  //-------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

  }

  //-------------------------------------------------------

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

    final assessments =
        response!.assessments;

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Évaluations",
        ),

      ),

      floatingActionButton:
          FloatingActionButton.extended(

        onPressed: () async{
          // CreateAssessmentScreen
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
                builder: (_) => CreateAssessmentScreen(
                scheduleId: widget.scheduleId,
                ),
            ),
            );

            if (created == true) {
            loadData();
            }

        },

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          "Créer",
        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          padding: const EdgeInsets.all(20),

          children: [

            //--------------------------------------------------
            // SUMMARY
            //--------------------------------------------------

            AssessmentSummaryCard(

              classroom:
                  response!.classroom,

              subject:
                  response!.subject,

              assessments:
                  assessments.length,

            ),

            const SizedBox(
              height: 24,
            ),

            //--------------------------------------------------
            // LISTE
            //--------------------------------------------------

            ...assessments.map(

              (TeacherAssessmentModel assessment) {

                return Padding(

                  padding:
                      const EdgeInsets.only(

                    bottom: 18,

                  ),

                  child: AssessmentCard(

                    assessment: assessment,

                    //------------------------------------------------
                    // NOTES
                    //------------------------------------------------

                    onGrades: () async{

                     
                      // TeacherAssessmentGradesScreen
                       await Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) => TeacherGradesScreen(

                            assessmentId: assessment.id,

                          ),

                        ),

                      );

                    },

                    //------------------------------------------------
                    // MODIFIER
                    //------------------------------------------------

                    onEdit: () async {

                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CreateAssessmentScreen(
                            scheduleId: widget.scheduleId,
                            assessment: assessment,
                            ),
                        ),
                        );

                        if (updated == true) {
                        loadData();
                        }

                    },

                    //------------------------------------------------
                    // SUPPRIMER
                    //------------------------------------------------

                    onDelete: () {

                      deleteAssessment(

                        assessment.id,

                      );

                    },

                  ),

                );

              },

            ),

            const SizedBox(
              height: 90,
            ),

          ],

        ),

      ),

    );

  }

}