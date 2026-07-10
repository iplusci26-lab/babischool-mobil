import 'package:flutter/material.dart';

class StaffAnnouncementsScreen extends StatelessWidget {

  const StaffAnnouncementsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child: Text(

          "Annonces",

          style: TextStyle(

            fontSize: 22,

            fontWeight: FontWeight.bold,

          ),

        ),

      ),

    );

  }

}