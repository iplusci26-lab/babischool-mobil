import 'package:flutter/material.dart';

import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';

import 'create_homework_screen.dart';

import 'models/teacher_homeworks_response_model.dart';
import 'models/teacher_homework_model.dart';

import 'services/teacher_homeworks_service.dart';

import 'widgets/teacher_homework_card.dart';
import 'widgets/teacher_homeworks_summary_card.dart';

class TeacherHomeworksScreen extends StatefulWidget {

  final String scheduleId;

  const TeacherHomeworksScreen({

    super.key,

    required this.scheduleId,

  });

  @override
  State<TeacherHomeworksScreen> createState() =>
      _TeacherHomeworksScreenState();

}

class _TeacherHomeworksScreenState
    extends State<TeacherHomeworksScreen> {

  final TeacherHomeworksService _service =
      TeacherHomeworksService();

  TeacherHomeworksResponse? response;

  bool loading = true;

  String? error;

  //------------------------------------------------------
  // LOAD
  //------------------------------------------------------

  Future<void> loadData() async {

    try {

      error = null;

      response = await _service.getHomeworks(

        widget.scheduleId,

      );

    } catch (e) {

      error = e.toString();

    }

    if (!mounted) return;

    setState(() {

      loading = false;

    });

  }

  //------------------------------------------------------
  // DELETE
  //------------------------------------------------------

  Future<void> deleteHomework(
    String id,
  ) async {

    final confirm = await showDialog<bool>(

      context: context,

      builder: (_) {

        return AlertDialog(

          title: const Text(
            "Supprimer",
          ),

          content: const Text(
            "Supprimer ce devoir ?",
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
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
                  context,
                  true,
                );

              },

              child: const Text(
                "Supprimer",
              ),

            ),

          ],

        );

      },

    );

    if (confirm != true) return;

    await _service.deleteHomework(id);

    loadData();

  }

  //------------------------------------------------------

  @override
  void initState() {

    super.initState();

    loadData();

  }

  //------------------------------------------------------

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

    final homeworks =
        response!.homeworks;

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Devoirs",
        ),

      ),

      floatingActionButton:

          FloatingActionButton.extended(

        onPressed: () async {

          final created =

              await Navigator.push<bool>(

            context,

            MaterialPageRoute(

              builder: (_) =>

                  CreateHomeworkScreen(

                scheduleId:

                    widget.scheduleId,

              ),

            ),

          );

          if (created == true) {

            loadData();

          }

        },

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          "Créer",
        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadData,

        child: ListView(

          padding: const EdgeInsets.all(20),

          children: [

            TeacherHomeworksSummaryCard(

              classroom:
                  response!.classroom,

              subject:
                  response!.subject,

              total:
                  homeworks.length,

            ),

            const SizedBox(
              height: 24,
            ),

            ...homeworks.map(

              (TeacherHomeworkModel homework) {

                return Padding(

                  padding:
                      const EdgeInsets.only(

                    bottom: 18,

                  ),

                  child: TeacherHomeworkCard(

                    homework: homework,

                    onEdit: () async {

                      final updated =

                          await Navigator.push<bool>(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>

                              CreateHomeworkScreen(

                            scheduleId:

                                widget.scheduleId,

                            homework:

                                homework,

                          ),

                        ),

                      );

                      if (updated == true) {

                        loadData();

                      }

                    },

                    onDelete: () {

                      deleteHomework(

                        homework.id,

                      );

                    },

                  ),

                );

              },

            ),

            const SizedBox(

              height: 90,

            ),

          ],

        ),

      ),

    );

  }

}