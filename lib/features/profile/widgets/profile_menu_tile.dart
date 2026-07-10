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

  return Padding(

    padding: const EdgeInsets.only(
      bottom: 12,
    ),

    child: Material(

      color: Colors.white,

      elevation: 1,

      shadowColor: const Color(
        0x11000000,
      ),

      borderRadius: BorderRadius.circular(
        18,
      ),

      clipBehavior: Clip.antiAlias,

      child: ListTile(

        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(

          horizontal: 16,

          vertical: 6,

        ),

        leading: Container(

          width: 40,

          height: 40,

          decoration: BoxDecoration(

            color: const Color(
              0xff6214BE,
            ).withValues(
              alpha: .10,
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

            fontWeight: FontWeight.w600,

          ),

        ),

        trailing: const Icon(

          Icons.chevron_right,

        ),

      ),

    ),

  );

}
}