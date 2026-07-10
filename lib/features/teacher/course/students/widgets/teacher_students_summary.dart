import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/premium_card.dart';

class TeacherStudentsSummary extends StatelessWidget {

  final String classroom;

  final int students;

  const TeacherStudentsSummary({

    super.key,

    required this.classroom,

    required this.students,

  });

  @override
  Widget build(BuildContext context) {

    return PremiumCard(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          //--------------------------------------------------
          // HEADER
          //--------------------------------------------------

          Row(

            children: [

              Container(

                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(

                  color: AppColors.primary.withOpacity(.10),

                  borderRadius: BorderRadius.circular(16),

                ),

                child: const Icon(

                  Icons.groups,

                  color: AppColors.primary,

                  size: 30,

                ),

              ),

              const SizedBox(width: 16),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      classroom,

                      style: const TextStyle(

                        fontSize: 20,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      "$students élèves",

                      style: TextStyle(

                        color: Colors.grey.shade600,

                      ),

                    ),

                  ],

                ),

              ),

            ],

          ),

          const SizedBox(height: 24),

          //--------------------------------------------------
          // INFO
          //--------------------------------------------------

          Container(

            width: double.infinity,

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(

              color: Colors.blue.shade50,

              borderRadius: BorderRadius.circular(14),

            ),

            child: const Row(

              children: [

                Icon(

                  Icons.info_outline,

                  color: Colors.blue,

                ),

                SizedBox(width: 10),

                Expanded(

                  child: Text(

                    "Sélectionnez une action pour chaque élève.",

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