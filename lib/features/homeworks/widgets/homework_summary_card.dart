import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import '../models/homework_model.dart';

class HomeworkSummaryCard extends StatelessWidget {

  final List<HomeworkModel> homeworks;

  const HomeworkSummaryCard({

    super.key,

    required this.homeworks,

  });

  @override
  Widget build(BuildContext context) {

    final total = homeworks.length;

    final pending =

        homeworks.where(

          (e) => e.isPending,

        ).length;

    final submitted =

        homeworks.where(

          (e) => e.isSubmitted,

        ).length;

    final late =

        homeworks.where(

          (e) => e.isLate,

        ).length;

    final missing =

        homeworks.where(

          (e) => e.isMissing,

        ).length;

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        gradient: const LinearGradient(

          colors: [

            AppColors.primary,

            Color(0xff7C3AED),

          ],

        ),

        borderRadius:

            BorderRadius.circular(24),

      ),

      child: Column(

        crossAxisAlignment:

            CrossAxisAlignment.start,

        children: [

          const Text(

            "Devoirs",

            style: TextStyle(

              color: Colors.white,

              fontWeight: FontWeight.bold,

              fontSize: 22,

            ),

          ),

          const SizedBox(height: 6),

          Text(

            "$total devoir${total > 1 ? "s" : ""}",

            style: const TextStyle(

              color: Colors.white70,

            ),

          ),

          const SizedBox(height: 24),

          Row(

            children: [

              Expanded(

                child: _StatCard(

                  icon: Icons.schedule,

                  value: pending.toString(),

                  label: "À rendre",

                  color: Colors.orange,

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                child: _StatCard(

                  icon: Icons.check_circle,

                  value: submitted.toString(),

                  label: "Remis",

                  color: Colors.green,

                ),

              ),

            ],

          ),

          const SizedBox(height: 12),

          Row(

            children: [

              Expanded(

                child: _StatCard(

                  icon: Icons.warning,

                  value: late.toString(),

                  label: "Retard",

                  color: Colors.red,

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                child: _StatCard(

                  icon: Icons.cancel,

                  value: missing.toString(),

                  label: "Non remis",

                  color: Colors.redAccent,

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}

class _StatCard extends StatelessWidget {

  final IconData icon;

  final String value;

  final String label;

  final Color color;

  const _StatCard({

    required this.icon,

    required this.value,

    required this.label,

    required this.color,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:

            BorderRadius.circular(18),

      ),

      child: Column(

        children: [

          Icon(

            icon,

            color: color,

            size: 28,

          ),

          const SizedBox(height: 10),

          Text(

            value,

            style: const TextStyle(

              fontSize: 24,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 4),

          Text(

            label,

            style: const TextStyle(

              fontSize: 12,

            ),

            textAlign: TextAlign.center,

          ),

        ],

      ),

    );

  }

}