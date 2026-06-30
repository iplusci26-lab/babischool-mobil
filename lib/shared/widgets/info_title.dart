import 'package:flutter/material.dart';

class InfoTile
    extends StatelessWidget {

  final String title;

  final String value;

  const InfoTile({

    super.key,

    required this.title,

    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Column(

      children: [

        Text(

          value,

          style:
          const TextStyle(

            fontWeight:
            FontWeight.bold,

            fontSize: 18,
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        Text(title),
      ],
    );
  }
}