import 'package:flutter/material.dart';

class AdBanner
extends StatelessWidget {

  const AdBanner({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      height: 120,

      margin:
      const EdgeInsets.symmetric(
        vertical: 20,
      ),

      decoration:
      BoxDecoration(

        borderRadius:
        BorderRadius.circular(
          20,
        ),

        color:
        Colors.orange.shade100,
      ),

      child: const Center(

        child: Text(

          "Espace Publicitaire",

          style: TextStyle(
            fontSize: 20,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }
}