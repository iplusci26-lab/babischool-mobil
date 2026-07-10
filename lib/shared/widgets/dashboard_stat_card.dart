import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'premium_card.dart';

class DashboardStatCard extends StatelessWidget {

  final IconData icon;

  final String title;

  final String value;

  final Color color;

  final VoidCallback? onTap;

  const DashboardStatCard({

    super.key,

    required this.icon,

    required this.title,

    required this.value,

    required this.color,

    this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    return Material(

      color: Colors.transparent,

      child: InkWell(

        onTap: onTap,

        borderRadius: BorderRadius.circular(24),

        child: PremiumCard(

          child: Row(

            children: [

              //--------------------------------------------------
              // ICONE
              //--------------------------------------------------

              Container(

                width: 60,

                height: 60,

                decoration: BoxDecoration(

                  color: color.withOpacity(.12),

                  borderRadius:

                      BorderRadius.circular(18),

                ),

                child: Icon(

                  icon,

                  color: color,

                  size: 30,

                ),

              ),

              const SizedBox(width: 18),

              //--------------------------------------------------
              // TEXTE
              //--------------------------------------------------

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      title,

                      style: TextStyle(

                        color: Colors.grey.shade600,

                        fontSize: 14,

                      ),

                    ),

                    const SizedBox(height: 6),

                    Text(

                      value,

                      style: const TextStyle(

                        fontSize: 24,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                  ],

                ),

              ),

              //--------------------------------------------------
              // FLECHE
              //--------------------------------------------------

              if (onTap != null)

                Icon(

                  Icons.arrow_forward_ios,

                  size: 18,

                  color: Colors.grey.shade400,

                ),

            ],

          ),

        ),

      ),

    );

  }

}