import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: const [

          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 3),
            color: Color(
              0x11000000,
            ),
          ),
        ],
      ),

      child: ListTile(

        onTap: onTap,

        leading: Container(

          width: 40,
          height: 40,

          decoration: BoxDecoration(

            color: const Color(
              0xff6214BE,
            ).withValues(
              alpha: 0.1,
            ),

            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),

          child: Icon(
            icon,
            color: const Color(
              0xff6214BE,
            ),
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}