import 'package:flutter/material.dart';

class EmptyState
    extends StatelessWidget {

  final IconData icon;

  final String title;

  const EmptyState({

    super.key,

    required this.icon,

    required this.title,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(

            icon,

            size: 60,

            color: Colors.grey,
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            title,
          ),
        ],
      ),
    );
  }
}