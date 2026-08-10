import 'package:flutter/material.dart';

import './models/teacher_homework_model.dart';
import './services/teacher_homework_service.dart';

class TeacherHomeworkForm extends StatefulWidget {
  final String scheduleId;
  final TeacherHomeworkModel? homework;

  const TeacherHomeworkForm({
    super.key,
    required this.scheduleId,
    this.homework,
  });

  bool get isEditing => homework != null;

  @override
  State<TeacherHomeworkForm> createState() =>
      _TeacherHomeworkFormState();
}

class _TeacherHomeworkFormState
    extends State<TeacherHomeworkForm> {
  final TeacherHomeworkService service =
      const TeacherHomeworkService();

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  DateTime? dueDate;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    final homework = widget.homework;

    titleController = TextEditingController(
      text: homework?.title ?? "",
    );

    descriptionController = TextEditingController(
      text: homework?.description ?? "",
    );

    dueDate = homework?.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  // ==========================================================
  // DATE
  // ==========================================================

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate:
          dueDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(
        now.year + 2,
        12,
        31,
      ),
      helpText: "Date de rendu du devoir",
      cancelText: "Annuler",
      confirmText: "Valider",
    );

    if (selected == null) {
      return;
    }

    setState(() {
      dueDate = selected;
    });
  }

  // ==========================================================
  // ENREGISTREMENT
  // ==========================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (dueDate == null) {
      _showError(
        "Veuillez sélectionner une date de rendu.",
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      if (widget.isEditing) {
        await service.updateHomework(
          homeworkId: widget.homework!.id,
          title: titleController.text,
          description: descriptionController.text,
          dueDate: dueDate!,
        );
      } else {
        await service.createHomework(
          scheduleId: widget.scheduleId,
          title: titleController.text,
          description: descriptionController.text,
          dueDate: dueDate!,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(
        _extractError(e),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  // ==========================================================
  // ERREUR
  // ==========================================================

  String _extractError(Object error) {
    final text = error.toString();

    if (text.contains("Le titre")) {
      return "Le titre du devoir est obligatoire.";
    }

    if (text.contains("description")) {
      return "La description du devoir est obligatoire.";
    }

    if (text.contains("matière")) {
      return "Aucune matière n'est associée à ce cours.";
    }

    return "Impossible d'enregistrer le devoir.";
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ==========================================================
  // DATE LABEL
  // ==========================================================

  String get dateLabel {
    if (dueDate == null) {
      return "Sélectionner une date";
    }

    return "${dueDate!.day.toString().padLeft(2, '0')}/"
        "${dueDate!.month.toString().padLeft(2, '0')}/"
        "${dueDate!.year}";
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF7F8FC),

      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? "Modifier le devoir"
              : "Nouveau devoir",
        ),
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xff1F2937),
        elevation: 0,
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: ListView(
            padding: const EdgeInsets.all(20),

            children: [
              // ==================================================
              // TITRE
              // ==================================================

              const Text(
                "Titre",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: titleController,
                textInputAction:
                    TextInputAction.next,
                maxLength: 255,

                decoration:
                    _inputDecoration(
                  hint: "Ex. Exercices de mathématiques",
                  icon: Icons.title,
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Le titre est obligatoire.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // DESCRIPTION
              // ==================================================

              const Text(
                "Consignes",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    descriptionController,

                maxLines: 6,

                decoration:
                    _inputDecoration(
                  hint:
                      "Décrivez le travail demandé...",
                  icon: Icons.description_outlined,
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "La description est obligatoire.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ==================================================
              // DATE
              // ==================================================

              const Text(
                "Date de rendu",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap:
                    saving ? null : _selectDate,

                borderRadius:
                    BorderRadius.circular(16),

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),

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
                        Icons.calendar_today,
                        color:
                            Color(0xff6214BE),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 16,
                            color: dueDate == null
                                ? Colors.grey.shade600
                                : const Color(
                                    0xff1F2937,
                                  ),
                          ),
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

              const SizedBox(height: 32),

              // ==================================================
              // BOUTON
              // ==================================================

              SizedBox(
                height: 54,

                child: ElevatedButton(
                  onPressed:
                      saving ? null : _submit,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xff6214BE),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),

                  child: saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                Colors.white,
                          ),
                        )
                      : Text(
                          widget.isEditing
                              ? "Enregistrer les modifications"
                              : "Créer le devoir",
                          style:
                              const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // INPUT
  // ==========================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(icon),

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
          color: Colors.grey.shade200,
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xff6214BE),
          width: 1.5,
        ),
      ),
    );
  }
}