import 'package:flutter/material.dart';

class AssessmentSection extends StatelessWidget {

  final String title;

  const AssessmentSection({

    super.key,

    required this.title,

  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(

        top: 24,
        bottom: 12,

      ),

      child: Row(

        children: [

          Expanded(

            child: Divider(

              color: Colors.grey.shade300,

            ),

          ),

          Padding(

            padding: const EdgeInsets.symmetric(

              horizontal: 14,

            ),

            child: Text(

              title,

              style: const TextStyle(

                fontSize: 16,

                fontWeight: FontWeight.bold,

              ),

            ),

          ),

          Expanded(

            child: Divider(

              color: Colors.grey.shade300,

            ),

          ),

        ],

      ),

    );

  }

}