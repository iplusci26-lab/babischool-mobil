import '../../../../core/api/api_client.dart';

import '../models/teacher_assessment_grades_response_model.dart';
import '../models/teacher_assessment_model.dart';

class TeacherAssessmentService {
  const TeacherAssessmentService();

  //============================================================
  // LISTE DES ÉVALUATIONS
  //============================================================

  Future<List<TeacherAssessmentModel>> getAssessments({
    String? scheduleId,
    String? classroomId,
    String? subjectId,
    String? status,
  }) async {
    final queryParameters =
        <String, dynamic>{};

    if (scheduleId != null &&
        scheduleId.trim().isNotEmpty) {
      queryParameters["schedule_id"] =
          scheduleId;
    }

    if (classroomId != null &&
        classroomId.trim().isNotEmpty) {
      queryParameters["classroom_id"] =
          classroomId;
    }

    if (subjectId != null &&
        subjectId.trim().isNotEmpty) {
      queryParameters["subject_id"] =
          subjectId;
    }

    if (status != null &&
        status.trim().isNotEmpty) {
      queryParameters["status"] =
          status;
    }

    final response =
        await ApiClient.dio.get(
      "/mobile/teacher/assessments/",
      queryParameters:
          queryParameters.isEmpty
              ? null
              : queryParameters,
    );

    final data = response.data;

    if (data is! Map) {
      throw Exception(
        "Réponse invalide du serveur.",
      );
    }

    final assessments =
        data["assessments"];

    if (assessments is! List) {
      return [];
    }

    return assessments
        .whereType<Map>()
        .map(
          (item) =>
              TeacherAssessmentModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  //============================================================
  // CRÉER
  //============================================================

  Future<TeacherAssessmentModel> createAssessment({
    required String scheduleId,
    required String title,
    required String assessmentType,
    double maxScore = 20,
    int weight = 1,
    String category = "class",
    DateTime? dateAssessment,
  }) async {
    _validateId(
      scheduleId,
      "scheduleId",
    );

    if (title.trim().isEmpty) {
      throw Exception(
        "Le titre de l'évaluation est obligatoire.",
      );
    }

    if (maxScore <= 0) {
      throw Exception(
        "La note maximale doit être supérieure à zéro.",
      );
    }

    if (weight <= 0) {
      throw Exception(
        "Le coefficient doit être supérieur à zéro.",
      );
    }

    final response =
        await ApiClient.dio.post(
      "/mobile/teacher/assessments/",
      data: {
        "schedule_id": scheduleId,
        "title": title.trim(),
        "assessment_type": assessmentType,
        "category": category,
        "max_score": maxScore,
        "weight": weight,
        "date_assessment":
            (dateAssessment ??
                    DateTime.now())
                .toIso8601String(),
      },
    );

    final data = response.data;

    if (data is! Map) {
      throw Exception(
        "Réponse invalide du serveur.",
      );
    }

    final assessmentData =
        data["assessment"];

    if (assessmentData is! Map) {
      throw Exception(
        "L'évaluation créée est absente de la réponse du serveur.",
      );
    }

    return TeacherAssessmentModel.fromJson(
      Map<String, dynamic>.from(
        assessmentData,
      ),
    );
  }

  //============================================================
  // DÉTAIL D'UNE ÉVALUATION
  //============================================================

  Future<TeacherAssessmentModel> getAssessment(
    String assessmentId,
  ) async {
    _validateId(
      assessmentId,
      "assessmentId",
    );

    final response =
        await ApiClient.dio.get(
      "/mobile/teacher/assessments/"
      "$assessmentId/",
    );

    final data = response.data;

    if (data is! Map) {
      throw Exception(
        "Réponse invalide du serveur.",
      );
    }

    final assessmentData =
        data["assessment"] ?? data;

    if (assessmentData is! Map) {
      throw Exception(
        "Évaluation absente de la réponse du serveur.",
      );
    }

    return TeacherAssessmentModel.fromJson(
      Map<String, dynamic>.from(
        assessmentData,
      ),
    );
  }

  //============================================================
  // NOTES D'UNE ÉVALUATION
  //============================================================

  Future<TeacherAssessmentGradesResponseModel>
      getAssessmentGrades(
    String assessmentId,
  ) async {
    _validateId(
      assessmentId,
      "assessmentId",
    );

    final response =
        await ApiClient.dio.get(
      "/mobile/teacher/assessments/"
      "$assessmentId/grades/",
    );

    final data = response.data;

    if (data is! Map) {
      throw Exception(
        "Réponse invalide du serveur.",
      );
    }

    return TeacherAssessmentGradesResponseModel
        .fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  //============================================================
  // MODIFIER
  //============================================================

  Future<TeacherAssessmentModel> updateAssessment({
    required String assessmentId,
    required String title,
    required String assessmentType,
    required double maxScore,
    required int weight,
    String? category,
    DateTime? dateAssessment,
  }) async {
    _validateId(
      assessmentId,
      "assessmentId",
    );

    if (title.trim().isEmpty) {
      throw Exception(
        "Le titre de l'évaluation est obligatoire.",
      );
    }

    if (maxScore <= 0) {
      throw Exception(
        "La note maximale doit être supérieure à zéro.",
      );
    }

    if (weight <= 0) {
      throw Exception(
        "Le coefficient doit être supérieur à zéro.",
      );
    }

    final response =
        await ApiClient.dio.put(
      "/mobile/teacher/assessments/"
      "$assessmentId/",
      data: {
        "title": title.trim(),
        "assessment_type": assessmentType,
        "max_score": maxScore,
        "weight": weight,
        if (category != null)
          "category": category,
        if (dateAssessment != null)
          "date_assessment":
              dateAssessment.toIso8601String(),
      },
    );

    final data = response.data;

    if (data is! Map) {
      throw Exception(
        "Réponse invalide du serveur.",
      );
    }

    final assessmentData =
        data["assessment"] ?? data;

    if (assessmentData is! Map) {
      throw Exception(
        "Évaluation absente de la réponse du serveur.",
      );
    }

    return TeacherAssessmentModel.fromJson(
      Map<String, dynamic>.from(
        assessmentData,
      ),
    );
  }

  //============================================================
  // SUPPRIMER
  //============================================================

  Future<void> deleteAssessment(
    String assessmentId,
  ) async {
    _validateId(
      assessmentId,
      "assessmentId",
    );

    await ApiClient.dio.delete(
      "/mobile/teacher/assessments/"
      "$assessmentId/",
    );
  }

  //============================================================
  // SAUVEGARDER LES NOTES
  //============================================================

  Future<TeacherAssessmentGradesResponseModel>
      saveGrades({
    required String assessmentId,
    required List<Map<String, dynamic>> grades,
  }) async {
    _validateId(
      assessmentId,
      "assessmentId",
    );

    if (grades.isEmpty) {
      throw Exception(
        "Aucune note à enregistrer.",
      );
    }

    final response =
        await ApiClient.dio.put(
      "/mobile/teacher/assessments/"
      "$assessmentId/grades/",
      data: {
        "records": grades,
      },
    );

    final data = response.data;

    if (data is! Map) {
      throw Exception(
        "Réponse invalide du serveur.",
      );
    }

    return TeacherAssessmentGradesResponseModel
        .fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  //============================================================
  // SAUVEGARDER UNE NOTE
  //============================================================

  Future<TeacherAssessmentGradesResponseModel>
      saveGrade({
    required String assessmentId,
    required String enrollmentId,
    required double score,
    String remarks = "",
  }) async {
    _validateId(
      enrollmentId,
      "enrollmentId",
    );

    return saveGrades(
      assessmentId: assessmentId,
      grades: [
        {
          "enrollment_id": enrollmentId,
          "score": score,
          "remarks": remarks.trim(),
        },
      ],
    );
  }

  //============================================================
  // MARQUER PRÊTE
  //============================================================

  Future<void> markReady(
    String assessmentId,
  ) async {
    _validateId(
      assessmentId,
      "assessmentId",
    );

    await ApiClient.dio.post(
      "/mobile/teacher/assessments/"
      "$assessmentId/ready/",
    );
  }

  //============================================================
  // REPUBLICATION
  //============================================================

  Future<void> republish(
    String assessmentId,
  ) async {
    _validateId(
      assessmentId,
      "assessmentId",
    );

    await ApiClient.dio.post(
      "/mobile/teacher/assessments/"
      "$assessmentId/republish/",
    );
  }

  //============================================================
  // PUBLIER
  //============================================================

  Future<void> publish(
    String assessmentId,
  ) async {
    _validateId(
      assessmentId,
      "assessmentId",
    );

    await ApiClient.dio.post(
      "/mobile/teacher/assessments/"
      "$assessmentId/publish/",
    );
  }

  //============================================================
  // UTILITAIRE
  //============================================================

  void _validateId(
    String value,
    String field,
  ) {
    if (value.trim().isEmpty) {
      throw ArgumentError(
        "$field ne peut pas être vide.",
      );
    }
  }
}