import 'package:flutter/material.dart';

import '../models/attendance_model.dart';

class AttendanceHistoryTile extends StatelessWidget {
  final AttendanceHistory history;

  const AttendanceHistoryTile({
    super.key,
    required this.history,
  });

  // ==========================================================
  // ICON
  // ==========================================================

  IconData get icon {
    switch (history.status) {
      case "PRESENT":
        return Icons.check_circle;

      case "ABSENT":
        return Icons.cancel;

      case "LATE":
        return Icons.schedule;

      case "EXCUSED":
        return Icons.assignment_turned_in;

      default:
        return Icons.help_outline;
    }
  }

  // ==========================================================
  // COLOR
  // ==========================================================

  Color get color {
    switch (history.status) {
      case "PRESENT":
        return Colors.green;

      case "ABSENT":
        return Colors.red;

      case "LATE":
        return Colors.orange;

      case "EXCUSED":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  // ==========================================================
  // LABEL
  // ==========================================================

  String get label {
    switch (history.status) {
      case "PRESENT":
        return "Présent";

      case "ABSENT":
        return "Absent";

      case "LATE":
        return "Retard";

      case "EXCUSED":
        return "Justifié";

      default:
        return history.status;
    }
  }

  // ==========================================================
  // PERIOD
  // ==========================================================

  String get periodLabel {
    switch (history.period) {
      case "MORNING_ENTRY":
        return "Matin avant récréation";

      case "MORNING_BREAK":
        return "Matin après récréation";

      case "AFTERNOON_ENTRY":
        return "Après-midi avant récréation";

      case "AFTERNOON_BREAK":
        return "Après-midi après récréation";

      default:
        return history.period ?? "Non renseigné";
    }
  }

  // ==========================================================
  // TIME
  // ==========================================================

  String get timeLabel {
    if (history.timeSlot == null) {
      return "Horaire non renseigné";
    }

    final slot = history.timeSlot!;

    return "${slot.startTime} - ${slot.endTime}";
  }

  // ==========================================================
  // SESSION TITLE
  // ==========================================================

  String get sessionTitle {
    if (history.sessionType == "SCHEDULE") {
      return history.subject?.name ?? "Cours non renseigné";
    }

    return periodLabel;
  }

  // ==========================================================
  // OPEN DETAILS
  // ==========================================================

  void showDetails(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                28,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ============================================
                // HANDLE
                // ============================================

                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color:
                          Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                // ============================================
                // HEADER
                // ============================================

                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration:
                          BoxDecoration(
                        color:
                            color.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 28,
                      ),
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            label,
                            style:
                                const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
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
                                  Colors.grey
                                      .shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 28,
                ),

                // ============================================
                // MATIERE
                // ============================================

                if (history.subject != null)
                  _DetailItem(
                    icon:
                        Icons.menu_book_outlined,
                    title:
                        "Matière",
                    value:
                        history.subject!.name,
                  ),

                if (history.subject != null)
                  const SizedBox(
                    height: 16,
                  ),

                // ============================================
                // TEACHER
                // ============================================

                if (history.teacher != null)
                  _DetailItem(
                    icon:
                        Icons.person_outline,
                    title:
                        "Enseignant",
                    value:
                        history.teacher!.name,
                  ),

                if (history.teacher != null)
                  const SizedBox(
                    height: 16,
                  ),

                // ============================================
                // TIME SLOT
                // ============================================

                if (history.timeSlot != null)
                  _DetailItem(
                    icon:
                        Icons.access_time_outlined,
                    title:
                        history.timeSlot!.name,
                    value:
                        timeLabel,
                  ),

                if (history.timeSlot != null)
                  const SizedBox(
                    height: 16,
                  ),

                // ============================================
                // ROOM
                // ============================================

                if (history.room.isNotEmpty)
                  _DetailItem(
                    icon:
                        Icons.meeting_room_outlined,
                    title:
                        "Salle",
                    value:
                        history.room,
                  ),

                if (history.room.isNotEmpty)
                  const SizedBox(
                    height: 16,
                  ),

                // ============================================
                // PERIOD
                // ============================================

                if (
                    history.sessionType !=
                        "SCHEDULE" &&
                    history.period != null)
                  _DetailItem(
                    icon:
                        Icons.access_time_outlined,
                    title:
                        "Période",
                    value:
                        periodLabel,
                  ),

                if (
                    history.sessionType !=
                        "SCHEDULE" &&
                    history.period != null)
                  const SizedBox(
                    height: 16,
                  ),

                // ============================================
                // STATUS
                // ============================================

                _DetailItem(
                  icon:
                      Icons.info_outline,
                  title:
                      "Statut",
                  value:
                      label,
                  valueColor:
                      color,
                ),

                // ============================================
                // LATE
                // ============================================

                if (
                    history.status == "LATE" &&
                    history.minutesLate > 0)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 16,
                    ),
                    child: _DetailItem(
                      icon:
                          Icons.timer_outlined,
                      title:
                          "Durée du retard",
                      value:
                          "${history.minutesLate} minutes",
                      valueColor:
                          Colors.orange,
                    ),
                  ),

