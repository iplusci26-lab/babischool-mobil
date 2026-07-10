import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class DashboardHeader extends StatelessWidget {

  final String username;

  final String? subtitle;

  final String? avatar;

  const DashboardHeader({

    super.key,

    required this.username,

    this.subtitle,

    this.avatar,

  });

  @override
  Widget build(BuildContext context) {

    final now = DateTime.now();

    final months = [

      "",

      "janvier",

      "février",

      "mars",

      "avril",

      "mai",

      "juin",

      "juillet",

      "août",

      "septembre",

      "octobre",

      "novembre",

      "décembre",

    ];

    final date =

        "${now.day} ${months[now.month]} ${now.year}";

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color: AppColors.primary,

        borderRadius: BorderRadius.circular(26),

      ),

      child: Row(

        children: [

          CircleAvatar(

            radius: 32,

            backgroundColor: Colors.white,

            backgroundImage: avatar != null

                ? NetworkImage(avatar!)

                : null,

            child: avatar == null

                ? const Icon(

                    Icons.person,

                    size: 34,

                    color: AppColors.primary,

                  )

                : null,

          ),

          const SizedBox(width: 18),

          Expanded(

            child: Column(

              crossAxisAlignment:

                  CrossAxisAlignment.start,

              children: [

                const Text(

                  "Bonjour 👋",

                  style: TextStyle(

                    color: Colors.white70,

                    fontSize: 14,

                  ),

                ),

                const SizedBox(height: 6),

                Text(

                  username,

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 22,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                if (subtitle != null) ...[

                  const SizedBox(height: 6),

                  Text(

                    subtitle!,

                    style: const TextStyle(

                      color: Colors.white70,

                    ),

                  ),

                ],

                const SizedBox(height: 10),

                Text(

                  date,

                  style: const TextStyle(

                    color: Colors.white60,

                    fontSize: 12,

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