import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {

  final double size;

  final bool showText;

  final String? subtitle;

  const AppLogo({

    super.key,

    this.size = 48,

    this.showText = true,

    this.subtitle,

  });

  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisSize: MainAxisSize.min,

      children: [

        Container(

          height: size,

          width: size,

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius: BorderRadius.circular(

              size * .28,

            ),

            boxShadow: [

              BoxShadow(

                color: Colors.black.withOpacity(.05),

                blurRadius: 12,

                offset: const Offset(

                  0,

                  4,

                ),

              ),

            ],

          ),

          padding: EdgeInsets.all(

            size * .12,

          ),

          child: Image.asset(

            "assets/images/babischool_logo.png",

            fit: BoxFit.contain,

          ),

        ),

        if (showText) ...[

          const SizedBox(

            width: 12,

          ),

          Column(

            crossAxisAlignment:

                CrossAxisAlignment.start,

            mainAxisAlignment:

                MainAxisAlignment.center,

            children: [

              const Text(

                "BabiSchool",

                style: TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                  color: Color(0xff23314D),

                ),

              ),

              const SizedBox(

                height: 2,

              ),

              Text(

                subtitle ??

                    "Le suivi scolaire de votre enfant à distance",

                style: TextStyle(

                  color: Colors.grey.shade600,

                  fontSize: 11,

                ),

              ),

            ],

          ),

        ],

      ],

    );

  }

}