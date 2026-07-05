import 'package:flutter/material.dart';

class AssessmentIcon extends StatelessWidget {

  final String type;

  final double size;

  const AssessmentIcon({

    super.key,

    required this.type,

    this.size = 52,

  });

  IconData get icon {

    switch (type.toLowerCase()) {

      case "homework":

        return Icons.assignment;

      case "quiz":

        return Icons.quiz;

      case "test":

        return Icons.fact_check;

      case "exam":

        return Icons.school;

      default:

        return Icons.description;
    }
  }

  Color get color {

    switch (type.toLowerCase()) {

      case "homework":

        return Colors.deepPurple;

      case "quiz":

        return Colors.orange;

      case "test":

        return Colors.blue;

      case "exam":

        return Colors.red;

      default:

        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      width: size,

      height: size,

      decoration: BoxDecoration(

        color: color.withValues(
          alpha: .10,
        ),

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Icon(

        icon,

        color: color,

        size: size * .52,

      ),
    );
  }
}