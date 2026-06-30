import 'package:flutter/material.dart';

class QuickActions
    extends StatelessWidget {

    final VoidCallback onNotes;

    final VoidCallback onAttendance;

    final VoidCallback onPayments;

    final VoidCallback onAnnouncements;

  const QuickActions({
    super.key,
    required this.onNotes,

    required this.onAttendance,

    required this.onPayments,

    required this.onAnnouncements,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(

          "Accès rapide",

          style: TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        Row(

          children: [

            Expanded(
              child: _ActionCard(
                icon: Icons.menu_book,
                title: "Notes",
                onTap:onNotes,
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: _ActionCard(
                icon: Icons.check_circle,
                title: "Présence",
                onTap:onNotes,
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: _ActionCard(
                icon: Icons.payments,
                title: "Paiements",
                onTap:onNotes,
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: _ActionCard(
                icon: Icons.campaign,
                title: "Annonces",
                onTap:onNotes,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard
    extends StatelessWidget {

  final IconData icon;

  final VoidCallback onTap;

  final String title;

  const _ActionCard({

    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

return GestureDetector(
        onTap: onTap,
    child:Container(

      height: 90,

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        boxShadow: [

          BoxShadow(

            color: Colors.black
                .withValues(
              alpha: 0.05,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(

            icon,

            color:
                const Color(
              0xff6214BE,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(title),
        ],
      ),

        )
    );
  }
}