import 'package:flutter/material.dart';

import 'models/attendance_model.dart';

import 'services/attendance_service.dart';

import 'widgets/attendance_summary_card.dart';

import 'widgets/attendance_history_tile.dart';


// ==========================================================
// ATTENDANCE TAB
// ==========================================================

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


// ==========================================================
// STATE
// ==========================================================

class _AttendanceTabState
    extends State<AttendanceTab> {


  // ========================================================
  // SERVICE
  // ========================================================

  final AttendanceService service =
      AttendanceService();


  // ========================================================
  // DATA
  // ========================================================

  AttendanceModel? attendance;


  // ========================================================
  // LOADING
  // ========================================================

  bool loading = true;


  // ========================================================
  // LOAD DATA
  // ========================================================

  Future<void> loadData() async {

    try {

      if (mounted) {

        setState(() {

          loading = true;

        });

      }


      attendance =
          await service.getAttendance(

        widget.studentId,

      );

    } catch (e) {

      debugPrint(

        "Erreur chargement présences : $e",

      );

    } finally {

      if (mounted) {

        setState(() {

          loading = false;

        });

      }

    }

  }


  // ========================================================
  // INIT
  // ========================================================

  @override
  void initState() {

    super.initState();

    loadData();

  }


  // ========================================================
  // BUILD
  // ========================================================

  @override
  Widget build(
    BuildContext context,
  ) {


    // ======================================================
    // LOADING
    // ======================================================

    if (loading) {

      return const Center(

        child:
            CircularProgressIndicator(),

      );

    }


    // ======================================================
    // ERROR / EMPTY
    // ======================================================

    if (attendance == null) {

      return const Center(

        child: Text(

          "Impossible de charger les présences",

        ),

      );

    }


    // ======================================================
    // CONTENT
    // ======================================================

    return RefreshIndicator(

      onRefresh: loadData,

      child: ListView(

        physics:
            const AlwaysScrollableScrollPhysics(),

        padding:
            const EdgeInsets.all(
              20,
            ),

        children: [


          // ==================================================
          // SUMMARY
          // ==================================================

          AttendanceSummaryCard(

            summary:
                attendance!.summary,

          ),


          const SizedBox(
            height: 28,
          ),


          // ==================================================
          // TITLE
          // ==================================================

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


          // ==================================================
          // EMPTY HISTORY
          // ==================================================

          if (
              attendance!
                  .history
                  .isEmpty
          )

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


          // ==================================================
          // HISTORY
          // ==================================================

          else

            ...attendance!
                .history
                .map(

              (
                item,
              ) =>

                  AttendanceHistoryTile(

                history: item,

              ),

            ),

        ],

      ),

    );

  }

}