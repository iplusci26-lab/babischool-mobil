import 'package:flutter/material.dart';

import '../../../../../shared/widgets/error_view.dart';
import '../../../../../shared/widgets/loading_view.dart';

import 'models/student_attendance_model.dart';
import 'models/student_attendance_response.dart';

import 'services/teacher_student_attendance_service.dart';

class TeacherStudentAttendanceScreen extends StatefulWidget {

  final String studentId;

  const TeacherStudentAttendanceScreen({

    super.key,

    required this.studentId,

  });

  @override
  State<TeacherStudentAttendanceScreen> createState() =>
      _TeacherStudentAttendanceScreenState();

}

class _TeacherStudentAttendanceScreenState
    extends State<TeacherStudentAttendanceScreen> {

  final TeacherStudentAttendanceService _service =
      TeacherStudentAttendanceService();

  StudentAttendanceResponse? response;

  bool loading = true;

  String? error;

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getAttendance(

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

  IconData getIcon(String status) {

    switch (status) {

      case "present":

        return Icons.check_circle;

      case "absent":

        return Icons.cancel;

      case "late":

        return Icons.schedule;

      default:

        return Icons.info;

    }

  }

  Color getColor(String status) {

    switch (status) {

      case "present":

        return Colors.green;

      case "absent":

        return Colors.red;

      case "late":

        return Colors.orange;

      default:

        return Colors.grey;

    }

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

          "Historique des absences",

        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView.builder(

          padding: const EdgeInsets.all(20),

          itemCount: response!.attendance.length,

          itemBuilder: (_, index) {

            final item = response!.attendance[index];

            return Card(

              margin: const EdgeInsets.only(

                bottom: 14,

              ),

              child: ListTile(

                leading: Icon(

                  getIcon(item.status),

                  color: getColor(item.status),

                ),

                title: Text(item.date),

                subtitle: Text(item.status),

              ),

            );

          },

        ),

      ),

    );

  }

}   