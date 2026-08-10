import 'package:flutter/material.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

import 'models/teacher_assessment_model.dart';
import 'services/teacher_assessment_service.dart';
import 'teacher_assessment_form.dart';
import 'teacher_assessment_grades_screen.dart';

class TeacherAssessmentScreen extends StatefulWidget {
  const TeacherAssessmentScreen({
    super.key,
  });

  @override
  State<TeacherAssessmentScreen> createState() =>
      _TeacherAssessmentScreenState();
}

class _TeacherAssessmentScreenState
    extends State<TeacherAssessmentScreen> {
  final TeacherAssessmentService service =
      const TeacherAssessmentService();

  //============================================================
  // ETAT
  //============================================================

  List<TeacherAssessmentModel> assessments = [];

  bool loading = true;

  String? error;

  String searchQuery = "";

  String selectedStatus = "all";

  //============================================================
  // CHARGEMENT
  //============================================================

  Future<void> loadData() async {
    try {
      if (mounted) {
        setState(() {
          error = null;
          loading = true;
        });
      }

      final data = await service.getAssessments();

      if (!mounted) {
        return;
      }

      setState(() {
        assessments = data;
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
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    loadData();
  }

  //============================================================
  // RECHERCHE
  //============================================================

  void onSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim().toLowerCase();
    });
  }

  //============================================================
  // FILTRE
  //============================================================

  void onStatusChanged(String status) {
    setState(() {
      selectedStatus = status;
    });
  }

  //============================================================
  // LISTE FILTREE
  //============================================================

  List<TeacherAssessmentModel> get filteredAssessments {
    return assessments.where(
      (assessment) {
        final matchesSearch =
            searchQuery.isEmpty ||
            assessment.title
                .toLowerCase()
                .contains(searchQuery) ||
            assessment.classroom.name
                .toLowerCase()
                .contains(searchQuery) ||
            assessment.subject.name
                .toLowerCase()
                .contains(searchQuery);

        if (!matchesSearch) {
          return false;
        }

        if (selectedStatus == "all") {
          return true;
        }

        return assessment.status == selectedStatus;
      },
    ).toList();
  }

  //============================================================
  // CREATION
  //============================================================

  Future<void> openCreateForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeacherAssessmentForm(),
      ),
    );

    if (result == true) {
      await loadData();
    }
  }

  //============================================================
  // OUVRIR EVALUATION
  //============================================================

  Future<void> openAssessment(
    TeacherAssessmentModel assessment,
  ) async {
    await _showAssessmentActions(assessment);
  }

  //============================================================
  // SAISIE DES NOTES
  //============================================================

  Future<void> _openGrades(
    TeacherAssessmentModel assessment,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherAssessmentGradesScreen(
          assessmentId: assessment.id,
        ),
      ),
    );

    if (result == true) {
      await loadData();
    }
  }

  //============================================================
  // MODIFICATION
  //============================================================

  Future<void> _openEditForm(
    TeacherAssessmentModel assessment,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherAssessmentForm(
          assessment: assessment,
        ),
      ),
    );

    if (result == true) {
      await loadData();
    }
  }

  //============================================================
  // ACTIONS
  //============================================================

  Future<void> _showAssessmentActions(
    TeacherAssessmentModel assessment,
  ) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //================================================
                // ENTETE
                //================================================

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    assessment.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${assessment.classroom.name} • "
                    "${assessment.subject.name}",
                  ),
                ),

                const SizedBox(height: 10),

                //================================================
                // SAISIE DES NOTES
                //================================================

                _ActionTile(
                  icon: Icons.edit_note_rounded,
                  title: "Saisir les notes",
                  subtitle:
                      "Enregistrer les notes des élèves",
                  color: const Color(0xff6214BE),
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    await _openGrades(assessment);
                  },
                ),

                //================================================
                // MODIFICATION
                //================================================

                if (assessment.canEdit)
                  _ActionTile(
                    icon: Icons.edit_rounded,
                    title: "Modifier",
                    subtitle: "Modifier l'évaluation",
                    color: Colors.indigo,
                    onTap: () async {
                      Navigator.pop(sheetContext);

                      await _openEditForm(assessment);
                    },
                  ),

                //================================================
                // PRETE A PUBLIER
                //================================================

                if (assessment.canMarkReady)
                  _ActionTile(
                    icon: Icons.check_circle_outline,
                    title: "Marquer comme prête",
                    subtitle:
                        "Terminer la saisie des notes",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(sheetContext);

                      _markReady(assessment);
                    },
                  ),

                //================================================
                // PUBLICATION
                //================================================

                if (assessment.isReady)
                  _ActionTile(
                    icon: Icons.publish_rounded,
                    title: "Publier",
                    subtitle:
                        "Publier les résultats aux élèves",
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(sheetContext);

                      _publish(assessment);
                    },
                  ),

                //================================================
                // REPUBLICATION
                //================================================

                if (assessment.requiresRepublish)
                  _ActionTile(
                    icon: Icons.refresh_rounded,
                    title: "Republier",
                    subtitle:
                        "Publier à nouveau les résultats",
                    color: Colors.deepOrange,
                    onTap: () {
                      Navigator.pop(sheetContext);

                      _republish(assessment);
                    },
                  ),

                //================================================
                // SUPPRESSION
                //================================================

                if (assessment.canDelete)
                  _ActionTile(
                    icon: Icons.delete_outline_rounded,
                    title: "Supprimer",
                    subtitle:
                        "Supprimer cette évaluation",
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(sheetContext);

                      _confirmDelete(assessment);
                    },
                  ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  //============================================================
  // MARQUER READY
  //============================================================

  Future<void> _markReady(
    TeacherAssessmentModel assessment,
  ) async {
    try {
      await service.markReady(
        assessment.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Évaluation prête à être publiée.",
          ),
        ),
      );

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e.toString());
    }
  }

  //============================================================
  // PUBLIER
  //============================================================

  Future<void> _publish(
    TeacherAssessmentModel assessment,
  ) async {
    try {
      await service.publish(
        assessment.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Évaluation publiée avec succès.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e.toString());
    }
  }

  //============================================================
  // REPUBLIER
  //============================================================

  Future<void> _republish(
    TeacherAssessmentModel assessment,
  ) async {
    try {
      await service.republish(
        assessment.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Évaluation republiée avec succès.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e.toString());
    }
  }

  //============================================================
  // SUPPRESSION
  //============================================================

  Future<void> _confirmDelete(
    TeacherAssessmentModel assessment,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Supprimer l'évaluation ?",
          ),
          content: Text(
            "L'évaluation « ${assessment.title} » "
            "sera définitivement supprimée.",
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
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
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

    if (confirmed != true) {
      return;
    }

    try {
      await service.deleteAssessment(
        assessment.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Évaluation supprimée.",
          ),
        ),
      );

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e.toString());
    }
  }

  //============================================================
  // ERREUR
  //============================================================

  void _showError(
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
    if (loading && assessments.isEmpty) {
      return const LoadingView();
    }

    if (error != null && assessments.isEmpty) {
      return ErrorView(
        message: error!,
        onRetry: loadData,
      );
    }

    final items = filteredAssessments;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      //========================================================
      // APP BAR
      //========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: const BackButton(),
        title: const Text(
          "Évaluations",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      //========================================================
      // FAB
      //========================================================

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: const Color(0xff6214BE),
        foregroundColor: Colors.white,
        onPressed: openCreateForm,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          "Nouvelle évaluation",
        ),
      ),

      //========================================================
      // BODY
      //========================================================

      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            //==================================================
            // INTRODUCTION
            //==================================================

            const Text(
              "Gérez vos évaluations",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Créez et gérez les évaluations de vos classes.",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            //==================================================
            // STATISTIQUES
            //==================================================

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon:
                        Icons.assignment_outlined,
                    title: "Évaluations",
                    value:
                        assessments.length.toString(),
                    color:
                        const Color(0xff6214BE),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _StatCard(
                    icon:
                        Icons.publish_outlined,
                    title: "Publiées",
                    value: assessments
                        .where(
                          (a) => a.isPublished,
                        )
                        .length
                        .toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            //==================================================
            // RECHERCHE
            //==================================================

            TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText:
                    "Rechercher une évaluation...",
                prefixIcon:
                    const Icon(Icons.search),
                suffixIcon:
                    searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                searchQuery = "";
                              });
                            },
                            icon:
                                const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            //==================================================
            // FILTRES
            //==================================================

            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child: Row(
                children: [
                  _StatusFilter(
                    label: "Toutes",
                    value: "all",
                    selected:
                        selectedStatus == "all",
                    onTap:
                        onStatusChanged,
                  ),
                  _StatusFilter(
                    label: "Brouillons",
                    value: "draft",
                    selected:
                        selectedStatus == "draft",
                    onTap:
                        onStatusChanged,
                  ),
                  _StatusFilter(
                    label: "En saisie",
                    value: "in_progress",
                    selected:
                        selectedStatus ==
                            "in_progress",
                    onTap:
                        onStatusChanged,
                  ),
                  _StatusFilter(
                    label: "Prêtes",
                    value: "ready",
                    selected:
                        selectedStatus == "ready",
                    onTap:
                        onStatusChanged,
                  ),
                  _StatusFilter(
                    label: "Publiées",
                    value: "published",
                    selected:
                        selectedStatus ==
                            "published",
                    onTap:
                        onStatusChanged,
                  ),
                  _StatusFilter(
                    label: "À republier",
                    value:
                        "republish_required",
                    selected:
                        selectedStatus ==
                            "republish_required",
                    onTap:
                        onStatusChanged,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            //==================================================
            // TITRE
            //==================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mes évaluations",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                Text(
                  items.length.toString(),
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            //==================================================
            // LISTE
            //==================================================

            if (items.isEmpty)
              _EmptyAssessmentView(
                searchQuery: searchQuery,
              )
            else
              ...items.map(
                (assessment) {
                  return _AssessmentCard(
                    assessment: assessment,
                    onTap: () {
                      openAssessment(
                        assessment,
                      );
                    },
                  );
                },
              ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

//================================================================
// STAT CARD
//================================================================

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
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:
                  color.withOpacity(.10),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//================================================================
// FILTRE
//================================================================

class _StatusFilter
    extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final ValueChanged<String> onTap;

  const _StatusFilter({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          onTap(value);
        },
        selectedColor:
            const Color(0xff6214BE)
                .withOpacity(.15),
        labelStyle: TextStyle(
          color: selected
              ? const Color(0xff6214BE)
              : Colors.grey.shade700,
          fontWeight: selected
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }
}

//================================================================
// CARD EVALUATION
//================================================================

class _AssessmentCard
    extends StatelessWidget {
  final TeacherAssessmentModel assessment;
  final VoidCallback onTap;

  const _AssessmentCard({
    required this.assessment,
    required this.onTap,
  });

  Color get statusColor {
    switch (assessment.status) {
      case "published":
        return Colors.green;

      case "ready":
        return Colors.orange;

      case "in_progress":
        return Colors.blue;

      case "republish_required":
        return Colors.deepOrange;

      case "draft":
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color:
                Color.fromRGBO(
              0,
              0,
              0,
              .04,
            ),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                //================================================
                // TOP
                //================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
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
                            BorderRadius
                                .circular(15),
                      ),
                      child: const Icon(
                        Icons
                            .assignment_outlined,
                        color:
                            Color(0xff6214BE),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            assessment.title,
                            maxLines: 2,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${assessment.classroom.name} • "
                            "${assessment.subject.name}",
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons
                          .chevron_right_rounded,
                      color: Colors.grey,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                //================================================
                // INFORMATIONS
                //================================================

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoBadge(
                      icon:
                          Icons.category_outlined,
                      text:
                          assessment
                              .assessmentTypeLabel,
                    ),
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
                          Icons
                              .calendar_today_outlined,
                      text:
                          assessment.term.name,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                //================================================
                // FOOTER
                //================================================

                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            statusColor
                                .withOpacity(
                          .10,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(20),
                      ),
                      child: Text(
                        assessment.statusLabel,
                        style: TextStyle(
                          color:
                              statusColor,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (assessment.isPublished)
                      const Icon(
                        Icons
                            .check_circle_outline,
                        size: 18,
                        color: Colors.green,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//================================================================
// INFO BADGE
//================================================================

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
      decoration: BoxDecoration(
        color:
            const Color(0xffF5F6FA),
        borderRadius:
            BorderRadius.circular(12),
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
          const SizedBox(width: 5),
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

//================================================================
// ACTION TILE
//================================================================

class _ActionTile
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(
        vertical: 4,
      ),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color:
              color.withOpacity(.10),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight:
              FontWeight.bold,
        ),
      ),
      subtitle:
          Text(subtitle),
      trailing:
          const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

//================================================================
// VIDE
//================================================================

class _EmptyAssessmentView
    extends StatelessWidget {
  final String searchQuery;

  const _EmptyAssessmentView({
    required this.searchQuery,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final searching =
        searchQuery.isNotEmpty;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            searching
                ? Icons.search_off
                : Icons
                    .assignment_outlined,
            size: 60,
            color:
                Colors.grey.shade300,
          ),
          const SizedBox(height: 18),
          Text(
            searching
                ? "Aucune évaluation trouvée"
                : "Aucune évaluation",
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searching
                ? "Essayez avec un autre terme de recherche."
                : "Créez votre première évaluation.",
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