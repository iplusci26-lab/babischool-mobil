import 'package:flutter/material.dart';

class SectionTitle
    extends StatelessWidget {

  final String title;

  final String? action;

  final IconData? actionIcon;

  final VoidCallback? onPressed;

  const SectionTitle({

    super.key,

    required this.title,

    this.action,

    this.actionIcon,

    this.onPressed,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Row(

      children: [

        Expanded(

          child: Text(

            title,

            style: Theme.of(context)

                .textTheme

                .titleLarge

                ?.copyWith(

                  fontWeight:
                      FontWeight.bold,
                ),
          ),
        ),

        if (action != null)

          TextButton.icon(

            onPressed: onPressed,

            icon:

            actionIcon == null

                ? const SizedBox()

                : Icon(
                    actionIcon,
                    size: 18,
                  ),

            label: Text(
              action!,
            ),
          ),
      ],
    );
  }
}