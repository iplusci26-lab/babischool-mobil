import 'package:flutter/material.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import './models/teacher_assessment_grades_response_model.dart';
import './models/teacher_grade_model.dart';

import './services/teacher_assessment_service.dart';

class TeacherAssessmentGradesScreen
    extends StatefulWidget {
  final String assessmentId;

  const TeacherAssessmentGradesScreen({
    super.key,
    required this.assessmentId,
  });

  @override
  State<TeacherAssessmentGradesScreen> createState() =>
      _TeacherAssessmentGradesScreenState();
}

class _TeacherAssessmentGradesScreenState
    extends State<TeacherAssessmentGradesScreen> {
  final TeacherAssessmentService service =
      const TeacherAssessmentService();

  TeacherAssessmentGradesResponseModel? data;

  bool loading = true;
  bool saving = false;

  String? error;

  final Map<String, TextEditingController>
      _scoreControllers = {};

  final Map<String, TextEditingController>
      _remarksControllers = {};

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    for (final controller
        in _scoreControllers.values) {
      controller.dispose();
    }

    for (final controller
        in _remarksControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  //============================================================
  // CHARGEMENT
  //============================================================

  Future<void> _loadData() async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
          error = null;
        });
      }

      final response =
          await service.getAssessmentGrades(
        widget.assessmentId,
      );

      if (!mounted) {
        return;
      }

      _initializeControllers(response);

      setState(() {
        data = response;
        loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
        error = _cleanError(e);
      });
    }
  }

  //============================================================
  // INITIALISATION
  //============================================================

  void _initializeControllers(
    TeacherAssessmentGradesResponseModel response,
  ) {
    for (final controller
        in _scoreControllers.values) {
      controller.dispose();
    }

    for (final controller
        in _remarksControllers.values) {
      controller.dispose();
    }

    _scoreControllers.clear();
    _remarksControllers.clear();

    for (final student
        in response.students) {
      final enrollmentId =
          student.enrollmentId;

      _scoreControllers[enrollmentId] =
          TextEditingController(
        text: student.hasScore
            ? _formatScore(student.score)
            : "",
      );

      _remarksControllers[enrollmentId] =
          TextEditingController(
        text: student.remarks,
      );
    }
  }

  String _formatScore(
    double? score,
  ) {
    if (score == null) {
      return "";
    }

    if (score == score.roundToDouble()) {
      return score.toInt().toString();
    }

    return score.toString();
  }

  //============================================================
  // SAUVEGARDE
  //============================================================

  Future<void> _saveGrades() async {
    final response = data;

    if (response == null) {
      return;
    }

    final assessment =
        response.assessment;

    final List<Map<String, dynamic>>
        grades = [];

    for (final student
        in response.students) {
      final enrollmentId =
          student.enrollmentId;

      final scoreController =
          _scoreControllers[enrollmentId];

      final remarksController =
          _remarksControllers[enrollmentId];

      if (scoreController == null) {
        continue;
      }

      final rawScore =
          scoreController.text.trim();

      // Une note vide signifie que
      // l'élève n'est pas encore noté.
      if (rawScore.isEmpty) {
        continue;
      }

      final score = double.tryParse(
        rawScore.replaceAll(",", "."),
      );

      if (score == null) {
        _showError(
          "La note de ${student.fullName} "
          "est invalide.",
        );
        return;
      }

      if (score < 0) {
        _showError(
          "La note de ${student.fullName} "
          "ne peut pas être négative.",
        );
        return;
      }

      if (score > assessment.maxScore) {
        _showError(
          "La note de ${student.fullName} "
          "ne peut pas dépasser "
          "${assessment.maxScore}.",
        );
        return;
      }

      grades.add({
        "enrollment_id": enrollmentId,
        "score": score,
        "remarks":
            remarksController?.text.trim() ?? "",
      });
    }

    if (grades.isEmpty) {
      _showError(
        "Aucune note à enregistrer.",
      );
      return;
    }

    try {
      setState(() {
        saving = true;
      });

      final updated =
          await service.saveGrades(
        assessmentId: assessment.id,
        grades: grades,
      );

      if (!mounted) {
        return;
      }

      _initializeControllers(updated);

      setState(() {
        data = updated;
        saving = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Les notes ont été enregistrées avec succès.",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        saving = false;
      });

      _showError(
        _cleanError(e),
      );
    }
  }

  //============================================================
  // ERREUR
  //============================================================

  void _showError(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _cleanError(
    Object error,
  ) {
    final message =
        error.toString();

    if (message.startsWith(
      "Exception: ",
    )) {
      return message.substring(11);
    }

    return message;
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (loading) {
      return const LoadingView();
    }

    if (error != null ||
        data == null) {
      return Scaffold(
        backgroundColor:
            const Color(0xffF7F8FC),
        appBar: AppBar(
          title: const Text(
            "Saisie des notes",
          ),
        ),
        body: ErrorView(
          message: error ??
              "Impossible de charger les données.",
          onRetry: _loadData,
        ),
      );
    }

    final response = data!;
    final assessment =
        response.assessment;
    final statistics =
        response.statistics;

    return Scaffold(
      backgroundColor:
          const Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              true,
            );
          },
        ),
        title: const Text(
          "Saisie des notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff1F2937),
          ),
        ),
      ),

      bottomNavigationBar:
          SafeArea(
        child: Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            12,
          ),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed:
                  saving
                      ? null
                      : _saveGrades,
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    const Color(0xff6214BE),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),
              icon: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.save_rounded,
                    ),
              label: Text(
                saving
                    ? "Enregistrement..."
                    : "Enregistrer les notes",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(
            bottom: 30,
          ),
          children: [
            Container(
              margin:
                  const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                16,
              ),
              padding:
                  const EdgeInsets.all(20),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    assessment.title,
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xff1F2937),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "${assessment.classroom.name} • "
                    "${assessment.subject.name}",
                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoBadge(
                        icon:
                            Icons.score_outlined,
                        text:
                            "Max. ${assessment.maxScore}",
                      ),
                      _InfoBadge(
                        icon:
                            Icons.star_outline,
                        text:
                            "Coef. ${assessment.weight}",
                      ),
                      _InfoBadge(
                        icon:
                            Icons.calendar_today,
                        text:
                            assessment.term.name,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                        _StatisticCard(
                      title: "Élèves",
                      value:
                          statistics.totalStudents
                              .toString(),
                      icon:
                          Icons.people_outline,
                      color:
                          const Color(
                        0xff6214BE,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:
                        _StatisticCard(
                      title: "Saisies",
                      value:
                          statistics.graded
                              .toString(),
                      icon:
                          Icons
                              .check_circle_outline,
                      color:
                          Colors.green,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:
                        _StatisticCard(
                      title: "Restantes",
                      value:
                          statistics.pending
                              .toString(),
                      icon:
                          Icons
                              .pending_outlined,
                      color:
                          Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding:
                  const EdgeInsets.all(18),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xff6214BE,
                      ).withOpacity(.10),
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                    child:
                        const Icon(
                      Icons.analytics_outlined,
                      color:
                          Color(0xff6214BE),
                    ),
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          "Moyenne actuelle",
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${statistics.average} / "
                          "${assessment.maxScore}",
                          style: TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "${statistics.completionPercentage.toStringAsFixed(0)}%",
                    style:
                        const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xff6214BE),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            const Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                "Notes des élèves",
                style:
                    TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (response.students.isEmpty)
              const _EmptyStudentsView()
            else
              ...response.students.map(
                (student) =>
                    _StudentGradeCard(
                  student: student,
                  scoreController:
                      _scoreControllers[
                          student
                              .enrollmentId]!,
                  remarksController:
                      _remarksControllers[
                          student
                              .enrollmentId]!,
                  maxScore:
                      assessment.maxScore,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//============================================================
// ÉLÈVE
//============================================================

class _StudentGradeCard
    extends StatelessWidget {
  final TeacherGradeModel student;
  final TextEditingController scoreController;
  final TextEditingController remarksController;
  final double maxScore;

  const _StudentGradeCard({
    required this.student,
    required this.scoreController,
    required this.remarksController,
    required this.maxScore,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin:
          const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        14,
      ),
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xff6214BE,
                  ).withOpacity(.10),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color:
                      Color(0xff6214BE),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      student.fullName,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    if (student
                                .studentNumber !=
                            null &&
                        student.studentNumber!
                            .isNotEmpty)
                      Text(
                        student.studentNumber!,
                        style: TextStyle(
                          color: Colors
                              .grey
                              .shade600,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              if (student.graded)
                const Icon(
                  Icons.check_circle,
                  color:
                      Colors.green,
                  size: 22,
                ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          TextField(
            controller:
                scoreController,
            keyboardType:
                const TextInputType
                    .numberWithOptions(
              decimal: true,
            ),
            decoration:
                InputDecoration(
              labelText: "Note",
              hintText: "Ex. 15.5",
              suffixText:
                  "/ $maxScore",
              prefixIcon:
                  const Icon(
                Icons.score_outlined,
              ),
              filled: true,
              fillColor:
                  const Color(
                0xffF7F8FC,
              ),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          TextField(
            controller:
                remarksController,
            maxLines: 2,
            decoration:
                InputDecoration(
              labelText: "Remarque",
              hintText: "Facultatif",
              prefixIcon:
                  const Icon(
                Icons.comment_outlined,
              ),
              filled: true,
              fillColor:
                  const Color(
                0xffF7F8FC,
              ),
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//============================================================
// STATISTIQUE
//============================================================

class _StatisticCard
    extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            value,
            style:
                const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Text(
            title,
            style: TextStyle(
              color:
                  Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

//============================================================
// BADGE
//============================================================

class _InfoBadge
    extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBadge({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xffF5F6FA),
        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color:
                Colors.grey.shade700,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color:
                  Colors.grey.shade700,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

//============================================================
// VIDE
//============================================================

class _EmptyStudentsView
    extends StatelessWidget {
  const _EmptyStudentsView();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding:
          const EdgeInsets.all(35),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 60,
            color:
                Colors.grey.shade300,
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            "Aucun élève",
            style:
                TextStyle(
              fontSize: 19,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            "Aucun élève n'est disponible "
            "pour cette évaluation.",
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}