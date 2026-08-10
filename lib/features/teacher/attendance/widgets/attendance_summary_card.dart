import 'package:flutter/material.dart';

class AttendanceSummaryCard extends StatelessWidget {

  final int total;

  final int present;

  final int absent;

  final int late;

  const AttendanceSummaryCard({

    super.key,

    required this.total,

    required this.present,

    required this.absent,

    required this.late,

  });

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    final processed =
        present + absent + late;

    final remaining =
        total - processed;

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(

          color:
              Colors.grey.shade200,

        ),

      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          //--------------------------------------------------
          // HEADER
          //--------------------------------------------------

          Row(

            children: [

              Container(

                width: 44,

                height: 44,

                decoration: BoxDecoration(

                  color: const Color(
                    0xff6214BE,
                  ).withOpacity(.10),

                  borderRadius:
                      BorderRadius.circular(14),

                ),

                child: const Icon(

                  Icons.fact_check_outlined,

                  color: Color(
                    0xff6214BE,
                  ),

                ),

              ),

              const SizedBox(width: 12),

              const Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Résumé de l'appel",

                      style: TextStyle(

                        fontSize: 17,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),

                    SizedBox(height: 3),

                    Text(

                      "État actuel des présences",

                      style: TextStyle(

                        fontSize: 12,

                        color: Colors.grey,

                      ),

                    ),

                  ],

                ),

              ),

              //------------------------------------------------
              // TOTAL
              //------------------------------------------------

              Container(

                padding:
                    const EdgeInsets.symmetric(

                  horizontal: 12,

                  vertical: 7,

                ),

                decoration: BoxDecoration(

                  color:
                      Colors.grey.shade100,

                  borderRadius:
                      BorderRadius.circular(20),

                ),

                child: Text(

                  "$total élèves",

                  style: const TextStyle(

                    fontSize: 12,

                    fontWeight:
                        FontWeight.w600,

                  ),

                ),

              ),

            ],

          ),

          const SizedBox(height: 20),

          //--------------------------------------------------
          // COMPTEURS
          //--------------------------------------------------

          Row(

            children: [

              Expanded(

                child: _SummaryItem(

                  value: present,

                  label: "Présents",

                  color: Colors.green,

                  icon:
                      Icons.check_circle_outline,

                ),

              ),

              const SizedBox(width: 10),

              Expanded(

                child: _SummaryItem(

                  value: absent,

                  label: "Absents",

                  color: Colors.red,

                  icon:
                      Icons.cancel_outlined,

                ),

              ),

              const SizedBox(width: 10),

              Expanded(

                child: _SummaryItem(

                  value: late,

                  label: "Retards",

                  color: Colors.orange,

                  icon:
                      Icons.schedule,

                ),

              ),

            ],

          ),

          //--------------------------------------------------
          // RESTANTS
          //--------------------------------------------------

          if (remaining > 0) ...[

            const SizedBox(height: 16),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.symmetric(

                horizontal: 14,

                vertical: 11,

              ),

              decoration: BoxDecoration(

                color: Colors.orange
                    .withOpacity(.08),

                borderRadius:
                    BorderRadius.circular(14),

              ),

              child: Row(

                children: [

                  Icon(

                    Icons.info_outline,

                    size: 18,

                    color:
                        Colors.orange.shade700,

                  ),

                  const SizedBox(width: 8),

                  Expanded(

                    child: Text(

                      "$remaining élève"
                      "${remaining > 1 ? "s" : ""} "
                      "à traiter",

                      style: TextStyle(

                        color:
                            Colors.orange.shade800,

                        fontSize: 13,

                        fontWeight:
                            FontWeight.w600,

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ] else ...[

            const SizedBox(height: 16),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.symmetric(

                horizontal: 14,

                vertical: 11,

              ),

              decoration: BoxDecoration(

                color: Colors.green
                    .withOpacity(.08),

                borderRadius:
                    BorderRadius.circular(14),

              ),

              child: Row(

                children: [

                  const Icon(

                    Icons.check_circle,

                    size: 18,

                    color: Colors.green,

                  ),

                  const SizedBox(width: 8),

                  const Expanded(

                    child: Text(

                      "Tous les élèves ont été traités",

                      style: TextStyle(

                        color: Colors.green,

                        fontSize: 13,

                        fontWeight:
                            FontWeight.w600,

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ],

        ],

      ),

    );

  }

}


//============================================================
// ITEM
//============================================================

class _SummaryItem extends StatelessWidget {

  final int value;

  final String label;

  final Color color;

  final IconData icon;

  const _SummaryItem({

    required this.value,

    required this.label,

    required this.color,

    required this.icon,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.symmetric(

        vertical: 14,

        horizontal: 8,

      ),

      decoration: BoxDecoration(

        color:
            color.withOpacity(.07),

        borderRadius:
            BorderRadius.circular(16),

      ),

      child: Column(

        children: [

          Icon(

            icon,

            size: 20,

            color: color,

          ),

          const SizedBox(height: 7),

          Text(

            value.toString(),

            style: TextStyle(

              fontSize: 21,

              fontWeight:
                  FontWeight.bold,

              color: color,

            ),

          ),

          const SizedBox(height: 3),

          Text(

            label,

            textAlign:
                TextAlign.center,

            style: TextStyle(

              fontSize: 11,

              color:
                  Colors.grey.shade700,

              fontWeight:
                  FontWeight.w500,

            ),

          ),

        ],

      ),

    );

  }

}