import 'package:flutter/material.dart';

import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/error_view.dart';

import 'models/homework_model.dart';
import 'services/homework_service.dart';

import 'widgets/homework_summary_card.dart';
import 'widgets/homework_card.dart';
import '../assessments/widgets/assessment_section.dart';

class HomeworkTab extends StatefulWidget {

  final String studentId;

  const HomeworkTab({

    super.key,

    required this.studentId,

  });

  @override
  State<HomeworkTab> createState() =>
      _HomeworkTabState();
}

class _HomeworkTabState
    extends State<HomeworkTab> {

  final HomeworkService service =
      HomeworkService();

  List<HomeworkModel> homeworks = [];

  bool loading = true;

  String? error;

  //--------------------------------------------------------
  // LOAD
  //--------------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      final result =

          await service.getHomeworks(

        widget.studentId,

      );

      if (!mounted) return;

      setState(() {

        homeworks = result;

      });

    } catch (e) {

      if (!mounted) return;

      setState(() {

        error = e.toString();

      });

    } finally {

      if (mounted) {

        setState(() {

          loading = false;

        });

      }

    }

  }

  //--------------------------------------------------------
  // GROUP
  //--------------------------------------------------------

  Map<String, List<HomeworkModel>>
      get grouped {

    final Map<String,
        List<HomeworkModel>> map = {};

    for (final homework
        in homeworks) {

      map.putIfAbsent(

        homework.dateLabel,

        () => [],

      );

      map[homework.dateLabel]!

          .add(homework);

    }

    return map;

  }

  //--------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

  }

  //--------------------------------------------------------

  @override
  Widget build(
      BuildContext context) {

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

    return RefreshIndicator(

      onRefresh: loadData,

      child: ListView(

        padding:
            const EdgeInsets.all(20),

        children: [

          //--------------------------------------------------
          // SUMMARY
          //--------------------------------------------------

          HomeworkSummaryCard(

            homeworks: homeworks,

          ),

          //--------------------------------------------------

          const SizedBox(

            height: 24,

          ),

          //--------------------------------------------------

          ...grouped.entries.expand(

            (entry) => [

              AssessmentSection(

                title: entry.key,

              ),

              ...entry.value.map(

                (homework) => Padding(

                  padding:

                      const EdgeInsets.only(

                    bottom: 16,

                  ),

                  child: HomeworkCard(

                    homework: homework,

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