import 'package:flutter/material.dart';

import '../../core/storage/secure_storage_service.dart';

import '../dashboard/dashboard_screen.dart';
import '../../shared/app_shell.dart';

import 'auth_service.dart';

class LoginScreen
extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen>
  createState() =>
  _LoginScreenState();
}

class _LoginScreenState
extends State<LoginScreen> {

  final phoneController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  bool loading = false;

  Future<void> login()
  async {

      try {

      setState(() {

        loading = true;
      });

      final result =
      await AuthService().login(

        phone:
        phoneController.text,

        password:
        passwordController.text,
      );

      await SecureStorageService
      .saveAccessToken(
        result["access"],
      );

      await SecureStorageService
      .saveRefreshToken(
        result["refresh"],
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const AppShell(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      body: Center(

        child: SizedBox(

          width: 400,

          child: Padding(

            padding:
            const EdgeInsets.all(
              24,
            ),

            child: Column(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                const Text(

                  "BABISCHOOL",

                  style: TextStyle(

                    fontSize: 32,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                TextField(

                  controller:
                  phoneController,

                  decoration:
                  const InputDecoration(

                    labelText:
                    "Téléphone",
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                TextField(

                  controller:
                  passwordController,

                  obscureText: true,

                  decoration:
                  const InputDecoration(

                    labelText:
                    "Mot de passe",
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                ElevatedButton(

                  onPressed:
                  loading
                  ? null
                  : login,

                  child:

                  loading

                  ? const CircularProgressIndicator()

                  : const Text(
                    "Connexion",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}