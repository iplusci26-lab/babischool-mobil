import 'package:flutter/material.dart';

import 'models/assessment_model.dart';
import 'services/teacher_assessments_service.dart';

class CreateAssessmentScreen extends StatefulWidget {

  final String scheduleId;

  final TeacherAssessmentModel? assessment;

  const CreateAssessmentScreen({

    super.key,

    required this.scheduleId,

    this.assessment,

  });

  @override
  State<CreateAssessmentScreen> createState() =>
      _CreateAssessmentScreenState();

}

class _CreateAssessmentScreenState
    extends State<CreateAssessmentScreen> {

  final _formKey = GlobalKey<FormState>();

  final _titleController =
      TextEditingController();

  final _maxScoreController =
      TextEditingController();

  final _weightController =
      TextEditingController();

  final TeacherAssessmentsService _service =
      TeacherAssessmentsService();

  String _type = "test";

  DateTime _date = DateTime.now();

  bool saving = false;

  bool get editing =>
      widget.assessment != null;

  @override
  void initState() {

    super.initState();

    if (editing) {

      final a = widget.assessment!;

      _titleController.text = a.title;

      _maxScoreController.text =
          a.maxScore.toString();

      _weightController.text =
          a.weight.toString();

      _type = a.type;

      _date = a.dateAssessment;

    }

  }

  @override
  void dispose() {

    _titleController.dispose();

    _maxScoreController.dispose();

    _weightController.dispose();

    super.dispose();

  }

  Future<void> save() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      saving = true;
    });

    try {

      final data = {

        "title": _titleController.text.trim(),

        "assessment_type": _type,

        "date_assessment":
            _date.toIso8601String(),

        "max_score": double.parse(
          _maxScoreController.text,
        ),

        "weight": int.parse(
          _weightController.text,
        ),

      };

      if (editing) {

        await _service.updateAssessment(

          widget.assessment!.id,

          data,

        );

      } else {

        await _service.createAssessment(

          widget.scheduleId,

          data,

        );

      }

      if (!mounted) return;

      Navigator.pop(context, true);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

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

  Future<void> pickDate() async {

    final result = await showDatePicker(

      context: context,

      initialDate: _date,

      firstDate: DateTime.now(),

      lastDate: DateTime(2100),

    );

    if (result == null) return;

    setState(() {

      _date = result;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(

          editing

              ? "Modifier"

              : "Nouvelle évaluation",

        ),

      ),

      floatingActionButton:

          FloatingActionButton.extended(

        onPressed:

            saving ? null : save,

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

      body: Form(

        key: _formKey,

        child: ListView(

          padding:
              const EdgeInsets.all(20),

          children: [

            TextFormField(

              controller:
                  _titleController,

              decoration:
                  const InputDecoration(

                labelText: "Titre",

              ),

              validator: (v) {

                if (v == null ||
                    v.trim().isEmpty) {

                  return "Obligatoire";

                }

                return null;

              },

            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(

              value: _type,

              decoration:
                  const InputDecoration(

                labelText: "Type",

              ),

              items: const [

                DropdownMenuItem(

                  value: "homework",

                  child: Text("Devoir"),

                ),

                DropdownMenuItem(

                  value: "test",

                  child: Text("Interrogation"),

                ),

                DropdownMenuItem(

                  value: "exam",

                  child: Text("Examen"),

                ),

              ],

              onChanged: (v) {

                setState(() {

                  _type = v!;

                });

              },

            ),

            const SizedBox(height: 18),

            TextFormField(

              controller:
                  _maxScoreController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(

                labelText: "Barème",

              ),

            ),

            const SizedBox(height: 18),

            TextFormField(

              controller:
                  _weightController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(

                labelText: "Coefficient",

              ),

            ),

            const SizedBox(height: 18),

            ListTile(

              contentPadding:
                  EdgeInsets.zero,

              leading: const Icon(

                Icons.calendar_today,

              ),

              title: Text(

                "${_date.day}/${_date.month}/${_date.year}",

              ),

              trailing: const Icon(

                Icons.chevron_right,

              ),

              onTap: pickDate,

            ),

          ],

        ),

      ),

    );

  }

}