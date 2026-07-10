import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {

  const AuthHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        Container(

          height: 90,

          width: 90,

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius: BorderRadius.circular(25),

            boxShadow: const [

              BoxShadow(

                blurRadius: 20,

                color: Colors.black12,

                offset: Offset(0, 8),

              ),

            ],

          ),

          child: const Icon(

            Icons.school_rounded,

            color: Color(0xff6214BE),

            size: 52,

          ),

        ),

        const SizedBox(height: 24),

        const Text(

          "BABISCHOOL",

          style: TextStyle(

            fontSize: 34,

            fontWeight: FontWeight.bold,

            color: Colors.white,

            letterSpacing: 2,

          ),

        ),

        const SizedBox(height: 8),

        const Text(

          "La plateforme scolaire intelligente",

          style: TextStyle(

            color: Colors.white70,

            fontSize: 16,

          ),

        ),

      ],

    );

  }

}