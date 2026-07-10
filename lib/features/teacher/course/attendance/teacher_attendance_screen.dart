import 'package:flutter/material.dart';

import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';

import 'models/attendance_response_model.dart';
import 'models/attendance_student_model.dart';

import 'services/teacher_attendance_service.dart';

import 'widgets/attendance_summary_card.dart';
import 'widgets/attendance_student_tile.dart';

class TeacherAttendanceScreen extends StatefulWidget {

  final String scheduleId;

  const TeacherAttendanceScreen({

    super.key,

    required this.scheduleId,

  });

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();

}

class _TeacherAttendanceScreenState
    extends State<TeacherAttendanceScreen> {

  final TeacherAttendanceService _service =
      TeacherAttendanceService();

  AttendanceResponseModel? response;

  bool loading = true;

  bool saving = false;

  String? error;

  //----------------------------------------------------
  // LOAD
  //----------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getAttendance(

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

  //----------------------------------------------------
  // SAVE
  //----------------------------------------------------

  Future<void> saveAttendance() async {

    if (response == null) return;

    setState(() {

      saving = true;

    });

    try {

      await _service.saveAttendance(

        widget.scheduleId,

        response!.students
            .map(
              (e) => e.toJson(),
            )
            .toList(),

      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(

            "Appel enregistré avec succès",

          ),

        ),

      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

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

  //----------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

  }

  //----------------------------------------------------

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

        title: Text(

          response!.classroomName,

        ),

      ),

      floatingActionButton:

          FloatingActionButton.extended(

        onPressed:

            saving ? null : saveAttendance,

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

            AttendanceSummaryCard(

              classroom:

                  response!.classroomName,

              date:

                  response!.sessionDate,

              students:

                  response!.students.length,

            ),

            const SizedBox(

              height: 24,

            ),

            ...response!.students.map(

              (AttendanceStudentModel student) {

                return AttendanceStudentTile(

                  student: student,

                  onStatusChanged: (

                    status,

                  ) {

                    setState(() {

                      student.status = status;

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