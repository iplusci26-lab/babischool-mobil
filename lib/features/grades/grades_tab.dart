import 'package:flutter/material.dart';

import '../../../shared/widgets/section_title.dart';

import 'models/grades_model.dart';

import 'services/grades_service.dart';

import 'widgets/grades_summary_card.dart';
import 'widgets/subject_grade_card.dart';

class GradesTab extends StatefulWidget {
  final String studentId;

  const GradesTab({
    super.key,
    required this.studentId,
  });

  @override
  State<GradesTab> createState() =>
      _GradesTabState();
}

class _GradesTabState extends State<GradesTab> {
  final GradesService service = GradesService();

  GradesModel? grades;

  bool loading = true;

  String? selectedTermId;

  // ==========================================================
  // CHARGEMENT DES NOTES
  // ==========================================================

  Future<void> loadData({
  String? termId,
}) async {
  if (mounted) {
    setState(() {
      loading = true;
    });
  }

  try {
    // ==========================================================
    // PREMIÈRE REQUÊTE
    // ==========================================================
    final result = await service.getGrades(
      widget.studentId,
      termId: termId,
    );

    if (!mounted) {
      return;
    }

    // ==========================================================
    // PREMIER CHARGEMENT
    // ==========================================================
    if (termId == null &&
        result.terms.isNotEmpty) {
      
      final firstTermId =
          result.terms.first.id;

      // Si le backend n'a pas déjà chargé
      // le premier trimestre, on le recharge
      // explicitement.
      if (result.selectedTerm?.id != firstTermId) {
        final firstTermResult =
            await service.getGrades(
          widget.studentId,
          termId: firstTermId,
        );

        if (!mounted) {
          return;
        }

        setState(() {
          grades = firstTermResult;
          selectedTermId = firstTermId;
        });

        return;
      }

      // Le backend avait déjà renvoyé
      // le premier trimestre.
      setState(() {
        grades = result;
        selectedTermId = firstTermId;
      });

      return;
    }

    // ==========================================================
    // CHANGEMENT DE TRIMESTRE
    // ==========================================================
    setState(() {
      grades = result;
      selectedTermId =
          result.selectedTerm?.id ?? termId;
    });
  } catch (e) {
    debugPrint(
      "❌ Erreur chargement notes : $e",
    );
  } finally {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}

  // ==========================================================
  // CHANGEMENT DE TRIMESTRE
  // ==========================================================

  Future<void> _changeTerm(
    String? termId,
  ) async {
    if (termId == null) {
      return;
    }

    if (termId == selectedTermId) {
      return;
    }

    await loadData(
      termId: termId,
    );
  }

  // ==========================================================
  // INITIALISATION
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
  Widget build(
    BuildContext context,
  ) {
    // --------------------------------------------------------
    // CHARGEMENT INITIAL
    // --------------------------------------------------------

    if (loading && grades == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // --------------------------------------------------------
    // ERREUR
    // --------------------------------------------------------

    if (grades == null) {
      return RefreshIndicator(
        onRefresh: () {
          return loadData(
            termId: selectedTermId,
          );
        },
        child: ListView(
          children: const [
            SizedBox(
              height: 250,
            ),
            Center(
              child: Text(
                "Impossible de charger les notes",
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return loadData(
          termId: selectedTermId,
        );
      },
      child: ListView(
        padding: const EdgeInsets.all(
          20,
        ),
        children: [
          // ==================================================
          // SELECTEUR DE TRIMESTRE
          // ==================================================

          _buildTermSelector(),

          const SizedBox(
            height: 24,
          ),

          // ==================================================
          // INDICATEUR DE CHARGEMENT
          // ==================================================

          if (loading)
            const Padding(
              padding: EdgeInsets.only(
                bottom: 16,
              ),
              child: LinearProgressIndicator(
                minHeight: 2,
              ),
            ),

          // ==================================================
          // RÉSUMÉ
          // ==================================================

          GradesSummaryCard(
            report: grades!.reportCard,
          ),

          const SizedBox(
            height: 24,
          ),

          // ==================================================
          // MATIÈRES
          // ==================================================

          const SectionTitle(
            title: "Matières",
          ),

          const SizedBox(
            height: 16,
          ),

          if (grades!.subjects.isEmpty)
            _buildEmptyGrades()
          else
            ...grades!.subjects.map(
              (subject) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 14,
                ),
                child: SubjectGradeCard(
                  subject: subject,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // SELECTEUR DE TRIMESTRE
  // ==========================================================

  Widget _buildTermSelector() {
    if (grades!.terms.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool selectedExists =
        grades!.terms.any(
      (term) =>
          term.id == selectedTermId,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(
            0xffE5E7EB,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(
              0,
              0,
              0,
              0.04,
            ),
            blurRadius: 12,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedExists
                ? selectedTermId
                : null,

            isExpanded: true,

            icon: const Icon(
              Icons
                  .keyboard_arrow_down_rounded,
              color: Color(
                0xff6214BE,
              ),
            ),

            hint: const Text(
              "Sélectionner un trimestre",
            ),

            items: grades!.terms.map(
              (term) {
                return DropdownMenuItem<
                    String>(
                  value: term.id,
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xff6214BE,
                          ).withOpacity(
                            0.08,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),
                        child: const Icon(
                          Icons
                              .school_outlined,
                          size: 20,
                          color: Color(
                            0xff6214BE,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              term.name,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                                fontSize: 15,
                              ),
                            ),

                            if (term.isActive)
                              const Text(
                                "Trimestre actuel",
                                style:
                                    TextStyle(
                                  fontSize: 11,
                                  color:
                                      Colors
                                          .green,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),

            onChanged:
                loading
                    ? null
                    : _changeTerm,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // AUCUNE NOTE
  // ==========================================================

  Widget _buildEmptyGrades() {
    return Container(
      padding: const EdgeInsets.all(
        28,
      ),
      decoration: BoxDecoration(
        color: const Color(
          0xffF8F9FC,
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(
            0xffE5E7EB,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(
                0xff6214BE,
              ).withOpacity(
                0.08,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 32,
              color: Color(
                0xff6214BE,
              ),
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            "Aucune note disponible",
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            grades!.selectedTerm != null
                ? "Aucune note n'a encore été enregistrée pour ${grades!.selectedTerm!.name.toLowerCase()}."
                : "Aucune note n'a encore été enregistrée pour ce trimestre.",
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}