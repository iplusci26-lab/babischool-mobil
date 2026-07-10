import 'package:flutter/material.dart';
import 'features/auth/splash_screen.dart';
import 'core/api/api_client.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.initialize();

  runApp(
    const BabiSchoolApp(),
  );
}

class BabiSchoolApp
    extends StatelessWidget {

  const BabiSchoolApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BABISCHOOL",
      home: const SplashScreen(),
    );
  }
}