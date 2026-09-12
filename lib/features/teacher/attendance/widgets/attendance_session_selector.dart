import 'package:flutter/material.dart';

import '../models/teacher_attendance_session_model.dart';

class AttendanceSessionSelector extends StatelessWidget {

  final bool isPrimary;

  //----------------------------------------------------------
  // PRIMAIRE
  //----------------------------------------------------------

  final String? selectedPeriod;

  final ValueChanged<String>? onPeriodSelected;

  //----------------------------------------------------------
  // SECONDAIRE
  //----------------------------------------------------------

  final List<TeacherAttendanceSessionModel> sessions;

  final String? selectedSessionId;

  final ValueChanged<
      TeacherAttendanceSessionModel>?
  onSessionSelected;

  //----------------------------------------------------------
  // ETAT
  //----------------------------------------------------------

  final bool enabled;

  const AttendanceSessionSelector({

    super.key,

    required this.isPrimary,

    this.selectedPeriod,

    this.onPeriodSelected,

    this.sessions = const [],

    this.selectedSessionId,

    this.onSessionSelected,

    this.enabled = true,

  });

  //----------------------------------------------------------
  // PERIODES PRIMAIRE
  //----------------------------------------------------------

  static const List<
      Map<String, String>> primaryPeriods = [

    {
      "value": "MORNING_ENTRY",
      "label": "Matin",
      "description": "Avant la récréation",
    },

    {
      "value": "MORNING_BREAK",
      "label": "Matin",
      "description": "Après la récréation",
    },

    {
      "value": "AFTERNOON_ENTRY",
      "label": "Après-midi",
      "description": "Avant la récréation",
    },

    {
      "value": "AFTERNOON_BREAK",
      "label": "Après-midi",
      "description": "Après la récréation",
    },

  ];

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    if (isPrimary) {

      return _buildPrimary();

    }

    return _buildSecondary();

  }

  //----------------------------------------------------------
  // PRIMAIRE
  //----------------------------------------------------------

  Widget _buildPrimary() {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(

          "Période de l'appel",

          style: TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.bold,

          ),

        ),

        const SizedBox(height: 6),

        Text(

          "Sélectionnez le moment de la journée.",

          style: TextStyle(

            color: Colors.grey.shade600,

            fontSize: 14,

          ),

        ),

        const SizedBox(height: 16),

        ...primaryPeriods.map(

          (period) {

            final value =
                period["value"]!;

            final label =
                period["label"]!;

            final description =
                period["description"]!;

            final selected =
                selectedPeriod == value;

            return Padding(

              padding:
                  const EdgeInsets.only(
                bottom: 12,
              ),

              child: _PeriodTile(

                value: value,

                label: label,

                description:
                    description,

                selected: selected,

                enabled: enabled,

                onTap: () {

                  onPeriodSelected
                      ?.call(value);

                },

              ),

            );

          },

        ),

      ],

    );

  }

  //----------------------------------------------------------
  // SECONDAIRE
  //----------------------------------------------------------

  Widget _buildSecondary() {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(

          "Cours",

          style: TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.bold,

          ),

        ),

        const SizedBox(height: 6),

        Text(

          "Sélectionnez le cours pour lequel effectuer l'appel.",

          style: TextStyle(

            color: Colors.grey.shade600,

            fontSize: 14,

          ),

        ),

        const SizedBox(height: 16),

        if (sessions.isEmpty)

          _EmptySessions()

        else

          ...sessions.map(

            (session) {

              final selected =
                  selectedSessionId ==
                      session.id;

              return Padding(

                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),

                child: _ScheduleSessionTile(

                  session: session,

                  selected: selected,

                  enabled: enabled,

                  onTap: () {

                    onSessionSelected
                        ?.call(session);

                  },

                ),

              );

            },

          ),

      ],

    );

  }

}


//============================================================
// PERIODE PRIMAIRE
//============================================================

class _PeriodTile extends StatelessWidget {

  final String value;

  final String label;

  final String description;

  final bool selected;

  final bool enabled;

  final VoidCallback? onTap;

