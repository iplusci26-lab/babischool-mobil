import 'package:flutter/material.dart';

import '../models/teacher_attendance_student_model.dart';

class AttendanceStudentTile extends StatelessWidget {

  final TeacherAttendanceStudentModel student;

  final ValueChanged<
      TeacherAttendanceStudentModel>? onChanged;

  final bool enabled;

  const AttendanceStudentTile({

    super.key,

    required this.student,

    this.onChanged,

    this.enabled = true,

  });

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

      ),

      child: Column(

        children: [

          //--------------------------------------------------
          // IDENTITÉ
          //--------------------------------------------------

          Row(

            children: [

              _StudentAvatar(
                student: student,
              ),

              const SizedBox(width: 12),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      student.fullName,

                      style: const TextStyle(

                        fontSize: 16,

                        fontWeight:
                            FontWeight.w700,

                      ),

                    ),

                    if (student.studentNumber != null &&
                        student.studentNumber!
                            .trim()
                            .isNotEmpty)

                      Padding(

                        padding:
                            const EdgeInsets.only(
                          top: 4,
                        ),

                        child: Text(

                          "Matricule : "
                          "${student.studentNumber}",

                          style: TextStyle(

                            fontSize: 12,

                            color:
                                Colors.grey.shade600,

                          ),

                        ),

                      ),

                  ],

                ),

              ),

              //------------------------------------------------
              // STATUT
              //------------------------------------------------

              _StatusBadge(
                status: student.status,
              ),

            ],

          ),

          const SizedBox(height: 14),

          //--------------------------------------------------
          // CHOIX DU STATUT
          //--------------------------------------------------

          Row(

            children: [

              Expanded(

                child: _StatusButton(

                  label: "Présent",

                  icon: Icons.check_circle_outline,

                  color: Colors.green,

                  selected:
                      student.isPresent,

                  enabled: enabled,

                  onTap: () {

                    _updateStatus(
                      "PRESENT",
                    );

                  },

                ),

              ),

              const SizedBox(width: 8),

              Expanded(

                child: _StatusButton(

                  label: "Absent",

                  icon: Icons.cancel_outlined,

                  color: Colors.red,

                  selected:
                      student.isAbsent,

                  enabled: enabled,

                  onTap: () {

                    _updateStatus(
                      "ABSENT",
                    );

                  },

                ),

              ),

              const SizedBox(width: 8),

              Expanded(

                child: _StatusButton(

                  label: "Retard",

                  icon: Icons.schedule,

                  color: Colors.orange,

                  selected:
                      student.isLate,

                  enabled: enabled,

                  onTap: () {

                    _selectLateStatus(
                      context,
                    );

                  },

                ),

              ),

            ],

          ),

          //--------------------------------------------------
          // RETARD
          //--------------------------------------------------

          if (student.isLate) ...[

            const SizedBox(height: 12),

            _LateEditor(

              minutesLate:
                  student.minutesLate,

              enabled: enabled,

              onChanged: (minutes) {

                onChanged?.call(

                  student.copyWith(

                    status: "LATE",

                    minutesLate: minutes,

                  ),

                );

              },

            ),

          ],

          //--------------------------------------------------
          // REMARQUE
          //--------------------------------------------------

          if (student.isAbsent ||
              student.isLate)

            const SizedBox(height: 12),

          if (student.isAbsent ||
              student.isLate)

            _RemarkEditor(

              initialValue:
                  student.remarks,

              enabled: enabled,

              onChanged: (value) {

                onChanged?.call(

                  student.copyWith(

                    remarks: value,

                  ),

                );

              },

            ),

        ],

      ),

    );

  }

  //----------------------------------------------------------
  // CHANGEMENT STATUT
  //----------------------------------------------------------

  void _updateStatus(
    String status,
  ) {

    onChanged?.call(

      student.copyWith(

        status: status,

        minutesLate:
            status == "LATE"
                ? student.minutesLate
                : 0,

      ),

    );

  }

  //----------------------------------------------------------
  // RETARD
  //----------------------------------------------------------

  Future<void> _selectLateStatus(
    BuildContext context,
  ) async {

    int minutes =
        student.minutesLate > 0
            ? student.minutesLate
            : 5;

    final result =
        await showDialog<int>(

      context: context,

      builder: (context) {

        return _LateDialog(
          initialMinutes: minutes,
        );

      },

    );

    if (result == null) {
      return;
    }

    onChanged?.call(

      student.copyWith(

        status: "LATE",

        minutesLate: result,

      ),

    );

  }

}


