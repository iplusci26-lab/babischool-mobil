import 'package:flutter/material.dart';

import '../../../shared/widgets/premium_card.dart';

import '../models/assessment_model.dart';
import '../models/assessment_status.dart';

class AssessmentSummaryCard extends StatelessWidget {

  final List<AssessmentModel> assessments;

  const AssessmentSummaryCard({

    super.key,

    required this.assessments,

  });

  @override
  Widget build(BuildContext context) {

    final today = assessments.where(

      (e) =>

          e.status == AssessmentStatus.today,

    ).length;

    final upcoming = assessments.where(

      (e) =>

          e.status == AssessmentStatus.upcoming,

    ).length;

    final graded = assessments.where(

      (e) =>

          e.status == AssessmentStatus.graded,

    ).length;

    final late = assessments.where(

      (e) =>

          e.status == AssessmentStatus.late,

    ).length;

    return PremiumCard(

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Row(

            children: [

              Icon(

                Icons.assignment_rounded,

                color: Color(0xFF6214BE),

              ),

              SizedBox(width: 10),

              Text(

                "Évaluations",

                style: TextStyle(

                  fontSize: 18,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),

            ],

          ),

          const SizedBox(height: 18),

          Text(

            "${assessments.length} évaluation${assessments.length > 1 ? "s" : ""}",

            style: const TextStyle(

              fontSize: 30,

              fontWeight:
                  FontWeight.bold,

            ),

          ),

          const SizedBox(height: 4),

          Text(

            "programmées",

            style: TextStyle(

              color: Colors.grey.shade600,

            ),

          ),

          const SizedBox(height: 22),

          Row(

            children: [

              Expanded(

                child: _SummaryItem(

                  icon: Icons.schedule,

                  color: Colors.orange,

                  value: today,

                  label: "Aujourd'hui",

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                child: _SummaryItem(

                  icon: Icons.event,

                  color: Colors.blue,

                  value: upcoming,

                  label: "À venir",

                ),

              ),

            ],

          ),

          const SizedBox(height: 12),

          Row(

            children: [

              Expanded(

                child: _SummaryItem(

                  icon: Icons.check_circle,

                  color: Colors.green,

                  value: graded,

                  label: "Corrigées",

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                child: _SummaryItem(

                  icon: Icons.warning,

                  color: Colors.red,

                  value: late,

                  label: "En retard",

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}

class _SummaryItem extends StatelessWidget {

  final IconData icon;

  final Color color;

  final int value;

  final String label;

  const _SummaryItem({

    required this.icon,

    required this.color,

    required this.value,

    required this.label,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: color.withValues(
          alpha: .08,
        ),

        borderRadius:
            BorderRadius.circular(16),

      ),

      child: Column(

        children: [

          Icon(

            icon,

            color: color,

            size: 24,

          ),

          const SizedBox(height: 8),

          Text(

            value.toString(),

            style: TextStyle(

              color: color,

              fontWeight:
                  FontWeight.bold,

              fontSize: 22,

            ),

          ),

          const SizedBox(height: 4),

          Text(

            label,

            textAlign: TextAlign.center,

            style: TextStyle(

              color: Colors.grey.shade700,

              fontSize: 12,

            ),

          ),

        ],

      ),

    );

  }

}