import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {

  final String title;

  final String message;

  final IconData icon;

  const EmptyView({

    super.key,

    required this.title,

    required this.message,

    this.icon = Icons.inbox_outlined,

  });

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Padding(

        padding: const EdgeInsets.symmetric(

          horizontal: 32,

        ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(

              width: 90,

              height: 90,

              decoration: BoxDecoration(

                color: const Color(0xff6214BE).withValues(
                  alpha: .08,
                ),

                shape: BoxShape.circle,

              ),

              child: Icon(

                icon,

                size: 46,

                color: const Color(0xff6214BE),

              ),

            ),

            const SizedBox(height: 24),

            Text(

              title,

              textAlign: TextAlign.center,

              style: const TextStyle(

                fontSize: 22,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 10),

            Text(

              message,

              textAlign: TextAlign.center,

              style: TextStyle(

                color: Colors.grey.shade600,

                height: 1.5,

              ),

            ),

          ],

        ),

      ),

    );

  }

}