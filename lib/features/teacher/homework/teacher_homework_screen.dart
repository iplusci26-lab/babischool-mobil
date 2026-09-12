import 'package:flutter/material.dart';

import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';

import './models/teacher_homework_model.dart';
import './services/teacher_homework_service.dart';
import 'teacher_homework_form.dart';

class TeacherHomeworkScreen extends StatefulWidget {
  final String scheduleId;

  const TeacherHomeworkScreen({
    super.key,
    required this.scheduleId,
  });

  @override
  State<TeacherHomeworkScreen> createState() =>
      _TeacherHomeworkScreenState();
}

class _TeacherHomeworkScreenState
    extends State<TeacherHomeworkScreen> {
  final TeacherHomeworkService service =
      const TeacherHomeworkService();

  TeacherHomeworkResponseModel? response;

  bool loading = true;
  String? error;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ==========================================================
  // CHARGEMENT
  // ==========================================================

  Future<void> loadData() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

      final data =
          await service.getHomeworks(
        widget.scheduleId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        response = data;
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

  // ==========================================================
  // CREATION
  // ==========================================================

  Future<void> _createHomework() async {
    final result =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TeacherHomeworkForm(
          scheduleId:
              widget.scheduleId,
        ),
      ),
    );

    if (result == true) {
      await loadData();
    }
  }

  // ==========================================================
  // MODIFICATION
  // ==========================================================

  Future<void> _editHomework(
    TeacherHomeworkModel homework,
  ) async {
    final result =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TeacherHomeworkForm(
          scheduleId:
              widget.scheduleId,
          homework:
              homework,
        ),
      ),
    );

    if (result == true) {
      await loadData();
    }
  }

  // ==========================================================
  // SUPPRESSION
  // ==========================================================

  Future<void> _deleteHomework(
    TeacherHomeworkModel homework,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title:
              const Text("Supprimer le devoir ?"),

          content: Text(
            "Le devoir « ${homework.title} » "
            "sera définitivement supprimé.",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child:
                  const Text("Annuler"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text("Supprimer"),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await service.deleteHomework(
        homework.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Devoir supprimé."),
        ),
      );

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(
        "Impossible de supprimer le devoir.",
      );
    }
  }

  // ==========================================================
  // ERREUR
  // ==========================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingView();
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title:
              const Text("Exercices"),
        ),

        body: ErrorView(
          message: error!,
          onRetry: loadData,
        ),
      );
    }

    final data = response!;

    return Scaffold(
      backgroundColor:
          const Color(0xffF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xff1F2937),
        elevation: 0,

        title:
            const Text("Exercices"),

        actions: [
          IconButton(
            onPressed: loadData,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            _createHomework,

        backgroundColor:
            const Color(0xff6214BE),

        foregroundColor:
            Colors.white,

        icon:
            const Icon(Icons.add),

        label:
            const Text("Nouveau devoir"),
      ),

      body: RefreshIndicator(
        onRefresh: loadData,

        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding:
              const EdgeInsets.all(20),

          children: [
            // ==================================================
            // COURS
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(20),

              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  22,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset:
                        Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xff6214BE,
                      ).withOpacity(.10),

                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),

                    child:
                        const Icon(
                      Icons.assignment,
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
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          data.schedule
                              .classroom,

                          style:
                              const TextStyle(
                            fontSize: 19,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          data.schedule
                              .subject,

                          style: TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // ==================================================
            // STATISTIQUE
            // ==================================================

            Row(
              children: [
                Expanded(
                  child:
                      _StatCard(
                    icon:
                        Icons.assignment,
                    title:
                        "Exercice(s)",
                    value:
                        data.homeworks
                            .length
                            .toString(),
                    color:
                        Colors.deepPurple,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child:
                      _StatCard(
                    icon:
                        Icons.schedule,
                    title:
                        "À venir",
                    value:
                        data.homeworks
                            .where(
                              (homework) =>
                                  !homework
                                      .isOverdue,
                            )
                            .length
                            .toString(),
                    color:
                        Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 28,
            ),

            // ==================================================
            // TITRE
            // ==================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [
                const Text(
                  "Mes Exercices",

                  style:
                      TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(
                  "${data.homeworks.length}",

                  style:
                      TextStyle(
                    color:
                        Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            // ==================================================
            // VIDE
            // ==================================================

            if (data.homeworks.isEmpty)
              _EmptyHomework(
                onCreate:
                    _createHomework,
              )

            // ==================================================
            // LISTE
            // ==================================================

            else
              ...data.homeworks.map(
                (homework) =>
                    _HomeworkCard(
                  homework:
                      homework,

                  onEdit: () =>
                      _editHomework(
                    homework,
                  ),

                  onDelete: () =>
                      _deleteHomework(
                    homework,
                  ),
                ),
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

// ============================================================
// STAT CARD
// ============================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),

          const SizedBox(
            width: 12,
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                value,

                style:
                    const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                title,

                style:
                    TextStyle(
                  color:
                      Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOMEWORK CARD
// ============================================================

class _HomeworkCard
    extends StatelessWidget {
  final TeacherHomeworkModel homework;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HomeworkCard({
    required this.homework,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        homework.isOverdue
            ? Colors.red
            : homework.isDueToday
                ? Colors.orange
                : Colors.green;

    final String statusText =
        homework.isOverdue
            ? "En retard"
            : homework.isDueToday
                ? "À rendre aujourd'hui"
                : "À venir";

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset:
                Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ==================================================
          // HEADER
          // ==================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Text(
                  homework.title,

                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              PopupMenuButton<
                  String>(
                onSelected: (value) {
                  if (value == "edit") {
                    onEdit();
                  }

                  if (value == "delete") {
                    onDelete();
                  }
                },

                itemBuilder:
                    (context) => [
                  const PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Modifier"),
                      ],
                    ),
                  ),

                  const PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Supprimer"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          // ==================================================
          // DESCRIPTION
          // ==================================================

          Text(
            homework.description,

            maxLines: 4,

            overflow:
                TextOverflow.ellipsis,

            style: TextStyle(
              color:
                  Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          // ==================================================
          // DATE + STATUT
          // ==================================================

          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 17,
                color:
                    Color(0xff6214BE),
              ),

              const SizedBox(
                width: 7,
              ),

              Text(
                "À rendre le ${homework.dueDateLabel}",

                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          Wrap(
            spacing: 8,
            runSpacing: 8,

            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color: statusColor
                      .withOpacity(.10),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(
                  statusText,

                  style: TextStyle(
                    color:
                        statusColor,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              if (homework.published)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration:
                      BoxDecoration(
                    color: Colors.green
                        .withOpacity(.10),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: const Text(
                    "Publié",

                    style:
                        TextStyle(
                      color:
                          Colors.green,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

              if (homework.hasAttachment)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration:
                      BoxDecoration(
                    color: Colors.blue
                        .withOpacity(.10),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: const Row(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.attach_file,
                        size: 14,
                        color:
                            Colors.blue,
                      ),

                      SizedBox(
                        width: 4,
                      ),

                      Text(
                        "Pièce jointe",

                        style:
                            TextStyle(
                          color:
                              Colors.blue,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EMPTY
// ============================================================

class _EmptyHomework
    extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyHomework({
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 45,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          const Icon(
            Icons.assignment_outlined,
            size: 60,
            color:
                Color(0xff6214BE),
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            "Aucun devoir",

            style:
                TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            "Vous n'avez encore créé "
            "aucun devoir pour ce cours.",

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          ElevatedButton.icon(
            onPressed: onCreate,

            icon:
                const Icon(Icons.add),

            label:
                const Text(
              "Créer un devoir",
            ),

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                0xff6214BE,
              ),

              foregroundColor:
                  Colors.white,

              elevation: 0,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}