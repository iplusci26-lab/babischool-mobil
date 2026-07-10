import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/widgets/premium_card.dart';

import '../models/teacher_homework_model.dart';

class TeacherHomeworkCard extends StatelessWidget {

  final TeacherHomeworkModel homework;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  const TeacherHomeworkCard({

    super.key,

    required this.homework,

    required this.onEdit,

    required this.onDelete,

  });

  @override
  Widget build(BuildContext context) {

    final formatter = DateFormat("dd/MM/yyyy");

    return PremiumCard(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      homework.title,

                      style: const TextStyle(

                        fontSize: 18,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      "À rendre le ${formatter.format(homework.dueDate)}",

                    ),

                  ],

                ),

              ),

              if (homework.hasAttachment)

                const Icon(

                  Icons.attach_file,

                ),

            ],

          ),

          const SizedBox(height: 18),

          Text(

            homework.description,

            maxLines: 3,

            overflow: TextOverflow.ellipsis,

          ),

          const SizedBox(height: 20),

          Row(

            children: [

              Expanded(

                child: FilledButton.icon(

                  onPressed: onEdit,

                  icon: const Icon(Icons.edit),

                  label: const Text(

                    "Modifier",

                  ),

                ),

              ),

              const SizedBox(width: 10),

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