import 'package:flutter/material.dart';

import '../../core/storage/secure_storage_service.dart';

import '../../shared/app_shell.dart';

import '../auth/login_screen.dart';

class SplashScreen
extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen>
  createState() =>
  _SplashScreenState();
}

class _SplashScreenState
extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();

    checkSession();
  }

  Future<void> checkSession()
  async {

    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );

    final token =
    await SecureStorageService
    .getAccessToken();

    if (!mounted) {
      return;
    }

    if (
      token != null &&
      token.isNotEmpty
    ) {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const AppShell(),
        ),
      );

      return;
    }

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
        const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return const Scaffold(

      body: Center(

        child: Text(

          "BABISCHOOL",

          style: TextStyle(

            fontSize: 32,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }
}