import 'package:flutter/material.dart';

import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import '../../messaging/messaging_screen.dart';
import '../../../core/navigation/navigation_controller.dart';
import '../attendance/teacher_attendance_screen.dart';
import '../classrooms/teacher_classrooms_screen.dart';
import '../homework/teacher_homework_screen.dart';
import '../schedule/teacher_schedule_screen.dart';

import 'models/teacher_dashboard_model.dart';
import 'services/teacher_dashboard_service.dart';

import 'widgets/next_course_card.dart';
import 'widgets/teacher_summary_grid.dart';
import 'widgets/today_schedule_card.dart';
import '../../notifications/notification_screen.dart';
import '../assessments/teacher_assessment_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({
    super.key,
  });

  @override
  State<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends State<TeacherDashboardScreen> {
  final TeacherDashboardService service =
      const TeacherDashboardService();

  TeacherDashboardModel? dashboard;

  bool loading = true;

  String? error;

  // ==========================================================
  // CHARGEMENT
  // ==========================================================

  Future<void> loadData() async {
    try {
      if (mounted) {
        setState(() {
          error = null;
        });
      }

      final response =
          await service.getDashboard();

      if (!mounted) return;

      setState(() {
        dashboard = response;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  // ==========================================================
  // MESSAGE ERREUR
  // ==========================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ==========================================================
  // OUVRIR L'APPEL DU PROCHAIN COURS
  // ==========================================================

  void _openNextCourseAttendance() {
    final data = dashboard;

    if (data == null) {
      _showError(
        "Les données du tableau de bord sont indisponibles.",
      );
      return;
    }

    final course = data.nextCourse;

    // --------------------------------------------------------
    // Aucun cours
    // --------------------------------------------------------

    if (course == null) {
      _showError(
        "Aucun prochain cours disponible.",
      );
      return;
    }

    // --------------------------------------------------------
    // Vérification de l'autorisation
    // --------------------------------------------------------

    if (!course.canTakeAttendance) {
      _showError(
        "L'appel n'est pas disponible pour ce cours.",
      );
      return;
    }

    // --------------------------------------------------------
    // IDENTIFIANT DU COURS
    //
    // TeacherNextCourseModel hérite de
    // TeacherScheduleModel.
    //
    // L'identifiant est donc :
    //
    // course.id
    // --------------------------------------------------------

    final scheduleId = course.id;

    if (scheduleId.trim().isEmpty) {
      _showError(
        "Le cours ne possède pas d'identifiant valide.",
      );
      return;
    }

    // --------------------------------------------------------
    // Vérification du mode
    // --------------------------------------------------------

    if (course.assignmentType == "PRIMARY") {
      _showError(
        "La prise de présence du primaire se fait par période.",
      );
      return;
    }

    // --------------------------------------------------------
    // OUVERTURE DE L'APPEL
    // --------------------------------------------------------

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TeacherAttendanceScreen(
          isPrimary: false,
          classroomId: null,
          scheduleId: scheduleId,
          title: "Appel • ${course.title}",
        ),
      ),
    );
  }

  // ==========================================================
  // OUVRIR LES DEVOIRS
  // ==========================================================

  void _openHomeworkForSchedule(
    String scheduleId,
  ) {
    if (scheduleId.trim().isEmpty) {
      _showError(
        "Impossible d'ouvrir les devoirs : "
        "cours introuvable.",
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TeacherHomeworkScreen(
          scheduleId: scheduleId,
        ),
      ),
    );
  }

  // ==========================================================
  // OUVRIR LES DEVOIRS DEPUIS LE DASHBOARD
  // ==========================================================

  void _openDashboardHomework() {
    final data = dashboard;

    if (data == null) {
      _showError(
        "Les données du tableau de bord sont indisponibles.",
      );
      return;
    }

    // --------------------------------------------------------
    // PRIORITÉ 1 :
    // prochain cours
    // --------------------------------------------------------

    final nextCourse = data.nextCourse;

    if (nextCourse != null &&
        nextCourse.id.trim().isNotEmpty) {
      _openHomeworkForSchedule(
        nextCourse.id,
      );
      return;
    }

    // --------------------------------------------------------
    // PRIORITÉ 2 :
    // premier cours du jour
    // --------------------------------------------------------

    if (data.todaySchedule.isNotEmpty) {
      final schedule =
          data.todaySchedule.first;

      if (schedule.id.trim().isNotEmpty) {
        _openHomeworkForSchedule(
          schedule.id,
        );
        return;
      }
    }

    // --------------------------------------------------------
    // Aucun cours disponible
    // --------------------------------------------------------

    _showError(
      "Aucun cours disponible pour accéder aux devoirs.",
    );
  }

  // ==========================================================
  // OUVRIR L'APPEL DEPUIS LE PLANNING
  // ==========================================================

  void _openScheduleAttendance(
    TeacherScheduleModel schedule,
  ) {
    // --------------------------------------------------------
    // IDENTIFIANT
    // --------------------------------------------------------

    final scheduleId = schedule.id;

    if (scheduleId.trim().isEmpty) {
      _showError(
        "Impossible d'ouvrir l'appel : "
        "cours introuvable.",
      );
      return;
    }

    // --------------------------------------------------------
    // PRIMAIRE
    // --------------------------------------------------------

    if (schedule.assignmentType == "PRIMARY") {
      _showError(
        "La prise de présence du primaire "
        "se fait par période.",
      );
      return;
    }

    // --------------------------------------------------------
    // OUVERTURE
    // --------------------------------------------------------

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TeacherAttendanceScreen(
          isPrimary: false,
          classroomId: null,
          scheduleId: scheduleId,
          title: "Appel • ${schedule.title}",
        ),
      ),
    );
  }

  // ==========================================================
  // ACTIONS D'UN COURS
  // ==========================================================

  void _showCourseActions(
    TeacherScheduleModel schedule,
  ) {
    final scheduleId = schedule.id;

    if (scheduleId.trim().isEmpty) {
      _showError(
        "Ce cours ne possède pas d'identifiant valide.",
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Text(
                schedule.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                "${schedule.classroom} • "
                "${schedule.startTime} - "
                "${schedule.endTime}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // ==================================================
              // APPEL
              // ==================================================

              if (schedule.assignmentType !=
                  "PRIMARY")
                _CourseActionTile(
                  icon: Icons.how_to_reg,
                  title: "Faire l'appel",
                  subtitle:
                      "Enregistrer les présences des élèves",
                  onTap: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );

                    _openScheduleAttendance(
                      schedule,
                    );
                  },
                ),

              if (schedule.assignmentType !=
                  "PRIMARY")
                const SizedBox(
                  height: 12,
                ),

              // ==================================================
              // DEVOIRS
              // ==================================================

              _CourseActionTile(
                icon: Icons.assignment_outlined,
                title: "Exercices",
                subtitle:
                    "Créer et gérer les devoirs",
                onTap: () {
                  Navigator.pop(
                    bottomSheetContext,
                  );

                  _openHomeworkForSchedule(
                    scheduleId,
                  );
                },
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================================
              // ANNULER
              // ==================================================

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );
                  },
                  child:
                      const Text("Annuler"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // GREETING
  // ==========================================================

  String get greeting {
    final hour =
        DateTime.now().hour;

    if (hour < 12) {
      return "☀️ Bonjour";
    }

    if (hour < 18) {
      return "🌤️ Bon après-midi";
    }

    return "🌙 Bonsoir";
  }

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    loadData();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    // ========================================================
    // LOADING
    // ========================================================

    if (loading) {
      return const LoadingView();
    }

    // ========================================================
    // ERREUR
    // ========================================================

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

    // ========================================================
    // DONNÉES
    // ========================================================

    final data = dashboard!;
   

    // ========================================================
    // ÉCRAN
    // ========================================================

    return Scaffold(
      backgroundColor:
          const Color(0xffF7F8FC),

      body: RefreshIndicator(
        onRefresh: loadData,

        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding: EdgeInsets.zero,

          children: [
            // ==================================================
            // HEADER
            // ==================================================

            AppHeader(
              title:
                  "$greeting ${data.teacher.name}",

              subtitle:
                  "Passez une excellente journée de cours.",
                 
            ),

            const SizedBox(
              height: 24,
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Column(
                children: [
                  // ==============================================
                  // PROCHAIN COURS
                  // ==============================================

                  NextCourseCard(
                    course:
                        data.nextCourse,

                    onAttendance:
                        data.nextCourse == null ||
                                !data
                                    .nextCourse!
                                    .canTakeAttendance
                            ? null
                            : _openNextCourseAttendance,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==============================================
                  // STATISTIQUES
                  // ==============================================

                  TeacherSummaryGrid(
                    summary:
                        data.summary,

                    // --------------------------------------------
                    // COURS
                    // --------------------------------------------

                    onCoursesTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TeacherScheduleScreen(),
                        ),
                      );
                    },

                    // --------------------------------------------
                    // CLASSES
                    // --------------------------------------------

                    onClassesTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TeacherClassroomsScreen(),
                        ),
                      );
                    },

                    // --------------------------------------------
                    // ÉLÈVES
                    // --------------------------------------------

                    onStudentsTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TeacherClassroomsScreen(),
                        ),
                      );
                    },

                    // --------------------------------------------
                    // DEVOIRS
                    // --------------------------------------------

                    onHomeworksTap:
                        _openDashboardHomework,

                    // --------------------------------------------
                    // ÉVALUATIONS
                    // --------------------------------------------

                    onAssessmentsTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TeacherAssessmentScreen(),
                        ),
                      );
                    },

                    // --------------------------------------------
                    // MESSAGES
                    // --------------------------------------------

                    onMessagesTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MessagingScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // ==============================================
                  // TITRE PLANNING
                  // ==============================================

                  if (data.todaySchedule.isNotEmpty)
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Planning du jour",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const TeacherScheduleScreen(),
                              ),
                            );
                          },

                          child:
                              const Text(
                            "Voir tout",
                          ),
                        ),
                      ],
                    ),

                  // ==============================================
                  // ESPACE
                  // ==============================================

                  if (data.todaySchedule.isNotEmpty)
                    const SizedBox(
                      height: 16,
                    ),

                  // ==============================================
                  // PLANNING
                  // ==============================================

                  if (data.todaySchedule.isNotEmpty)
                    TodayScheduleCard(
                      schedules:
                          data.todaySchedule,

                      onCourseTap:
                          _showCourseActions,
                    ),

                  // ==============================================
                  // AUCUN COURS
                  // ==============================================

                  if (data.todaySchedule.isEmpty)
                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.all(
                        30,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                      ),

                      child:
                          const Column(
                        children: [
                          Text(
                            "🎉",

                            style:
                                TextStyle(
                              fontSize: 60,
                            ),
                          ),

                          SizedBox(
                            height: 18,
                          ),

                          Text(
                            "Aucun cours prévu aujourd'hui",

                            textAlign:
                                TextAlign.center,

                            style:
                                TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Profitez de cette journée "
                            "pour préparer vos prochains cours.",

                            textAlign:
                                TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(
                    height: 40,
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

// ============================================================
// ACTION D'UN COURS
// ============================================================

class _CourseActionTile
    extends StatelessWidget {
  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const _CourseActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(18),

      child: Container(
        padding:
            const EdgeInsets.all(16),

        decoration:
            BoxDecoration(
          color:
              const Color(0xffF7F8FC),

          borderRadius:
              BorderRadius.circular(18),
        ),

        child: Row(
          children: [
            // ==================================================
            // ICON
            // ==================================================

            Container(
              width: 50,
              height: 50,

              decoration:
                  BoxDecoration(
                color:
                    const Color(0xff6214BE)
                        .withOpacity(.10),

                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: Icon(
                icon,
                color:
                    const Color(0xff6214BE),
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            // ==================================================
            // TEXTE
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    subtitle,

                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // CHEVRON
            // ==================================================

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}