                // ============================================
                // REMARKS
                // ============================================

                if (history.remarks
                    .trim()
                    .isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 16,
                    ),
                    child: _DetailItem(
                      icon:
                          Icons.notes_outlined,
                      title:
                          "Remarques",
                      value:
                          history.remarks,
                    ),
                  ),

                const SizedBox(
                  height: 28,
                ),

                // ============================================
                // CLOSE
                // ============================================

                SizedBox(
                  width:
                      double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF6214BE,
                      ),
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 15,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      "Fermer",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // ========================================================
    // NE PAS AFFICHER LES PRESENCES
    //
    // Seuls les absences et les retards sont affichés
    // ========================================================

    if (history.status == "PRESENT") {
      return const SizedBox.shrink();
    }

    return Material(
      color:
          Colors.transparent,
      child: InkWell(
        onTap: () {
          showDetails(
            context,
          );
        },
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        child: Container(
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
            color:
                Colors.white,
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
                blurRadius:
                    10,
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
              // ==============================================
              // ICON
              // ==============================================

              Container(
                width:
                    50,
                height:
                    50,
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
                  color:
                      color,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              // ==============================================
              // CONTENT
              // ==============================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    // STATUT

                    Text(
                      label,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize:
                            16,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    // MATIERE OU PERIODE

                    Text(
                      sessionTitle,
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF6214BE,
                        ),
                        fontWeight:
                            FontWeight.w600,
                        fontSize:
                            14,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    // DATE

                    Text(
                      history.date,
                      style:
                          TextStyle(
                        color:
                            Colors.grey
                                .shade600,
                        fontSize:
                            13,
                      ),
                    ),

                    // ENSEIGNANT

                    if (history.teacher != null)
                      Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          top: 3,
                        ),
                        child: Text(
                          history
                              .teacher!
                              .name,
                          style:
                              TextStyle(
                            color:
                                Colors.grey
                                    .shade600,
                            fontSize:
                                13,
                          ),
                        ),
                      ),

                    // HORAIRE

                    if (history.timeSlot != null)
                      Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          top: 3,
                        ),
                        child: Text(
                          timeLabel,
                          style:
                              TextStyle(
                            color:
                                Colors.grey
                                    .shade600,
                            fontSize:
                                13,
                          ),
                        ),
                      ),

                    // RETARD

                    if (
                        history.status ==
                            "LATE" &&
                        history.minutesLate >
                            0)
                      Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          top: 4,
                        ),
                        child: Text(
                          "Retard : ${history.minutesLate} min",
                          style:
                              const TextStyle(
                            color:
                                Colors.orange,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ==============================================
              // ARROW
              // ==============================================

              Icon(
                Icons.chevron_right,
                color:
                    Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// DETAIL ITEM
// ==========================================================

class _DetailItem extends StatelessWidget {
  final IconData icon;

  final String title;

  final String value;

  final Color? valueColor;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
          color:
              const Color(
            0xFF6214BE,
          ),
        ),

        const SizedBox(
          width: 14,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    TextStyle(
                  fontSize:
                      12,
                  color:
                      Colors.grey.shade500,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                value,
                style:
                    TextStyle(
                  fontSize:
                      16,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}