import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_card.dart';

import '../models/homework_model.dart';
import '../models/homework_status.dart';

class HomeworkCard extends StatelessWidget {

  final HomeworkModel homework;

  const HomeworkCard({

    super.key,

    required this.homework,

  });

  
Widget _buildGradeSection() {
  if (homework.hasScore) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified,
                color: Colors.green.shade700,
              ),
              const SizedBox(width: 8),
              const Text(
                "Note publiée",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                homework.score!.toStringAsFixed(
                  homework.score! % 1 == 0 ? 0 : 2,
                ),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  "/ ${homework.maxScore.toStringAsFixed(
                    homework.maxScore % 1 == 0 ? 0 : 2,
                  )}",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          if (homework.gradePublishedAt != null) ...[
            const SizedBox(height: 6),
            Text(
              "Publiée le ${_formatPublicationDate(homework.gradePublishedAt!)}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  if (!homework.isGradePublished &&
      homework.isSubmitted) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: Colors.orange.shade800,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Travail remis – note en attente de publication",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  return const SizedBox.shrink();
}

String _formatPublicationDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;

  final localDate = date.toLocal();

  final day = localDate.day.toString().padLeft(2, '0');
  final month = localDate.month.toString().padLeft(2, '0');
  final year = localDate.year;

  return "$day/$month/$year";
}


  @override
  Widget build(BuildContext context) {

    final status = homework.homeworkStatus;

    return PremiumCard(

      padding: EdgeInsets.zero,

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          //--------------------------------------------------
          // HEADER
          //--------------------------------------------------

          Container(

            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(

              color: status.backgroundColor,

              borderRadius: const BorderRadius.only(

                topLeft: Radius.circular(22),

                topRight: Radius.circular(22),

              ),

            ),

            child: Row(

              children: [

                CircleAvatar(

                  radius: 24,

                  backgroundColor: status.color,

                  child: const Icon(

                    Icons.assignment,

                    color: Colors.white,

                  ),

                ),

                const SizedBox(width: 16),

                Expanded(

                  child: Column(

                    crossAxisAlignment:

                        CrossAxisAlignment.start,

                    children: [

                      Text(

                        homework.subject,

                        style: const TextStyle(

                          fontWeight:

                              FontWeight.bold,

                          fontSize: 17,

                        ),

                      ),

                      const SizedBox(height: 4),

                      Text(

                        homework.title,

                        style: TextStyle(

                          color:

                              Colors.grey.shade700,

                        ),

                      ),

                    ],

                  ),

                ),

                Container(

                  padding:

                      const EdgeInsets.symmetric(

                    horizontal: 14,

                    vertical: 8,

                  ),

                  decoration: BoxDecoration(

                    color: status.color,

                    borderRadius:

                        BorderRadius.circular(30),

                  ),

                  child: Row(

                    mainAxisSize:

                        MainAxisSize.min,

                    children: [

                      Icon(

                        status.icon,

                        color: Colors.white,

                        size: 18,

                      ),

                      const SizedBox(width: 6),

                      Text(

                        status.label,

                        style:

                            const TextStyle(

                          color: Colors.white,

                          fontWeight:

                              FontWeight.w600,

                        ),

                      ),

                    ],

                  ),

                ),

              ],

            ),

          ),

          //--------------------------------------------------
          // BODY
          //--------------------------------------------------

          Padding(

            padding: const EdgeInsets.all(18),

            child: Column(

              crossAxisAlignment:

                  CrossAxisAlignment.start,

              children: [

                //------------------------------------------------
                // TEACHER
                //------------------------------------------------

                Row(

                  children: [

                    const Icon(

                      Icons.person,

                      size: 18,

                      color: AppColors.primary,

                    ),

                    const SizedBox(width: 8),

                    Expanded(

                      child: Text(

                        homework.teacher,

                      ),

                    ),

                  ],

                ),

                const SizedBox(height: 12),

                //------------------------------------------------
                // DATE
                //------------------------------------------------

                Row(

                  children: [

                    const Icon(

                      Icons.calendar_today,

                      size: 18,

                      color: AppColors.primary,

                    ),

                    const SizedBox(width: 8),

                    Text(

                      homework.dateLabel,

                    ),

                  ],

                ),

                const SizedBox(height: 18),

                //------------------------------------------------
                // DESCRIPTION
                //------------------------------------------------

                if (homework.description
                    .trim()
                    .isNotEmpty) ...[

                  const Text(

                    "Description",

                    style: TextStyle(

                      fontWeight:

                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 8),

                  Text(

                    homework.description,

                    style: TextStyle(

                      color:

                          Colors.grey.shade700,

                      height: 1.4,

                    ),

                  ),

                  const SizedBox(height: 18),

                ],

                
                if (homework.isGradePublished ||
                    homework.isSubmitted) ...[
                  const SizedBox(height: 18),
                  _buildGradeSection(),
                  const SizedBox(height: 18),
                ],

                //------------------------------------------------
                // PIECE JOINTE
                //------------------------------------------------

                if (homework.hasAttachment)

                  Container(

                    padding:

                        const EdgeInsets.all(14),

                    decoration: BoxDecoration(

                      color:

                          Colors.grey.shade100,

                      borderRadius:

                          BorderRadius.circular(

                        14,

                      ),

                    ),

                    child: const Row(

                      children: [

                        Icon(

                          Icons.attach_file,

                          color:

                              AppColors.primary,

                        ),

                        SizedBox(width: 10),

                        Expanded(

                          child: Text(

                            "Pièce jointe disponible",

                          ),

                        ),

                        Icon(

                          Icons.download,

                        ),

                      ],

                    ),

                  ),

                //------------------------------------------------
                // COMMENTAIRE
                //------------------------------------------------

                if (homework
                    .hasTeacherComment) ...[

                  const SizedBox(height: 18),

                  Container(

                    width: double.infinity,

                    padding:

                        const EdgeInsets.all(16),

                    decoration: BoxDecoration(

                      color:

                          Colors.amber.shade50,

                      borderRadius:

                          BorderRadius.circular(

                        16,

                      ),

                    ),

                    child: Row(

                      crossAxisAlignment:

                          CrossAxisAlignment.start,

                      children: [

                        Icon(

                          Icons.school,

                          color:

                              Colors.orange.shade700,

                        ),

                        const SizedBox(width: 12),

                        Expanded(

                          child: Text(

                            homework.teacherComment,

                          ),

                        ),

                      ],

                    ),

                  ),

                ],

              ],

            ),

          ),

        ],

      ),

    );

  }

}