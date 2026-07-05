import '../models/assessment_model.dart';

Map<String, List<AssessmentModel>> groupAssessments(

  List<AssessmentModel> assessments,

) {

  final Map<String, List<AssessmentModel>> groups = {};

  const titles = {

    "today": "Aujourd'hui",

    "tomorrow": "Demain",

    "this_week": "Cette semaine",

    "later": "Plus tard",

    "past": "Passées",

  };

  for (final assessment in assessments) {

    final key = titles[

      assessment.dateGroup

    ]!;

    groups.putIfAbsent(

      key,

      () => [],

    );

    groups[key]!.add(

      assessment,

    );

  }

  return groups;

}