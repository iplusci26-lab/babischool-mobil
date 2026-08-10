import 'package:flutter/material.dart';

import './models/teacher_assessment_model.dart';
import './services/teacher_assessment_service.dart';

import '../schedule/services/teacher_schedule_service.dart';
import '../schedule/models/teacher_schedule_course_model.dart';

class TeacherAssessmentForm extends StatefulWidget {
  final TeacherAssessmentModel? assessment;

  const TeacherAssessmentForm({
    super.key,
    this.assessment,
  });

  bool get isEditing => assessment != null;

  @override
  State<TeacherAssessmentForm> createState() =>
      _TeacherAssessmentFormState();
}

class _TeacherAssessmentFormState
    extends State<TeacherAssessmentForm> {
  // ============================================================
  // SERVICES
  // ============================================================

  final TeacherAssessmentService service =
      const TeacherAssessmentService();

  final TeacherScheduleService scheduleService =
      const TeacherScheduleService();

  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _maxScoreController =
      TextEditingController();

  final TextEditingController _weightController =
      TextEditingController();

  // ============================================================
  // ETAT
  // ============================================================

  bool loadingData = true;
  bool submitting = false;

  String? selectedScheduleId;

  String selectedAssessmentType = "test";
  String selectedCategory = "class";

  DateTime selectedDate = DateTime.now();

  List<TeacherScheduleCourseModel> schedules = [];

  // ============================================================
  // TYPES D'EVALUATION
  // ============================================================

  static const Map<String, String> assessmentTypes = {
    "homework": "Devoir",
    "test": "Interrogation",
    "exam": "Examen",
  };

  // ============================================================
  // CATEGORIES
  // ============================================================

  static const Map<String, String> categories = {
    "class": "Évaluation classe",
    "scheduled": "Évaluation programmée",
  };

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _initializeForm();

    if (widget.isEditing) {
      loadingData = false;
    } else {
      _loadFormData();
    }
  }

  // ============================================================
  // INITIALISATION
  // ============================================================

  void _initializeForm() {
    final assessment = widget.assessment;

    // ----------------------------------------------------------
    // CREATION
    // ----------------------------------------------------------

    if (assessment == null) {
      _maxScoreController.text = "20";
      _weightController.text = "1";
      selectedDate = DateTime.now();

      return;
    }

    // ----------------------------------------------------------
    // MODIFICATION
    // ----------------------------------------------------------

    _titleController.text = assessment.title;

    _maxScoreController.text =
        _formatNumber(assessment.maxScore);

    _weightController.text =
        assessment.weight.toString();

    selectedAssessmentType =
        assessment.assessmentType;

    selectedCategory =
        assessment.category;

    selectedDate =
        assessment.dateAssessment;
  }

  // ============================================================
  // CHARGEMENT DU PLANNING
  // ============================================================

  Future<void> _loadFormData() async {
    try {
      if (mounted) {
        setState(() {
          loadingData = true;
        });
      }

      final response =
          await scheduleService.getSchedule();

      final Map<String, TeacherScheduleCourseModel>
          uniqueSchedules = {};

      // --------------------------------------------------------
      // PARCOURIR LES JOURS
      // --------------------------------------------------------

      for (final day in response.days) {
        for (final course in day.courses) {
          final TeacherScheduleCourseModel schedule =
              course;

          final scheduleId =
              schedule.scheduleId.trim();

          if (scheduleId.isEmpty) {
            continue;
          }

          uniqueSchedules[scheduleId] = schedule;
        }
      }

      final scheduleList =
          uniqueSchedules.values.toList();

      // --------------------------------------------------------
      // TRI
      // --------------------------------------------------------

      scheduleList.sort(
        (a, b) {
          final classroomCompare =
              a.classroomName.compareTo(
            b.classroomName,
          );

          if (classroomCompare != 0) {
            return classroomCompare;
          }

          final subjectCompare =
              a.subjectName.compareTo(
            b.subjectName,
          );

          if (subjectCompare != 0) {
            return subjectCompare;
          }

          return a.startTime.compareTo(
            b.startTime,
          );
        },
      );

      if (!mounted) {
        return;
      }

      setState(() {
        schedules = scheduleList;
        loadingData = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loadingData = false;
      });

      _showError(_cleanError(e));
    }
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (submitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ----------------------------------------------------------
    // VALIDATION DU PLANNING
    // ----------------------------------------------------------

    if (!widget.isEditing) {
      if (!_validateSchedule()) {
        return;
      }
    }

    // ----------------------------------------------------------
    // NOTE MAXIMALE
    // ----------------------------------------------------------

    final maxScore = double.tryParse(
      _maxScoreController.text
          .trim()
          .replaceAll(",", "."),
    );

    if (maxScore == null || maxScore <= 0) {
      _showError(
        "La note maximale doit être supérieure à zéro.",
      );
      return;
    }

    // ----------------------------------------------------------
    // COEFFICIENT
    // ----------------------------------------------------------

    final weight = int.tryParse(
      _weightController.text.trim(),
    );

    if (weight == null || weight <= 0) {
      _showError(
        "Le coefficient doit être supérieur à zéro.",
      );
      return;
    }

    // ----------------------------------------------------------
    // SUBMIT
    // ----------------------------------------------------------

    setState(() {
      submitting = true;
    });

    try {
      late TeacherAssessmentModel result;

      // ========================================================
      // MODIFICATION
      // ========================================================

      if (widget.isEditing) {
        result = await service.updateAssessment(
          assessmentId: widget.assessment!.id,
          title: _titleController.text.trim(),
          assessmentType: selectedAssessmentType,
          maxScore: maxScore,
          weight: weight,
          category: selectedCategory,
          dateAssessment: selectedDate,
        );
      }

      // ========================================================
      // CREATION
      // ========================================================

      else {
        result = await service.createAssessment(
          scheduleId: selectedScheduleId!,
          title: _titleController.text.trim(),
          assessmentType: selectedAssessmentType,
          category: selectedCategory,
          maxScore: maxScore,
          weight: weight,
          dateAssessment: selectedDate,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        result,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        submitting = false;
      });

      _showError(_cleanError(e));
    }
  }

  // ============================================================
  // VALIDATION PLANNING
  // ============================================================

  bool _validateSchedule() {
    if (selectedScheduleId == null ||
        selectedScheduleId!.trim().isEmpty) {
      _showError(
        "Veuillez sélectionner une séance du planning.",
      );

      return false;
    }

    return true;
  }

  // ============================================================
  // DATE
  // ============================================================

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null || !mounted) {
      return;
    }

    setState(() {
      selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        selectedDate.hour,
        selectedDate.minute,
      );
    });
  }

  // ============================================================
  // ERREUR
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.startsWith("Exception: ")) {
      return message.substring(11);
    }

    return message;
  }

  // ============================================================
  // FORMATAGE
  // ============================================================

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  String _formatDate(DateTime date) {
    final day =
        date.day.toString().padLeft(2, "0");

    final month =
        date.month.toString().padLeft(2, "0");

    return "$day/$month/${date.year}";
  }

  // ============================================================
  // LABEL PLANNING
  // ============================================================

  String _scheduleLabel(
    TeacherScheduleCourseModel schedule,
  ) {
    final classroom =
        schedule.displayClassroom;

    final subject =
        schedule.subjectName;

    final period =
        schedule.period;

    return "$subject • $classroom • $period";
  }

  String _scheduleSubtitle(
    TeacherScheduleCourseModel schedule,
  ) {
    final parts = <String>[];

    if (schedule.hasRoom) {
      parts.add(
        "Salle ${schedule.room}",
      );
    }

    if (schedule.hasGroup) {
      parts.add(
        "Groupe ${schedule.groupName}",
      );
    }

    if (parts.isEmpty) {
      return "Séance pédagogique";
    }

    return parts.join(" • ");
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (loadingData) {
      return Scaffold(
        backgroundColor:
            const Color(0xffF7F8FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor:
              const Color(0xff1F2937),
          elevation: 0,
          title: Text(
            widget.isEditing
                ? "Modifier l'évaluation"
                : "Nouvelle évaluation",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xff6214BE),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xffF7F8FC),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xff1F2937),
        elevation: 0,
        title: Text(
          widget.isEditing
              ? "Modifier l'évaluation"
              : "Nouvelle évaluation",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding:
                const EdgeInsets.all(20),
            children: [
              _buildGeneralSection(),

              const SizedBox(height: 28),

              _buildTypeSection(),

              const SizedBox(height: 28),

              _buildScoringSection(),

              const SizedBox(height: 28),

              _buildDateSection(),

              const SizedBox(height: 36),

              _buildSubmitButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFORMATIONS GENERALES
  // ============================================================

  Widget _buildGeneralSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          "Informations générales",
        ),

        const SizedBox(height: 16),

        _buildTextField(
          controller: _titleController,
          label: "Titre de l'évaluation",
          hint:
              "Ex. Contrôle de mathématiques",
          icon: Icons.title,
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return "Le titre est obligatoire.";
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        // ======================================================
        // CREATION : SELECTION DE LA SEANCE
        // ======================================================

        if (!widget.isEditing)
          _buildScheduleDropdown()

        // ======================================================
        // MODIFICATION : INFORMATIONS VERROUILLEES
        // ======================================================

        else
          _buildExistingAssignmentInfo(),
      ],
    );
  }

  // ============================================================
  // SELECTION DU PLANNING
  // ============================================================

  Widget _buildScheduleDropdown() {
    final validValue =
        schedules.any(
      (schedule) =>
          schedule.scheduleId ==
          selectedScheduleId,
    )
            ? selectedScheduleId
            : null;

    return DropdownButtonFormField<String>(
      value: validValue,
      isExpanded: true,

      onChanged: (value) {
        setState(() {
          selectedScheduleId = value;
        });
      },

      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return "Veuillez sélectionner une séance.";
        }

        return null;
      },

      decoration: InputDecoration(
        labelText: "Séance pédagogique",
        hintText:
            "Sélectionnez une séance du planning",
        prefixIcon: const Icon(
          Icons.calendar_month_outlined,
          color: Color(0xff6214BE),
        ),
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Color(0xff6214BE),
            width: 1.5,
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Colors.red,
          ),
        ),
      ),

      items: schedules.map(
        (schedule) {
          return DropdownMenuItem<String>(
            value: schedule.scheduleId,

            child: Text(
              _scheduleLabel(schedule),
              overflow:
                  TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
    );
  }

  // ============================================================
  // INFORMATIONS EXISTANTES
  // ============================================================

  Widget _buildExistingAssignmentInfo() {
    final assessment =
        widget.assessment!;

    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lock_outline,
                size: 18,
                color: Colors.grey,
              ),
              SizedBox(width: 8),
              Text(
                "Affectation pédagogique",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _buildReadOnlyInfo(
            icon:
                Icons.class_outlined,
            label: "Classe",
            value:
                assessment.classroom.name,
          ),

          const SizedBox(height: 10),

          _buildReadOnlyInfo(
            icon:
                Icons.menu_book_outlined,
            label: "Matière",
            value:
                assessment.subject.name,
          ),

          const SizedBox(height: 10),

          _buildReadOnlyInfo(
            icon:
                Icons.calendar_today_outlined,
            label: "Terme",
            value:
                assessment.term.name,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATION LECTURE SEULE
  // ============================================================

  Widget _buildReadOnlyInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xff6214BE),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TYPE
  // ============================================================

  Widget _buildTypeSection() {
    final typeItems =
        assessmentTypes.entries
            .map(
              (entry) => {
                "id": entry.key,
                "name": entry.value,
              },
            )
            .toList();

    final categoryItems =
        categories.entries
            .map(
              (entry) => {
                "id": entry.key,
                "name": entry.value,
              },
            )
            .toList();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          "Type d'évaluation",
        ),

        const SizedBox(height: 16),

        _buildDropdown(
          label: "Type",
          icon:
              Icons.assignment_outlined,
          value:
              selectedAssessmentType,
          items: typeItems,
          enabled: true,
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              selectedAssessmentType =
                  value;
            });
          },
        ),

        const SizedBox(height: 16),

        _buildDropdown(
          label: "Catégorie",
          icon:
              Icons.category_outlined,
          value: selectedCategory,
          items: categoryItems,
          enabled: true,
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              selectedCategory = value;
            });
          },
        ),
      ],
    );
  }

  // ============================================================
  // NOTATION
  // ============================================================

  Widget _buildScoringSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionTitle("Notation"),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller:
                    _maxScoreController,
                label: "Note maximale",
                hint: "Ex. 20",
                icon:
                    Icons.score_outlined,
                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final score =
                      double.tryParse(
                    value
                            ?.trim()
                            .replaceAll(
                              ",",
                              ".",
                            ) ??
                        "",
                  );

                  if (score == null ||
                      score <= 0) {
                    return "Invalide";
                  }

                  return null;
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: _buildTextField(
                controller:
                    _weightController,
                label: "Coefficient",
                hint: "Ex. 1",
                icon:
                    Icons.balance_outlined,
                keyboardType:
                    TextInputType.number,
                validator: (value) {
                  final weight =
                      int.tryParse(
                    value?.trim() ?? "",
                  );

                  if (weight == null ||
                      weight <= 0) {
                    return "Invalide";
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // DATE
  // ============================================================

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          "Date de l'évaluation",
        ),

        const SizedBox(height: 16),

        InkWell(
          onTap: _selectDate,
          borderRadius:
              BorderRadius.circular(16),

          child: Container(
            padding:
                const EdgeInsets.all(16),

            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(16),
              border: Border.all(
                color:
                    Colors.grey.shade300,
              ),
            ),

            child: Row(
              children: [
                const Icon(
                  Icons
                      .calendar_today_outlined,
                  color:
                      Color(0xff6214BE),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors
                              .grey.shade600,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        _formatDate(
                          selectedDate,
                        ),
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOUTON SUBMIT
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed:
            submitting ? null : _submit,

        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xff6214BE),
          foregroundColor:
              Colors.white,
          disabledBackgroundColor:
              Colors.grey.shade400,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),

        child: submitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                widget.isEditing
                    ? "Enregistrer les modifications"
                    : "Créer l'évaluation",
                style:
                    const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xff1F2937),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController
        controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: Icon(
          icon,
          color:
              const Color(0xff6214BE),
        ),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Color(0xff6214BE),
            width: 1.5,
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN GENERIQUE
  // ============================================================

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<Map<String, dynamic>>
        items,
    required bool enabled,
    required ValueChanged<String?>
        onChanged,
  }) {
    final validValue =
        items.any(
      (item) =>
          item["id"]?.toString() ==
          value,
    )
            ? value
            : null;

    return DropdownButtonFormField<
        String>(
      value: validValue,
      isExpanded: true,

      onChanged:
          enabled ? onChanged : null,

      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return "Ce champ est obligatoire.";
        }

        return null;
      },

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(
          icon,
          color:
              const Color(0xff6214BE),
        ),

        filled: true,

        fillColor: enabled
            ? Colors.white
            : Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Color(0xff6214BE),
            width: 1.5,
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Colors.red,
          ),
        ),
      ),

      items: items.map(
        (item) {
          final id =
              item["id"]?.toString() ??
                  "";

          final name =
              item["name"]?.toString() ??
                  "";

          return DropdownMenuItem<
              String>(
            value: id,

            child: Text(
              name,
              overflow:
                  TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _titleController.dispose();
    _maxScoreController.dispose();
    _weightController.dispose();

    super.dispose();
  }
}