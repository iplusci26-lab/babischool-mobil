import 'package:flutter/material.dart';

import '../models/assessment_grade_model.dart';

class AssessmentTile extends StatelessWidget {

  final AssessmentGradeModel assessment;

  const AssessmentTile({

    super.key,

    required this.assessment,
  });

  Color get typeColor {

    switch (assessment.type) {

      case "exam":
        return Colors.red;

      case "test":
        return Colors.orange;

      default:
        return Colors.blue;
    }
  }

  String get typeLabel {

    switch (assessment.type) {

      case "exam":
        return "Examen";

      case "test":
        return "Interrogation";

      default:
        return "Devoir";
    }
  }

  @override
  Widget build(BuildContext context) {

    return ListTile(

      dense: true,

      leading: CircleAvatar(

        radius: 18,

        backgroundColor:
            typeColor.withValues(
          alpha: .15,
        ),

        child: Icon(

          Icons.assignment,

          color: typeColor,

          size: 18,
        ),
      ),

      title: Text(
        assessment.title,
      ),

      subtitle: Text(

        "$typeLabel • Coef ${assessment.weight}",
      ),

      trailing: Text(

        "${assessment.score}/${assessment.maxScore}",

        style: const TextStyle(

          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}