import 'package:flutter/material.dart';

import '../models/assessment_model.dart';
import 'assessment_icon.dart';

class AssessmentHeader extends StatelessWidget {

  final AssessmentModel assessment;

  const AssessmentHeader({

    super.key,

    required this.assessment,

  });

  @override
  Widget build(BuildContext context) {

    return Row(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        //---------------------------------------------------
        // ICONE
        //---------------------------------------------------

        AssessmentIcon(

          type: assessment.type,

        ),

        const SizedBox(
          width: 14,
        ),

        //---------------------------------------------------
        // TITRES
        //---------------------------------------------------

        Expanded(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(

                assessment.subject,

                style: const TextStyle(

                  fontSize: 17,

                  fontWeight:
                      FontWeight.w700,

                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(

                assessment.title,

                style: TextStyle(

                  color:
                      Colors.grey.shade700,

                  fontSize: 15,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Row(

                children: [

                  Icon(

                    Icons.person_outline,

                    size: 16,

                    color:
                        Colors.grey.shade600,
                  ),

                  const SizedBox(
                    width: 5,
                  ),

                  Expanded(

                    child: Text(

                      assessment.teacher,

                      style: TextStyle(

                        color: Colors
                            .grey
                            .shade600,

                        fontSize: 13,
                      ),

                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        //---------------------------------------------------
        // NOTE
        //---------------------------------------------------

        if (assessment.hasScore)

          Container(

            width: 62,

            height: 62,

            decoration: BoxDecoration(

              color:
                  Colors.green.shade50,

              shape: BoxShape.circle,

              border: Border.all(

                color: Colors.green
                    .shade200,
              ),
            ),

            child: Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Text(

                    assessment.score!
                        .toStringAsFixed(
                      0,
                    ),

                    style:

                        TextStyle(

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,

                      color: Colors
                          .green
                          .shade700,
                    ),
                  ),

                  Text(

                    "/${assessment.maxScore.toStringAsFixed(0)}",

                    style: TextStyle(

                      fontSize: 10,

                      color: Colors
                          .green
                          .shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}