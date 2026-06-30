import 'package:flutter/material.dart';

import '../models/student_detail_model.dart';

class StudentInfoTab
extends StatelessWidget {

  final StudentDetailModel student;

  const StudentInfoTab({

    super.key,

    required this.student,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return ListView(

      padding:
      const EdgeInsets.all(
        20,
      ),

      children: [

        Container(

          padding:
          const EdgeInsets.all(
            24,
          ),

          decoration:
          BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.circular(
              24,
            ),
          ),

          child: Column(

            children: [

              CircleAvatar(

                radius: 40,

                backgroundColor:
                const Color(
                  0xff6214BE,
                ),

                child: Text(

                  student.fullName[0],

                  style:
                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize: 24,
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Text(

                student.fullName,

                style:
                const TextStyle(

                  fontSize: 20,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              _InfoRow(
                "Matricule",
                student.studentNumber,
              ),

              _InfoRow(
                "Date naissance",
                student.dateOfBirth,
              ),

              _InfoRow(
                "Genre",
                student.gender,
              ),

              _InfoRow(
                "Classe",
                student.classroom,
              ),

              _InfoRow(
                "Cycle",
                student.cycle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow
extends StatelessWidget {

  final String title;

  final String value;

  const _InfoRow(
    this.title,
    this.value,
  );

  @override
  Widget build(
    BuildContext context,
  ) {

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        vertical: 12,
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,

        children: [

          Text(

            title,

            style: TextStyle(

              color:
              Colors.grey.shade600,
            ),
          ),

          Text(

            value,

            style:
            const TextStyle(

              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}