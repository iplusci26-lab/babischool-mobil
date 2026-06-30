import 'package:flutter/material.dart';

import '../../../shared/widgets/section_title.dart';

import 'models/grades_model.dart';

import 'services/grades_service.dart';

import 'widgets/grades_summary_card.dart';

import 'widgets/subject_grade_card.dart';

class GradesTab
    extends StatefulWidget {

  final String studentId;

  const GradesTab({

    super.key,

    required this.studentId,
  });

  @override
  State<GradesTab> createState() =>
      _GradesTabState();
}

class _GradesTabState
    extends State<GradesTab> {

  final service =
      GradesService();

  GradesModel? grades;

  bool loading = true;

  Future<void> loadData()
  async {

    try {

      grades =
          await service
              .getGrades(
        widget.studentId,
      );

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
  Widget build(BuildContext context) {

    if (loading) {

      return const Center(

        child:
            CircularProgressIndicator(),
      );
    }

    if (grades == null) {

      return const Center(

        child: Text(
          "Impossible de charger les notes",
        ),
      );
    }

    return RefreshIndicator(

      onRefresh: loadData,

      child: ListView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        children: [

          GradesSummaryCard(

            report:
                grades!
                    .reportCard,
          ),

          const SizedBox(
            height: 24,
          ),

          const SectionTitle(

            title: "Matières",
          ),

          const SizedBox(
            height: 16,
          ),

          ...grades!
              .subjects
              .map(

                (e) => Padding(

                  padding:
                      const EdgeInsets.only(
                    bottom: 14,
                  ),

                  child:
                      SubjectGradeCard(
                    subject: e,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}