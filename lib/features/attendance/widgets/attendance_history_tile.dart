import 'package:flutter/material.dart';

import '../models/attendance_model.dart';

class AttendanceHistoryTile
    extends StatelessWidget {

  final AttendanceHistory history;

  const AttendanceHistoryTile({

    super.key,

    required this.history,
  });

  IconData get icon {

    switch (history.status) {

      case "present":
        return Icons.check_circle;

      case "absent":
        return Icons.cancel;

      case "late":
        return Icons.schedule;

      case "excused":
        return Icons.assignment_turned_in;

      default:
        return Icons.help_outline;
    }
  }

  Color get color {

    switch (history.status) {

      case "present":
        return Colors.green;

      case "absent":
        return Colors.red;

      case "late":
        return Colors.orange;

      case "excused":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  String get label {

    switch (history.status) {

      case "present":
        return "Présent";

      case "absent":
        return "Absent";

      case "late":
        return "Retard";

      case "excused":
        return "Justifié";

      default:
        return history.status;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
      const EdgeInsets.all(
        16,
      ),

      decoration:
      BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          20,
        ),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withValues(
              alpha: 0.05,
            ),

            blurRadius: 10,

            offset:
            const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Row(

        children: [

          Container(

            width: 50,

            height: 50,

            decoration:
            BoxDecoration(

              color:
              color.withValues(
                alpha: 0.12,
              ),

              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),

            child: Icon(

              icon,

              color: color,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  label,

                  style:
                  const TextStyle(

                    fontWeight:
                    FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(

                  history.date,

                  style:
                  TextStyle(

                    color:
                    Colors.grey.shade600,
                  ),
                ),

                if (history.status == "late")

                  Padding(

                    padding:
                    const EdgeInsets.only(
                      top: 4,
                    ),

                    child: Text(

                      "Retard : ${history.minutesLate} min",

                      style:
                      const TextStyle(

                        color: Colors.orange,

                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                if (history.remarks.isNotEmpty)

                  Padding(

                    padding:
                    const EdgeInsets.only(
                      top: 4,
                    ),

                    child: Text(

                      history.remarks,

                      style:
                      TextStyle(

                        color:
                        Colors.grey.shade500,

                        fontSize: 12,
                      ),
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