import 'package:flutter/material.dart';

import '../../shared/widgets/error_view.dart';
import '../../shared/widgets/loading_view.dart';

import 'models/schedule_day_model.dart';
import 'models/schedule_response_model.dart';

import 'services/schedule_service.dart';

import 'widgets/schedule_day_view.dart';
import 'widgets/schedule_summary_card.dart';

class ScheduleTab extends StatefulWidget {

  final String studentId;

  const ScheduleTab({

    super.key,

    required this.studentId,

  });

  @override
  State<ScheduleTab> createState() =>
      _ScheduleTabState();

}

class _ScheduleTabState
    extends State<ScheduleTab>
    with TickerProviderStateMixin {

  final ScheduleService service =
      ScheduleService();

  ScheduleResponseModel? schedule;

  bool loading = true;

  String? error;

  TabController? controller;

  //--------------------------------------------------------
  // LOAD
  //--------------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      final result =
          await service.getSchedule(
        widget.studentId,
      );

      controller?.dispose();

      controller = TabController(

        length: result.days.length,

        vsync: this,

      );

      final index = result.days.indexWhere(

        (e) =>
            e.weekday == result.today,

      );

      if (index >= 0) {

        controller!.index = index;

      }

      if (!mounted) return;

      setState(() {

        schedule = result;

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


  String shortDay(String day) {

  switch (day) {

    case "Lundi":
      return "Lun";

    case "Mardi":
      return "Mar";

    case "Mercredi":
      return "Mer";

    case "Jeudi":
      return "Jeu";

    case "Vendredi":
      return "Ven";

    default:
      return day;

  }

}

  //--------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

  }

  //--------------------------------------------------------

  @override
  void dispose() {

    controller?.dispose();

    super.dispose();

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

    final days = schedule!.days;

    return RefreshIndicator(

      onRefresh: loadData,

      child: Column(

        children: [

          //--------------------------------------------------
          // SUMMARY
          //--------------------------------------------------

          Padding(

            padding: const EdgeInsets.all(20),

            child: AnimatedBuilder(

              animation: controller!,

              builder: (context, _) {

                final day =

                    days[controller!.index];

                return ScheduleSummaryCard(

                  today: day.weekday,

                  courses: day.courses,

                );

              },

            ),

          ),

          //--------------------------------------------------
          // TABBAR
          //--------------------------------------------------

          Container(

            height: 56,

            margin: const EdgeInsets.symmetric(

                horizontal: 16,

                vertical: 8,

            ),

            child: TabBar(

                controller: controller,

                isScrollable: true,

                tabAlignment: TabAlignment.start,

                dividerColor: Colors.transparent,

                indicator: BoxDecoration(

                color: const Color(0xff6214BE),

                borderRadius: BorderRadius.circular(30),

                ),

                indicatorSize: TabBarIndicatorSize.tab,

                labelColor: Colors.white,

                unselectedLabelColor: Colors.grey.shade700,

                labelStyle: const TextStyle(

                fontWeight: FontWeight.w700,

                fontSize: 14,

                ),

                unselectedLabelStyle: const TextStyle(

                fontWeight: FontWeight.w500,

                fontSize: 14,

                ),

                tabs: days.map((day) {

                return Tab(

                    child: Padding(

                    padding: const EdgeInsets.symmetric(

                        horizontal: 18,

                    ),

                    child: Text(

                        shortDay(day.weekday),

                    ),

                    ),

                );

                }).toList(),

            ),

            ),

          //--------------------------------------------------

          Expanded(

            child: TabBarView(

              controller: controller,

              children: days.map(

                (day) {

                  return ScheduleDayView(

                    day: day,

                  );

                },

              ).toList(),

            ),

          ),

        ],

      ),

    );

  }

}