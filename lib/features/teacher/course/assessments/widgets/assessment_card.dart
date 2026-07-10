import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/widgets/premium_card.dart';

import '../models/assessment_model.dart';

class AssessmentCard extends StatelessWidget {

  final TeacherAssessmentModel assessment;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  final VoidCallback onGrades;

  const AssessmentCard({

    super.key,

    required this.assessment,

    required this.onEdit,

    required this.onDelete,

    required this.onGrades,

  });

  @override
  Widget build(BuildContext context) {

    final formatter = DateFormat(

      "dd/MM/yyyy",

    );

    return PremiumCard(

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          //----------------------------------------------------
          // HEADER
          //----------------------------------------------------

          Row(

            children: [

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      assessment.title,

                      style: const TextStyle(

                        fontSize: 18,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      formatter.format(

                        assessment.dateAssessment,

                      ),

                    ),

                  ],

                ),

              ),

              Chip(

                label: Text(

                  assessment.type,

                ),

              ),

            ],

          ),

          const SizedBox(height: 18),

          //----------------------------------------------------
          // INFORMATIONS
          //----------------------------------------------------

          Row(

            children: [

              const Icon(

                Icons.grade,

                size: 18,

              ),

              const SizedBox(width: 8),

              Text(

                "/${assessment.maxScore}",

              ),

              const Spacer(),

              Text(

                "Coef. ${assessment.weight}",

              ),

            ],

          ),

          const SizedBox(height: 20),

          //----------------------------------------------------
          // ACTIONS
          //----------------------------------------------------

          Row(

            children: [

              Expanded(

                child: FilledButton.icon(

                  onPressed: onGrades,

                  icon: const Icon(

                    Icons.edit_note,

                  ),

                  label: const Text(

                    "Notes",

                  ),

                ),

              ),

              const SizedBox(width: 8),

              IconButton(

                onPressed: onEdit,

                icon: const Icon(

                  Icons.edit,

                ),

              ),

              IconButton(

                onPressed: onDelete,

                icon: const Icon(

                  Icons.delete,

                  color: Colors.red,

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}