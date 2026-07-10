import 'package:flutter/material.dart';

import '../../../shared/widgets/dashboard_header.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import 'models/teacher_schedule_model.dart';
import 'models/teacher_schedule_response.dart';

import 'services/teacher_schedule_service.dart';

import 'widgets/teacher_schedule_card.dart';
import 'widgets/teacher_schedule_day_header.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({
    super.key,
  });

  @override
  State<TeacherScheduleScreen> createState() =>
      _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState
    extends State<TeacherScheduleScreen> {

  final TeacherScheduleService _service =
      TeacherScheduleService();

  TeacherScheduleResponse? response;

  bool loading = true;

  String? error;

  //--------------------------------------------------------
  // LOAD
  //--------------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getSchedule();

    } catch (e) {

      error = e.toString();

    }

    if (!mounted) return;

    setState(() {

      loading = false;

    });

  }

  //--------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

  }

  //--------------------------------------------------------

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

    //--------------------------------------------------------
    // GROUPER PAR JOUR
    //--------------------------------------------------------

    final Map<String, List<TeacherScheduleModel>>
        grouped = {};

    for (final course in response!.schedule) {

      grouped.putIfAbsent(

        course.weekday,

        () => [],

      );

      response!.schedule.sort(

        (a, b) =>

            a.startTime.compareTo(

              b.startTime,

            ),

      );
      grouped[course.weekday]!.add(course);
      

    }
      const weekdays = [

      "Lundi",

      "Mardi",

      "Mercredi",

      "Jeudi",

      "Vendredi",

      "Samedi",

      "Dimanche",

    ];
    //--------------------------------------------------------

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(

        title: const Text(

          "Mon planning",

        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          padding: const EdgeInsets.all(20),

          physics:
              const AlwaysScrollableScrollPhysics(),

          children: [

            //--------------------------------------------------
            // HEADER
            //--------------------------------------------------

            DashboardHeader(

              username: "Mon planning",

              subtitle:  "${response!.schedule.length} ${response!.schedule.length > 1 ? 'cours programmés' : 'cours programmé'} cette semaine",

            ),

            const SizedBox(

              height: 24,

            ),

            //--------------------------------------------------
            // AUCUN COURS
            //--------------------------------------------------

            if (grouped.isEmpty)

              Container(

                padding:
                    const EdgeInsets.all(40),

                alignment: Alignment.center,

                child: Column(

                  children: [

                    Icon(

                      Icons.calendar_month_rounded,

                      size: 80,

                      color: Colors.deepPurple.shade200,

                    ),

                    const SizedBox(

                      height: 20,

                    ),

                    const Text(

                      "Aucun cours disponible.",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),

                  ],

                ),

              )

            else

              ...weekdays.where(

                (day) => grouped.containsKey(day),

              ).expand(

                (day) {

                  final courses = grouped[day]!;

                  return [

                    TeacherScheduleDayHeader(

                      day: day,

                    ),

                    ...courses.map(

                      (course) => TeacherScheduleCard(

                        course: course,

                      ),

                    ),

                  ];

                },

              ),

            const SizedBox(

              height: 30,

            ),

          ],

        ),

      ),

    );

  }

}