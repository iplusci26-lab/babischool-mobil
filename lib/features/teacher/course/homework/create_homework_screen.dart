import 'package:flutter/material.dart';

import 'models/teacher_homework_model.dart';
import 'services/teacher_homeworks_service.dart';

class CreateHomeworkScreen extends StatefulWidget {

  final String scheduleId;

  final TeacherHomeworkModel? homework;

  const CreateHomeworkScreen({

    super.key,

    required this.scheduleId,

    this.homework,

  });

  @override
  State<CreateHomeworkScreen> createState() =>
      _CreateHomeworkScreenState();

}

class _CreateHomeworkScreenState
    extends State<CreateHomeworkScreen> {

  final _formKey = GlobalKey<FormState>();

  final _titleController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  final TeacherHomeworksService _service =
      TeacherHomeworksService();

  DateTime _dueDate = DateTime.now();

  bool saving = false;

  bool get editing =>
      widget.homework != null;

  @override
  void initState() {

    super.initState();

    if (editing) {

      final homework = widget.homework!;

      _titleController.text =
          homework.title;

      _descriptionController.text =
          homework.description;

      _dueDate = homework.dueDate;

    }

  }

  @override
  void dispose() {

    _titleController.dispose();

    _descriptionController.dispose();

    super.dispose();

  }

  //------------------------------------------------------
  // DATE
  //------------------------------------------------------

  Future<void> pickDate() async {

    final date = await showDatePicker(

      context: context,

      initialDate: _dueDate,

      firstDate: DateTime.now(),

      lastDate: DateTime(2100),

    );

    if (date == null) return;

    setState(() {

      _dueDate = date;

    });

  }

  //------------------------------------------------------
  // SAVE
  //------------------------------------------------------

  Future<void> save() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {

      saving = true;

    });

    final data = {

      "title":
          _titleController.text.trim(),

      "description":
          _descriptionController.text.trim(),

      "due_date":
          _dueDate.toIso8601String(),

    };

    try {

      if (editing) {

        await _service.updateHomework(

          widget.homework!.id,

          data,

        );

      } else {

        await _service.createHomework(

          widget.scheduleId,

          data,

        );

      }

      if (!mounted) return;

      Navigator.pop(

        context,

        true,

      );

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

  //------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(

          editing

              ? "Modifier le devoir"

              : "Nouveau devoir",

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

            //------------------------------------------------
            // TITRE
            //------------------------------------------------

            TextFormField(

              controller:
                  _titleController,

              decoration:
                  const InputDecoration(

                labelText:
                    "Titre du devoir",

              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return "Titre obligatoire";

                }

                return null;

              },

            ),

            const SizedBox(
              height: 18,
            ),

            //------------------------------------------------
            // DESCRIPTION
            //------------------------------------------------

            TextFormField(

              controller:
                  _descriptionController,

              maxLines: 5,

              decoration:
                  const InputDecoration(

                labelText:
                    "Description",

                alignLabelWithHint: true,

              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return "Description obligatoire";

                }

                return null;

              },

            ),

            const SizedBox(
              height: 18,
            ),

            //------------------------------------------------
            // DATE
            //------------------------------------------------

            ListTile(

              contentPadding:
                  EdgeInsets.zero,

              leading: const Icon(

                Icons.calendar_today,

              ),

              title: Text(

                "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}",

              ),

              trailing: const Icon(

                Icons.chevron_right,

              ),

              onTap: pickDate,

            ),

            const SizedBox(
              height: 100,
            ),

          ],

        ),

      ),

    );

  }

}