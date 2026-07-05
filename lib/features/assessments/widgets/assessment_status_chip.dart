import 'package:flutter/material.dart';

import '../models/assessment_status.dart';

class AssessmentStatusChip extends StatelessWidget {

  final AssessmentStatus status;

  final bool compact;

  const AssessmentStatusChip({

    super.key,

    required this.status,

    this.compact = false,

  });

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(

      duration: const Duration(
        milliseconds: 250,
      ),

      curve: Curves.easeInOut,

      padding: EdgeInsets.symmetric(

        horizontal: compact ? 10 : 14,

        vertical: compact ? 5 : 8,

      ),

      decoration: BoxDecoration(

        color: status.backgroundColor,

        borderRadius: BorderRadius.circular(
          100,
        ),

        border: Border.all(

          color: status.color.withValues(
            alpha: .20,
          ),

        ),

      ),

      child: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(

            status.icon,

            size: compact ? 14 : 18,

            color: status.color,

          ),

          SizedBox(
            width: compact ? 4 : 8,
          ),

          Text(

            status.label,

            style: TextStyle(

              color: status.color,

              fontWeight: FontWeight.w700,

              fontSize: compact ? 11 : 13,

            ),

          ),

        ],

      ),

    );

  }

}