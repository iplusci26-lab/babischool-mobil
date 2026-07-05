import 'package:flutter/material.dart';

import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/section_title.dart';

import 'models/assessment_model.dart';

import 'services/assessment_service.dart';

import 'widgets/assessment_card.dart';
import 'widgets/assessment_summary_card.dart';

import 'widgets/assessment_section.dart';

import 'utils/assessment_grouping.dart';

class AssessmentTab extends StatefulWidget {

  final String studentId;

  const AssessmentTab({

    super.key,

    required this.studentId,

  });

  @override
  State<AssessmentTab> createState() =>
      _AssessmentTabState();
}

class _AssessmentTabState
    extends State<AssessmentTab> {

  final AssessmentService service =
      const AssessmentService();

  List<AssessmentModel> assessments = [];

  bool loading = true;

  String? error;

  Future<void> loadData() async {

    try {

      error = null;

      assessments =

          await service
              .getStudentAssessments(

        widget.studentId,

      );

    } catch (e) {

      error = e.toString();

    } finally {

      if (mounted) {

        setState(() {

          loading = false;

        });
      }
    }
  }

  @override
  void initState() {

    super.initState();

    loadData();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

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

    if (assessments.isEmpty) {

      return RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          children: const [

            SizedBox(
              height: 120,
            ),

            Icon(

              Icons.assignment_outlined,

              size: 80,

              color: Colors.grey,

            ),

            SizedBox(
              height: 20,
            ),

            Center(

              child: Text(

                "Aucune évaluation programmée",

                style: TextStyle(

                  fontSize: 16,

                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final grouped = groupAssessments(

        assessments,

        );

    return RefreshIndicator(

      onRefresh: loadData,

      child: ListView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        children: [

          AssessmentSummaryCard(

                assessments: assessments,

            ),

            const SizedBox(
                height: 24,
            ),

            const SectionTitle(

                title: "Toutes les évaluations",

            ),

            const SizedBox(
                height: 18,
            ),

            ...grouped.entries.expand(

                (entry) => [

                    AssessmentSection(

                    title: entry.key,

                    ),

                    ...entry.value.map(

                    (assessment) => Padding(

                        padding: const EdgeInsets.only(

                        bottom: 16,

                        ),

                        child: AssessmentCard(

                        assessment: assessment,

                        ),

                    ),

                    ),

                ],

                ),
        ],
      ),
    );
  }
}