  const _PeriodTile({

    required this.value,

    required this.label,

    required this.description,

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
            BorderRadius.circular(18),

        onTap:
            enabled ? onTap : null,

        child: AnimatedContainer(

          duration:
              const Duration(
            milliseconds: 180,
          ),

          padding:
              const EdgeInsets.all(16),

          decoration: BoxDecoration(

            color: selected

                ? const Color(
                    0xff6214BE,
                  ).withOpacity(.08)

                : Colors.white,

            borderRadius:
                BorderRadius.circular(18),

            border: Border.all(

              color: selected

                  ? const Color(
                      0xff6214BE,
                    )

                  : Colors.grey.shade200,

              width:
                  selected ? 1.5 : 1,

            ),

          ),

          child: Row(

            children: [

              Container(

                width: 48,

                height: 48,

                decoration:
                    BoxDecoration(

                  color: selected

                      ? const Color(
                          0xff6214BE,
                        )

                      : Colors.grey.shade100,

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),

                ),

                child: Icon(

                  _periodIcon(value),

                  color: selected

                      ? Colors.white

                      : Colors.grey.shade700,

                ),

              ),

              const SizedBox(width: 14),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      label,

                      style: TextStyle(

                        fontSize: 16,

                        fontWeight:
                            FontWeight.w700,

                        color: selected

                            ? const Color(
                                0xff6214BE,
                              )

                            : const Color(
                                0xff1F2937,
                              ),

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      description,

                      style: TextStyle(

                        fontSize: 13,

                        color:
                            Colors.grey.shade600,

                      ),

                    ),

                  ],

                ),

              ),

              const SizedBox(width: 12),

              Icon(

                selected

                    ? Icons
                        .radio_button_checked

                    : Icons
                        .radio_button_off,

                color: selected

                    ? const Color(
                        0xff6214BE,
                      )

                    : Colors.grey.shade400,

              ),

            ],

          ),

        ),

      ),

    );

  }

  IconData _periodIcon(
    String value,
  ) {

    switch (value) {

      case "MORNING_ENTRY":

        return Icons.wb_sunny_outlined;

      case "MORNING_BREAK":

        return Icons.free_breakfast_outlined;

      case "AFTERNOON_ENTRY":

        return Icons.wb_sunny;

      case "AFTERNOON_BREAK":

        return Icons.free_breakfast;

      default:

        return Icons.access_time;

    }

  }

}


//============================================================
// COURS SECONDAIRE
//============================================================

class _ScheduleSessionTile
    extends StatelessWidget {

  final TeacherAttendanceSessionModel session;

  final bool selected;

  final bool enabled;

  final VoidCallback? onTap;

  const _ScheduleSessionTile({

    required this.session,

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
            BorderRadius.circular(18),

        onTap:
            enabled ? onTap : null,

        child: AnimatedContainer(

          duration:
              const Duration(
            milliseconds: 180,
          ),

          padding:
              const EdgeInsets.all(16),

          decoration: BoxDecoration(

            color: selected

                ? Colors.blue.withOpacity(.08)

                : Colors.white,

            borderRadius:
                BorderRadius.circular(18),

            border: Border.all(

              color: selected

                  ? Colors.blue

                  : Colors.grey.shade200,

              width:
                  selected ? 1.5 : 1,

            ),

          ),

          child: Row(

            children: [

              Container(

                width: 48,

                height: 48,

                decoration:
                    BoxDecoration(

                  color: selected

                      ? Colors.blue

                      : Colors.blue
                          .withOpacity(.08),

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),

                ),

                child: Icon(

                  Icons.schedule,

                  color: selected

                      ? Colors.white

                      : Colors.blue,

                ),

              ),

              const SizedBox(width: 14),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      session.subject ??
                          "Cours",

                      style:
                          const TextStyle(

                        fontSize: 16,

                        fontWeight:
                            FontWeight.w700,

                      ),

                    ),

                    const SizedBox(height: 5),

                    Text(

                      session.classroomName,

                      style: TextStyle(

                        fontSize: 14,

                        color:
                            Colors.grey.shade700,

                      ),

                    ),

                    if (session.status !=
                        "OPEN") ...[

                      const SizedBox(
                        height: 5,
                      ),

                      Text(

                        session.statusLabel,

                        style: TextStyle(

                          fontSize: 12,

                          color:
                              session.isClosed

                                  ? Colors.green
                                  : Colors.red,

                          fontWeight:
                              FontWeight.w600,

                        ),

                      ),

                    ],

                  ],

                ),

              ),

              Icon(

                selected

                    ? Icons
                        .radio_button_checked

                    : Icons
                        .radio_button_off,

                color: selected

                    ? Colors.blue

                    : Colors.grey.shade400,

              ),

            ],

          ),

        ),

      ),

    );

  }

}


//============================================================
// AUCUNE SESSION
//============================================================

class _EmptySessions
    extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(24),

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

          Icon(

            Icons.event_busy,

            size: 48,

            color: Colors.grey.shade400,

          ),

          const SizedBox(height: 12),

          Text(

            "Aucun cours disponible",

            style: TextStyle(

              fontSize: 16,

              fontWeight:
                  FontWeight.w600,

              color:
                  Colors.grey.shade700,

            ),

          ),

          const SizedBox(height: 5),

          Text(

            "Aucun cours de votre emploi du temps n'est disponible pour l'appel.",

            textAlign:
                TextAlign.center,

            style: TextStyle(

              fontSize: 13,

              color:
                  Colors.grey.shade500,

            ),

          ),

        ],

      ),

    );

  }

}