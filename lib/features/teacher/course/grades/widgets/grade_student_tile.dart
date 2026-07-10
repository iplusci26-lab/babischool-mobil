import 'package:flutter/material.dart';

import '../models/grade_student_model.dart';

class GradeStudentTile extends StatefulWidget {

  final GradeStudentModel student;

  final double maxScore;

  final ValueChanged<double?> onChanged;

  const GradeStudentTile({

    super.key,

    required this.student,

    required this.maxScore,

    required this.onChanged,

  });

  @override
  State<GradeStudentTile> createState() =>
      _GradeStudentTileState();

}

class _GradeStudentTileState
    extends State<GradeStudentTile> {

  late final TextEditingController controller;

  @override
  void initState() {

    super.initState();

    controller = TextEditingController(

      text: widget.student.score == null

          ? ""

          : widget.student.score!
              .toStringAsFixed(0),

    );

  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.only(

        bottom: 14,

      ),

      elevation: 0,

      shape: RoundedRectangleBorder(

        borderRadius:

            BorderRadius.circular(18),

      ),

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Row(

          children: [

            Expanded(

              child: Text(

                widget.student.student,

                style: const TextStyle(

                  fontWeight: FontWeight.bold,

                  fontSize: 15,

                ),

              ),

            ),

            SizedBox(

              width: 90,

              child: TextFormField(

                controller: controller,

                keyboardType:

                    const TextInputType.numberWithOptions(

                  decimal: true,

                ),

                textAlign: TextAlign.center,

                decoration: InputDecoration(

                  hintText: "0",

                  suffixText:
                      "/${widget.maxScore.toStringAsFixed(0)}",

                ),

                onChanged: (value) {

                  if (value.trim().isEmpty) {

                    widget.onChanged(null);

                    return;

                  }

                  final score =
                      double.tryParse(value);

                  if (score == null) {

                    return;

                  }

                  if (score >
                      widget.maxScore) {

                    controller.text =
                        widget.maxScore
                            .toStringAsFixed(0);

                    controller.selection =
                        TextSelection.fromPosition(

                      TextPosition(

                        offset: controller
                            .text.length,

                      ),

                    );

                    widget.onChanged(

                      widget.maxScore,

                    );

                    return;

                  }

                  widget.onChanged(score);

                },

              ),

            ),

          ],

        ),

      ),

    );

  }

}