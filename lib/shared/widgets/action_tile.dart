import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'premium_card.dart';

class ActionTile extends StatelessWidget {

  final IconData icon;

  final String title;

  final String subtitle;

  final Color color;

  final VoidCallback onTap;

  const ActionTile({

    super.key,

    required this.icon,

    required this.title,

    required this.subtitle,

    required this.color,

    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 16),

      child: InkWell(

        borderRadius: BorderRadius.circular(22),

        onTap: onTap,

        child: PremiumCard(

          child: Row(

            children: [

              //--------------------------------------------------
              // ICONE
              //--------------------------------------------------

              Container(

                width: 58,

                height: 58,

                decoration: BoxDecoration(

                  color: color.withOpacity(.12),

                  borderRadius: BorderRadius.circular(18),

                ),

                child: Icon(

                  icon,

                  color: color,

                  size: 30,

                ),

              ),

              const SizedBox(width: 18),

              //--------------------------------------------------
              // TITRES
              //--------------------------------------------------

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      title,

                      style: const TextStyle(

                        fontSize: 17,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      subtitle,

                      style: TextStyle(

                        color: Colors.grey.shade600,

                        fontSize: 14,

                      ),

                    ),

                  ],

                ),

              ),

              //--------------------------------------------------
              // FLECHE
              //--------------------------------------------------

              const Icon(

                Icons.arrow_forward_ios,

                size: 18,

                color: Colors.grey,

              ),

            ],

          ),

        ),

      ),

    );

  }

}