import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {

  final String name;

  final String? imageUrl;

  final double radius;

  const AppAvatar({

    super.key,

    required this.name,

    this.imageUrl,

    this.radius = 26,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    if (

      imageUrl != null &&

      imageUrl!.isNotEmpty

    ) {

      return CircleAvatar(

        radius: radius,

        backgroundImage:
        NetworkImage(
          imageUrl!,
        ),
      );
    }

    final cleanName = name.trim();

    String initials = "?";

    if (cleanName.isNotEmpty) {

      final names = cleanName
          .split(RegExp(r"\s+"));

      if (
          names.length >= 2 &&
          names.first.isNotEmpty &&
          names.last.isNotEmpty) {

        initials =
            "${names.first[0]}${names.last[0]}";

      } else if (names.first.isNotEmpty) {

        initials = names.first[0];
      }
    }

    return CircleAvatar(

      radius: radius,

      backgroundColor:
      AppColors.primary,

      child: Text(

        initials.toUpperCase(),

        style: const TextStyle(

          color: Colors.white,

          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }
}