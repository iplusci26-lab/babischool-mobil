import 'package:flutter/material.dart';

import '../../../shared/models/student_model.dart';

import '../models/student_detail_model.dart';

import '../services/student_details_service.dart';

import '../widgets/student_info_tab.dart';
import '../../attendance/attendance_tab.dart';
import '../../grades/grades_tab.dart';
import '../../payments/finance_tab.dart';
import '../../assessments/assessment_tab.dart';
import '../../homeworks/homework_tab.dart';
import '../../schedule/schedule_tab.dart';

class StudentDetailsScreen
    extends StatefulWidget {

  final StudentModel student;

  const StudentDetailsScreen({

    super.key,

    required this.student,
  });

  @override
  State<StudentDetailsScreen>
      createState() =>
      _StudentDetailsScreenState();
}

class _StudentDetailsScreenState
    extends State<StudentDetailsScreen> {

  StudentDetailModel? details;

  bool loading = true;

  Future<void> loadData()
  async {

    try {

      details = await StudentDetailsService().getStudentDetails(
        widget.student.id,
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

    return DefaultTabController(

      length: 7,

      child: Scaffold(

        backgroundColor:
        const Color(
          0xffF7F8FC,
        ),

        appBar: AppBar(

          title: Text(
            widget.student.name,
          ),

          bottom: const TabBar(

            isScrollable: true,

            tabs: [

              Tab(
                text: "Notes",
              ),

              Tab(
                text: "Evaluations",
              ),

              Tab(
                text: "Devoirs programmés"
              ),

              Tab(
                text: "Emploi du temps",
              ),

              Tab(
                text: "Présence",
              ),

              Tab(
                text: "Finances",
              ),

              Tab(
                text: "Infos",
              ),
            ],
          ),
        ),

        body:

        loading

        ? const Center(

            child:
            CircularProgressIndicator(),
          )

        : TabBarView(

            children: [

              GradesTab(
                studentId: widget.student.id,
              ),

              AssessmentTab(
                  studentId: widget.student.id,
              ),

              HomeworkTab(
                studentId: widget.student.id,
              ),

              ScheduleTab(
                  studentId: widget.student.id,
              ),
              
              AttendanceTab(
                  studentId: widget.student.id,
              ),


              FinanceTab(
                  studentId: widget.student.id,
              ),

              details == null

              ? const Center(
                  child: Text(
                    "Impossible de charger les informations",
                  ),
                )

              : StudentInfoTab(
                  student: details!,
                ),
            ],
          ),
      ),
    );
  }
}