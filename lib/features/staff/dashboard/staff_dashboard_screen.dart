import 'package:flutter/material.dart';

class StaffDashboardScreen extends StatelessWidget {

  const StaffDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child: Text(

          "Dashboard Personnel Administratif",

          style: TextStyle(

            fontSize: 22,

            fontWeight: FontWeight.bold,

          ),

        ),

      ),

    );

  }

}