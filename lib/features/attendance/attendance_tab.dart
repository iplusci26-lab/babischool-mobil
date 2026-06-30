import 'package:flutter/material.dart';

import 'models/attendance_model.dart';

import 'services/attendance_service.dart';

import 'widgets/attendance_summary_card.dart';

import 'widgets/attendance_history_tile.dart';

class AttendanceTab
    extends StatefulWidget {

  final String studentId;

  const AttendanceTab({

    super.key,

    required this.studentId,
  });

  @override
  State<AttendanceTab>
  createState() =>
      _AttendanceTabState();
}

class _AttendanceTabState
    extends State<AttendanceTab> {

  final AttendanceService service =
      AttendanceService();

  AttendanceModel? attendance;

  bool loading = true;

  Future<void> loadData()
  async {

    try {

      attendance =

      await service.getAttendance(

        widget.studentId,
      );

    } catch (e) {

      debugPrint(
        e.toString(),
      );
    }

    if (mounted) {

      setState(() {

        loading = false;
      });
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

      return const Center(

        child:
        CircularProgressIndicator(),
      );
    }

    if (attendance == null) {

      return const Center(

        child: Text(

          "Impossible de charger les présences",
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

          AttendanceSummaryCard(

            summary:
            attendance!.summary,
          ),

          const SizedBox(
            height: 28,
          ),

          const Text(

            "Historique",

            style: TextStyle(

              fontSize: 18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          if (attendance!
              .history
              .isEmpty)

            Container(

              padding:
              const EdgeInsets.all(
                40,
              ),

              child: const Center(

                child: Text(

                  "Aucune présence enregistrée.",
                ),
              ),
            )

          else

            ...attendance!
                .history
                .map(

              (item) =>

                  AttendanceHistoryTile(

                history: item,
              ),
            ),
        ],
      ),
    );
  }
}