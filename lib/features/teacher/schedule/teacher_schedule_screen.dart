import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import 'models/teacher_schedule_course_model.dart';
import 'models/teacher_schedule_day_model.dart';
import 'models/teacher_schedule_response_model.dart';

import 'services/teacher_schedule_service.dart';

import 'widgets/schedule_day_card.dart';

import '../attendance/teacher_attendance_screen.dart';

class TeacherScheduleScreen
    extends StatefulWidget {
  const TeacherScheduleScreen({
    super.key,
  });

  @override
  State<TeacherScheduleScreen> createState() =>
      _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState
    extends State<TeacherScheduleScreen> {
  final TeacherScheduleService service =
      const TeacherScheduleService();

  TeacherScheduleResponseModel? response;

  List<TeacherScheduleDayModel> days = [];

  bool loading = true;

  String? error;

  //============================================================
  // CHARGEMENT
  //============================================================

  Future<void> loadData() async {
    try {
      setState(() {
        error = null;
      });

      final data =
          await service.getSchedule();

      if (!mounted) {
        return;
      }

      setState(() {
        response = data;

        days = List<
            TeacherScheduleDayModel>.from(
          data.days,
        );

        loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  //============================================================
  // OUVRIR L'APPEL
  //============================================================

  void openAttendance(
    TeacherScheduleCourseModel course,
  ) {
    //==========================================================
    // PRISE DE PRÉSENCE PAR PÉRIODES
    //==========================================================

    if (course.isPeriodAttendance) {
      final classroomId =
          course.classroom.id;

      if (classroomId.trim().isEmpty) {
        _showError(
          "La classe est introuvable.",
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              TeacherAttendanceScreen(
            isPrimary: true,

            classroomId:
                classroomId,

            scheduleId: null,

            title:
                "Appel • ${course.classroomName}",
          ),
        ),
      );

      return;
    }

    //==========================================================
    // PRISE DE PRÉSENCE PAR COURS
    //==========================================================

    if (course.isScheduleAttendance) {
      final scheduleId =
          course.scheduleId;

      if (scheduleId.trim().isEmpty) {
        _showError(
          "Le cours est introuvable.",
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              TeacherAttendanceScreen(
            isPrimary: false,

            classroomId: null,

            scheduleId:
                scheduleId,

            title:
                "Appel • ${course.subjectName}",
          ),
        ),
      );

      return;
    }

    //==========================================================
    // MODE INCONNU
    //==========================================================

    _showError(
      "Le mode de prise de présence "
      "de cette classe est inconnu.",
    );
  }

  //============================================================
  // MESSAGE ERREUR
  //============================================================

  void _showError(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            Colors.red,
      ),
    );
  }

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    loadData();
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    //==========================================================
    // LOADING
    //==========================================================

    if (loading) {
      return const LoadingView();
    }

    //==========================================================
    // ERREUR
    //==========================================================

    if (error != null) {
      return Scaffold(
        backgroundColor:
            AppColors.background,
        body: ErrorView(
          message: error!,
          onRetry: () {
            setState(() {
              loading = true;
              error = null;
            });

            loadData();
          },
        ),
      );
    }

    //==========================================================
    // ÉCRAN
    //==========================================================

    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: RefreshIndicator(
        onRefresh: loadData,

        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding:
              EdgeInsets.zero,

          children: [
            //==================================================
            // HEADER
            //==================================================

            const AppHeader(
              title:
                  "Mon emploi du temps",

              subtitle:
                  "Consultez votre planning hebdomadaire.",
            ),

            //==================================================
            // CONTENU
            //==================================================

            Padding(
              padding:
                  const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  //============================================
                  // STATISTIQUES
                  //============================================

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon:
                              Icons.calendar_month,
                          color:
                              Colors.indigo,
                          value: response!
                              .totalDays
                              .toString(),
                          title:
                              "Jours",
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      Expanded(
                        child: _StatCard(
                          icon:
                              Icons.schedule,
                          color:
                              Colors.green,
                          value: response!
                              .totalCourses
                              .toString(),
                          title:
                              "Cours",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  //============================================
                  // LISTE DES JOURS
                  //============================================

                  if (days.isEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 80,
                      ),

                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 90,
                              color:
                                  Colors.grey.shade300,
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            const Text(
                              "Aucun emploi du temps",
                              style:
                                  TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              "Votre établissement "
                              "n'a pas encore publié "
                              "votre planning.",
                              textAlign:
                                  TextAlign.center,
                              style:
                                  TextStyle(
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...days.map(
                      (
                        TeacherScheduleDayModel day,
                      ) {
                        return ScheduleDayCard(
                          day: day,

                          onCourseTap:
                              (index) {
                            if (index < 0 ||
                                index >=
                                    day.courses
                                        .length) {
                              return;
                            }

                            final course =
                                day.courses[
                                    index];

                            openAttendance(
                              course,
                            );
                          },
                        );
                      },
                    ),

                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//================================================================
// STAT CARD
//================================================================

class _StatCard
    extends StatelessWidget {
  final IconData icon;

  final Color color;

  final String title;

  final String value;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            value,
            style:
                const TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            title,
          ),
        ],
      ),
    );
  }
}