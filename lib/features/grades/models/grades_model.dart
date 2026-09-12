import 'report_card_model.dart';
import 'subject_grade_model.dart';

class GradeTermModel {
  final String id;
  final String name;
  final String termType;
  final String? startDate;
  final String? endDate;
  final bool isActive;

  GradeTermModel({
    required this.id,
    required this.name,
    required this.termType,
    this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory GradeTermModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GradeTermModel(
      id: json["id"].toString(),
      name: json["name"] ?? "",
      termType: json["term_type"] ?? "",
      startDate: json["start_date"]?.toString(),
      endDate: json["end_date"]?.toString(),
      isActive: json["is_active"] ?? false,
    );
  }
}

class GradesModel {
  final ReportCardModel reportCard;
  final List<SubjectGradeModel> subjects;

  final List<GradeTermModel> terms;
  final GradeTermModel? selectedTerm;

  GradesModel({
    required this.reportCard,
    required this.subjects,
    required this.terms,
    required this.selectedTerm,
  });

  factory GradesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // ========================================================
    // MATIÈRES
    // ========================================================

    final subjects = (json["subjects"] as List? ?? [])
        .map(
          (e) => SubjectGradeModel.fromJson(e),
        )
        .toList();

    // ========================================================
    // TRI DES MATIÈRES
    //
    // La matière ayant reçu la note la plus récente
    // apparaît en premier.
    // ========================================================

    subjects.sort(
      (a, b) {
        final dateA = a.latestGradeDate;
        final dateB = b.latestGradeDate;

        // Les matières sans aucune note vont à la fin.
        if (dateA == null && dateB == null) {
          return 0;
        }

        if (dateA == null) {
          return 1;
        }

        if (dateB == null) {
          return -1;
        }

        return dateB.compareTo(dateA);
      },
    );

    // ========================================================
    // TRIMESTRES
    // ========================================================

    final terms = (json["terms"] as List? ?? [])
        .map(
          (e) => GradeTermModel.fromJson(e),
        )
        .toList();

    // ========================================================
    // RÉSULTAT
    // ========================================================

    return GradesModel(
      reportCard: ReportCardModel.fromJson(
        json["report_card"],
      ),

      subjects: subjects,

      terms: terms,

      selectedTerm: json["selected_term"] != null
          ? GradeTermModel.fromJson(
              json["selected_term"],
            )
          : null,
    );
  }
}