//============================================================
// AVATAR
//============================================================

class _StudentAvatar
    extends StatelessWidget {

  final TeacherAttendanceStudentModel student;

  const _StudentAvatar({

    required this.student,

  });

  @override
  Widget build(BuildContext context) {

    final initials = _initials();

    return Container(

      width: 48,

      height: 48,

      decoration: BoxDecoration(

        color: const Color(
          0xff6214BE,
        ).withOpacity(.10),

        shape: BoxShape.circle,

      ),

      alignment: Alignment.center,

      child: Text(

        initials,

        style: const TextStyle(

          color: Color(
            0xff6214BE,
          ),

          fontWeight:
              FontWeight.bold,

          fontSize: 15,

        ),

      ),

    );

  }

  String _initials() {

    final first =
        student.firstName.trim();

    final last =
        student.lastName.trim();

    if (first.isEmpty &&
        last.isEmpty) {

      return "?";

    }

    final firstLetter =
        first.isNotEmpty
            ? first[0]
            : "";

    final lastLetter =
        last.isNotEmpty
            ? last[0]
            : "";

    return (
      "$firstLetter$lastLetter"
    ).toUpperCase();

  }

}


//============================================================
// BADGE STATUT
//============================================================

class _StatusBadge
    extends StatelessWidget {

  final String status;

  const _StatusBadge({

    required this.status,

  });

  @override
  Widget build(BuildContext context) {

    final config =
        _statusConfig();

    return Container(

      padding:
          const EdgeInsets.symmetric(

        horizontal: 9,

        vertical: 6,

      ),

      decoration: BoxDecoration(

        color: config.color
            .withOpacity(.10),

        borderRadius:
            BorderRadius.circular(20),

      ),

      child: Text(

        config.label,

        style: TextStyle(

          color: config.color,

          fontSize: 11,

          fontWeight:
              FontWeight.w700,

        ),

      ),

    );

  }

  _StatusConfig _statusConfig() {

    switch (status) {

      case "ABSENT":

        return const _StatusConfig(
          "Absent",
          Colors.red,
        );

      case "LATE":

        return const _StatusConfig(
          "Retard",
          Colors.orange,
        );

      case "PRESENT":

      default:

        return const _StatusConfig(
          "Présent",
          Colors.green,
        );

    }

  }

}


//============================================================
// BOUTON STATUT
//============================================================

