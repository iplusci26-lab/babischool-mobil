import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import 'models/teacher_attendance_response_model.dart';
import 'models/teacher_attendance_student_model.dart';
import 'services/teacher_attendance_service.dart';

import 'widgets/attendance_session_selector.dart';
import 'widgets/attendance_student_tile.dart';
import 'widgets/attendance_summary_card.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  //============================================================
  // MODE
  //============================================================

  final bool isPrimary;

  //============================================================
  // PRIMAIRE
  //============================================================

  final String? classroomId;

  //============================================================
  // SECONDAIRE
  //============================================================

  final String? scheduleId;

  //============================================================
  // TITRE
  //============================================================

  final String? title;

  const TeacherAttendanceScreen({
    super.key,
    required this.isPrimary,
    this.classroomId,
    this.scheduleId,
    this.title,
  });

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState
    extends State<TeacherAttendanceScreen> {
  final TeacherAttendanceService service =
      const TeacherAttendanceService();

  //============================================================
  // DONNÉES
  //============================================================

  TeacherAttendanceResponseModel? response;

  List<TeacherAttendanceStudentModel> students = [];

  //============================================================
  // SÉLECTION PRIMAIRE
  //============================================================

  String? selectedPeriod;

  //============================================================
  // ÉTAT
  //============================================================

  bool loading = true;

  bool saving = false;

  bool closing = false;

  String? error;

  //============================================================
  // GETTERS
  //============================================================

  bool get hasSession => response != null;

  bool get sessionIsOpen =>
      response?.session.isOpen ?? false;

  bool get canEdit =>
      response?.session.canEdit ?? false;

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  //============================================================
  // INITIALISATION
  //============================================================

  void _initialize() {
    //==========================================================
    // PRIMAIRE
    //==========================================================

    if (widget.isPrimary) {
      if (widget.classroomId == null ||
          widget.classroomId!.trim().isEmpty) {
        setState(() {
          loading = false;
          error = "La classe est introuvable.";
        });

        return;
      }

      // Le primaire fonctionne par période.
      //
      // On attend que l'enseignant choisisse
      // la période avant de créer/récupérer
      // la session.

      setState(() {
        loading = false;
      });

      return;
    }

    //==========================================================
    // SECONDAIRE
    //==========================================================

    if (widget.scheduleId == null ||
        widget.scheduleId!.trim().isEmpty) {
      setState(() {
        loading = false;
        error = "Le cours est introuvable.";
      });

      return;
    }

    _openSecondarySession();
  }

  //============================================================
  // OUVRIR SESSION PRIMAIRE
  //============================================================

  Future<void> _openPrimarySession(
    String period,
  ) async {
    if (widget.classroomId == null ||
        widget.classroomId!.trim().isEmpty) {
      _showError("Classe introuvable.");

      return;
    }

    setState(() {
      loading = true;
      error = null;
      selectedPeriod = period;
    });

    try {
      final result =
          await service.openPrimarySession(
        classroomId: widget.classroomId!,
        period: period,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        response = result;

        students =
            List<TeacherAttendanceStudentModel>.from(
          result.students,
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
  // OUVRIR SESSION SECONDAIRE
  //============================================================

  Future<void> _openSecondarySession() async {
    if (widget.scheduleId == null ||
        widget.scheduleId!.trim().isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
        error = "Cours introuvable.";
      });

      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final result =
          await service.openScheduleSession(
        scheduleId: widget.scheduleId!,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        response = result;

        students =
            List<TeacherAttendanceStudentModel>.from(
          result.students,
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
  // RAFRAÎCHIR
  //============================================================

  Future<void> _refresh() async {
    //==========================================================
    // AUCUNE SESSION
    //==========================================================

    if (response == null) {
      if (widget.isPrimary) {
        if (selectedPeriod != null) {
          await _openPrimarySession(
            selectedPeriod!,
          );
        }
      } else {
        await _openSecondarySession();
      }

      return;
    }

    //==========================================================
    // SESSION EXISTANTE
    //==========================================================

    try {
      final result =
          await service.getSession(
        sessionId: response!.session.id,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        response = result;

        students =
            List<TeacherAttendanceStudentModel>.from(
          result.students,
        );
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e.toString());
    }
  }

  //============================================================
  // CHANGEMENT ÉLÈVE
  //============================================================

  void _updateStudent(
    TeacherAttendanceStudentModel student,
  ) {
    if (!canEdit) {
      return;
    }

    setState(() {
      final index =
          students.indexWhere(
        (item) =>
            item.enrollmentId ==
            student.enrollmentId,
      );

      if (index == -1) {
        return;
      }

      students[index] = student;
    });
  }

  //============================================================
  // COMPTEURS
  //============================================================

  int get presentCount {
    return students
        .where(
          (student) => student.isPresent,
        )
        .length;
  }

  int get absentCount {
    return students
        .where(
          (student) => student.isAbsent,
        )
        .length;
  }

  int get lateCount {
    return students
        .where(
          (student) => student.isLate,
        )
        .length;
  }

  //============================================================
  // SAUVEGARDER
  //============================================================

  Future<void> _saveAttendance() async {
    if (response == null) {
      return;
    }

    if (!canEdit) {
      _showError(
        "Cette session ne peut plus être modifiée.",
      );

      return;
    }

    setState(() {
      saving = true;
    });

    try {
      final records = students.map(
        (student) {
          return {
            "enrollment_id":
                student.enrollmentId,
            "status":
                student.status,
            "minutes_late":
                student.minutesLate,
            "remarks":
                student.remarks,
          };
        },
      ).toList();

      final result =
          await service.saveAttendance(
        sessionId:
            response!.session.id,
        records:
            records,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        response = result;

        students =
            List<TeacherAttendanceStudentModel>.from(
          result.students,
        );

        saving = false;
      });

      _showSuccess(
        "Les présences ont été enregistrées.",
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        saving = false;
      });

      _showError(e.toString());
    }
  }

  //============================================================
  // CLÔTURER
  //============================================================

  Future<void> _closeSession() async {
    if (response == null) {
      return;
    }

    if (!canEdit) {
      return;
    }

    final confirmed =
        await _confirmClose();

    if (!confirmed) {
      return;
    }

    setState(() {
      closing = true;
    });

    try {
      final result =
          await service.closeSession(
        sessionId:
            response!.session.id,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        response = result;

        students =
            List<TeacherAttendanceStudentModel>.from(
          result.students,
        );

        closing = false;
      });

      _showSuccess(
        "L'appel a été clôturé.",
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        closing = false;
      });

      _showError(e.toString());
    }
  }

  //============================================================
  // CONFIRMATION CLÔTURE
  //============================================================

  Future<bool> _confirmClose() async {
    final result =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Clôturer l'appel ?",
          ),
          content: const Text(
            "Après clôture, les présences "
            "ne pourront plus être modifiées "
            "par cet écran.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                "Annuler",
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                "Clôturer",
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  //============================================================
  // MESSAGE SUCCÈS
  //============================================================

  void _showSuccess(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
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
        backgroundColor: Colors.red,
      ),
    );
  }

  //============================================================
  // APP BAR
  //
  // Cette page est une page secondaire.
  // On utilise donc l'AppBar Flutter standard.
  //============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xff1F2937),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,

      //========================================================
      // RETOUR
      //========================================================

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
        ),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),

      //========================================================
      // TITRE
      //========================================================

      title: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? "Faire l'appel",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.isPrimary
                ? "Présence de la classe"
                : "Présence des élèves au cours",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    //==========================================================
    // CHARGEMENT
    //==========================================================

    if (loading) {
      return Scaffold(
        backgroundColor:
            AppColors.background,
        appBar: _buildAppBar(),
        body: const LoadingView(),
      );
    }

    //==========================================================
    // ERREUR
    //==========================================================

    if (error != null &&
        response == null) {
      return Scaffold(
        backgroundColor:
            AppColors.background,
        appBar: _buildAppBar(),
        body: ErrorView(
          message: error!,
          onRetry: () {
            setState(() {
              loading = true;
              error = null;
            });

            if (widget.isPrimary) {
              if (selectedPeriod != null) {
                _openPrimarySession(
                  selectedPeriod!,
                );
              } else {
                setState(() {
                  loading = false;
                });
              }
            } else {
              _openSecondarySession();
            }
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

      //========================================================
      // APP BAR SECONDAIRE
      //========================================================

      appBar: _buildAppBar(),

      //========================================================
      // CONTENU
      //========================================================

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding:
              const EdgeInsets.all(20),
          children: [
            //==================================================
            // SÉLECTEUR PRIMAIRE
            //==================================================

            if (widget.isPrimary &&
                response == null)
              AttendanceSessionSelector(
                isPrimary: true,
                selectedPeriod:
                    selectedPeriod,
                enabled:
                    !saving &&
                    !closing,
                onPeriodSelected:
                    (period) {
                  _openPrimarySession(
                    period,
                  );
                },
              ),

            if (widget.isPrimary &&
                response == null)
              const SizedBox(
                height: 20,
              ),

            //==================================================
            // INFORMATIONS SESSION
            //==================================================

            if (response != null)
              _SessionInfoCard(
                response: response!,
              ),

            if (response != null)
              const SizedBox(
                height: 20,
              ),

            //==================================================
            // RÉSUMÉ
            //==================================================

            if (response != null)
              AttendanceSummaryCard(
                total:
                    students.length,
                present:
                    presentCount,
                absent:
                    absentCount,
                late:
                    lateCount,
              ),

            if (response != null)
              const SizedBox(
                height: 20,
              ),

            //==================================================
            // LISTE DES ÉLÈVES
            //==================================================

            if (response != null &&
                students.isNotEmpty)
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Liste des élèves",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ...students.map(
                    (student) {
                      return AttendanceStudentTile(
                        student: student,
                        enabled:
                            canEdit &&
                            !saving &&
                            !closing,
                        onChanged:
                            _updateStudent,
                      );
                    },
                  ),
                ],
              ),

            //==================================================
            // AUCUN ÉLÈVE
            //==================================================

            if (response != null &&
                students.isEmpty)
              const _EmptyStudents(),

            const SizedBox(
              height: 20,
            ),

            //==================================================
            // ACTIONS
            //==================================================

            if (response != null &&
                canEdit)
              _ActionButtons(
                saving: saving,
                closing: closing,
                onSave:
                    _saveAttendance,
                onClose:
                    _closeSession,
              ),

            //==================================================
            // SESSION CLÔTURÉE
            //==================================================

            if (response != null &&
                response!.session.isClosed)
              const _ClosedBanner(),

            //==================================================
            // SESSION ANNULÉE
            //==================================================

            if (response != null &&
                response!.session.isCancelled)
              const _CancelledBanner(),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

//================================================================
// INFORMATIONS SESSION
//================================================================

class _SessionInfoCard
    extends StatelessWidget {
  final TeacherAttendanceResponseModel response;

  const _SessionInfoCard({
    required this.response,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final session =
        response.session;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration:
                BoxDecoration(
              color: session.isPrimary
                  ? Colors.green
                      .withOpacity(.10)
                  : Colors.blue
                      .withOpacity(.10),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),
            child: Icon(
              session.isPrimary
                  ? Icons.groups
                  : Icons.school,
              color: session.isPrimary
                  ? Colors.green
                  : Colors.blue,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  session.classroomName,
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  session.sessionLabel,
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration:
                BoxDecoration(
              color: session.isOpen
                  ? Colors.green
                      .withOpacity(.10)
                  : session.isClosed
                      ? Colors.grey
                          .withOpacity(.12)
                      : Colors.red
                          .withOpacity(.10),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child: Text(
              session.statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w700,
                color: session.isOpen
                    ? Colors.green
                    : session.isClosed
                        ? Colors
                            .grey.shade700
                        : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//================================================================
// ACTIONS
//================================================================

class _ActionButtons
    extends StatelessWidget {
  final bool saving;
  final bool closing;
  final VoidCallback onSave;
  final VoidCallback onClose;

  const _ActionButtons({
    required this.saving,
    required this.closing,
    required this.onSave,
    required this.onClose,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child:
              FilledButton.icon(
            onPressed:
                saving || closing
                    ? null
                    : onSave,
            icon: saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                          Colors.white,
                    ),
                  )
                : const Icon(
                    Icons
                        .save_outlined,
                  ),
            label: Text(
              saving
                  ? "Enregistrement..."
                  : "Enregistrer les présences",
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: double.infinity,
          height: 52,
          child:
              OutlinedButton.icon(
            onPressed:
                saving || closing
                    ? null
                    : onClose,
            icon: closing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons
                        .lock_outline,
                  ),
            label: Text(
              closing
                  ? "Clôture..."
                  : "Clôturer l'appel",
            ),
          ),
        ),
      ],
    );
  }
}

//================================================================
// AUCUN ÉLÈVE
//================================================================

class _EmptyStudents
    extends StatelessWidget {
  const _EmptyStudents();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.groups_outlined,
            size: 60,
            color:
                Colors.grey.shade400,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Aucun élève",
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "Aucun élève actif n'est inscrit dans cette classe.",
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

//================================================================
// SESSION CLÔTURÉE
//================================================================

class _ClosedBanner
    extends StatelessWidget {
  const _ClosedBanner();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green
            .withOpacity(.08),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.lock,
            color: Colors.green,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              "Cette session est clôturée. "
              "Les présences ne peuvent plus être modifiées.",
              style: TextStyle(
                color: Colors.green,
                fontWeight:
                    FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//================================================================
// SESSION ANNULÉE
//================================================================

class _CancelledBanner
    extends StatelessWidget {
  const _CancelledBanner();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red
            .withOpacity(.08),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.cancel_outlined,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              "Cette session a été annulée.",
              style: TextStyle(
                color: Colors.red,
                fontWeight:
                    FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}