class _StatusButton
    extends StatelessWidget {

  final String label;

  final IconData icon;

  final Color color;

  final bool selected;

  final bool enabled;

  final VoidCallback? onTap;

  const _StatusButton({

    required this.label,

    required this.icon,

    required this.color,

    required this.selected,

    required this.enabled,

    this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    return Material(

      color: Colors.transparent,

      child: InkWell(

        borderRadius:
            BorderRadius.circular(12),

        onTap:
            enabled ? onTap : null,

        child: AnimatedContainer(

          duration:
              const Duration(
            milliseconds: 160,
          ),

          padding:
              const EdgeInsets.symmetric(

            vertical: 10,

            horizontal: 6,

          ),

          decoration: BoxDecoration(

            color: selected
                ? color.withOpacity(.10)
                : Colors.grey.shade50,

            borderRadius:
                BorderRadius.circular(12),

            border: Border.all(

              color: selected
                  ? color
                  : Colors.grey.shade200,

              width:
                  selected ? 1.3 : 1,

            ),

          ),

          child: Column(

            children: [

              Icon(

                icon,

                size: 20,

                color: selected
                    ? color
                    : Colors.grey.shade500,

              ),

              const SizedBox(height: 4),

              Text(

                label,

                style: TextStyle(

                  fontSize: 11,

                  fontWeight:
                      FontWeight.w600,

                  color: selected
                      ? color
                      : Colors.grey.shade600,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}


//============================================================
// EDITEUR RETARD
//============================================================

class _LateEditor
    extends StatelessWidget {

  final int minutesLate;

  final bool enabled;

  final ValueChanged<int> onChanged;

  const _LateEditor({

    required this.minutesLate,

    required this.enabled,

    required this.onChanged,

  });

  @override
  Widget build(BuildContext context) {

    return Row(

      children: [

        Icon(

          Icons.timer_outlined,

          size: 20,

          color: Colors.orange.shade700,

        ),

        const SizedBox(width: 8),

        const Text(

          "Minutes de retard :",

          style: TextStyle(

            fontSize: 13,

            fontWeight:
                FontWeight.w600,

          ),

        ),

        const SizedBox(width: 10),

        Container(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 4,
          ),

          decoration: BoxDecoration(

            color: Colors.orange
                .withOpacity(.08),

            borderRadius:
                BorderRadius.circular(12),

          ),

          child: Row(

            children: [

              IconButton(

                onPressed:
                    enabled &&
                            minutesLate > 1

                        ? () {
                            onChanged(
                              minutesLate - 1,
                            );
                          }

                        : null,

                icon: const Icon(
                  Icons.remove,
                ),

                iconSize: 18,

              ),

              Text(

                "$minutesLate",

                style: const TextStyle(

                  fontWeight:
                      FontWeight.bold,

                ),

              ),

              IconButton(

                onPressed:
                    enabled

                        ? () {
                            onChanged(
                              minutesLate + 1,
                            );
                          }

                        : null,

                icon: const Icon(
                  Icons.add,
                ),

                iconSize: 18,

              ),

            ],

          ),

        ),

      ],

    );

  }

}


//============================================================
// REMARQUE
//============================================================

class _RemarkEditor
    extends StatefulWidget {

  final String initialValue;

  final bool enabled;

  final ValueChanged<String> onChanged;

  const _RemarkEditor({

    required this.initialValue,

    required this.enabled,

    required this.onChanged,

  });

  @override
  State<_RemarkEditor> createState() =>
      _RemarkEditorState();

}

class _RemarkEditorState
    extends State<_RemarkEditor> {

  late final TextEditingController
      controller;

  @override
  void initState() {

    super.initState();

    controller =
        TextEditingController(
      text: widget.initialValue,
    );

  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      enabled: widget.enabled,

      maxLines: 2,

      onChanged:
          widget.onChanged,

      decoration: InputDecoration(

        labelText: "Remarque",

        hintText:
            "Ajouter une remarque...",

        prefixIcon: const Icon(
          Icons.notes_outlined,
        ),

        filled: true,

        fillColor:
            Colors.grey.shade50,

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(14),

          borderSide: BorderSide.none,

        ),

        enabledBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(14),

          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),

        ),

        focusedBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(14),

          borderSide: const BorderSide(
            color: Color(0xff6214BE),
          ),

        ),

      ),

    );

  }

}


//============================================================
// DIALOGUE RETARD
//============================================================

class _LateDialog
    extends StatefulWidget {

  final int initialMinutes;

  const _LateDialog({

    required this.initialMinutes,

  });

  @override
  State<_LateDialog> createState() =>
      _LateDialogState();

}

class _LateDialogState
    extends State<_LateDialog> {

  late int minutes;

  @override
  void initState() {

    super.initState();

    minutes =
        widget.initialMinutes;

  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text(
        "Durée du retard",
      ),

      content: Column(

        mainAxisSize:
            MainAxisSize.min,

        children: [

          const Text(
            "Indiquez le nombre de minutes de retard.",
          ),

          const SizedBox(height: 20),

          Row(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              IconButton(

                onPressed:
                    minutes > 1

                        ? () {

                            setState(() {

                              minutes--;

                            });

                          }

                        : null,

                icon: const Icon(
                  Icons.remove_circle_outline,
                ),

              ),

              Container(

                width: 70,

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),

                decoration: BoxDecoration(

                  color: Colors.orange
                      .withOpacity(.10),

                  borderRadius:
                      BorderRadius.circular(14),

                ),

                child: Text(

                  "$minutes min",

                  textAlign:
                      TextAlign.center,

                  style: const TextStyle(

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 16,

                  ),

                ),

              ),

              IconButton(

                onPressed: () {

                  setState(() {

                    minutes++;

                  });

                },

                icon: const Icon(
                  Icons.add_circle_outline,
                ),

              ),

            ],

          ),

        ],

      ),

      actions: [

        TextButton(

          onPressed: () {

            Navigator.pop(
              context,
            );

          },

          child: const Text(
            "Annuler",
          ),

        ),

        FilledButton(

          onPressed: () {

            Navigator.pop(
              context,
              minutes,
            );

          },

          child: const Text(
            "Valider",
          ),

        ),

      ],

    );

  }

}


//============================================================
// CONFIGURATION STATUT
//============================================================

class _StatusConfig {

  final String label;

  final Color color;

  const _StatusConfig(
    this.label,
    this.color,
  );

}