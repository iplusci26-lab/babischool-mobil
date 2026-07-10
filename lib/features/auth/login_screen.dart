import 'package:flutter/material.dart';

import '../../core/storage/secure_storage_service.dart';

import 'services/auth_service.dart';

import 'splash_screen.dart';

import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/login_button.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();

}

class _LoginScreenState
    extends State<LoginScreen> {

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  bool obscurePassword = true;

  //--------------------------------------------------

  Future<void> login() async {

    if (phoneController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "Veuillez saisir votre numéro.",
          ),

        ),

      );

      return;

    }

    if (passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "Veuillez saisir votre mot de passe.",
          ),

        ),

      );

      return;

    }

    try {

      setState(() {

        loading = true;

      });

      final response =
          await AuthService().login(

        phone: phoneController.text.trim(),

        password:
            passwordController.text,

      );

      //--------------------------------------

      await SecureStorageService
          .saveAccessToken(

        response.access,

      );

      await SecureStorageService
          .saveRefreshToken(

        response.refresh,

      );

      await SecureStorageService
          .saveUserType(

        response.user.userType,

      );

      await SecureStorageService
          .saveUser(

        response.user.toJson(),

      );

      //--------------------------------------

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(

        context,

        MaterialPageRoute(

          builder: (_) =>
              const SplashScreen(),

        ),

        (_) => false,

      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)

          .showSnackBar(

        SnackBar(

          content: Text(

            e.toString(),

          ),

        ),

      );

    } finally {

      if (mounted) {

        setState(() {

          loading = false;

        });

      }

    }

  }

  //--------------------------------------------------

  @override
  void dispose() {

    phoneController.dispose();

    passwordController.dispose();

    super.dispose();

  }

  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF7F8FC),

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

            colors: [

              Color(0xff6214BE),

              Color(0xff8D4EF7),

              Color(0xffF7F8FC),

            ],

            stops: [

              0,

              .35,

              .35,

            ],

          ),

        ),

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.all(24),

              child: ConstrainedBox(

                constraints:

                    const BoxConstraints(

                  maxWidth: 420,

                ),

                child: Column(

                  children: [

                    //------------------------------------------------
                    // HEADER
                    //------------------------------------------------

                    const AuthHeader(),

                    const SizedBox(

                      height: 40,

                    ),

                    //------------------------------------------------
                    // CARD
                    //------------------------------------------------

                    Container(

                      padding:
                          const EdgeInsets.all(

                        28,

                      ),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:

                            BorderRadius.circular(

                          28,

                        ),

                        boxShadow: const [

                          BoxShadow(

                            blurRadius: 30,

                            color:

                                Colors.black12,

                            offset:

                                Offset(0, 12),

                          ),

                        ],

                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(

                            "Connexion",

                            style: TextStyle(

                              fontSize: 26,

                              fontWeight:
                                  FontWeight.bold,

                            ),

                          ),

                          const SizedBox(

                            height: 6,

                          ),

                          Text(

                            "Heureux de vous revoir 👋",

                            style: TextStyle(

                              color:
                                  Colors.grey.shade600,

                            ),

                          ),

                          const SizedBox(

                            height: 30,

                          ),

                          AuthTextField(

                            controller:
                                phoneController,

                            label:
                                "Téléphone",

                            icon:
                                Icons.phone_android,

                            keyboardType:
                                TextInputType.phone,

                          ),

                          const SizedBox(

                            height: 20,

                          ),

                          AuthTextField(

                            controller:
                                passwordController,

                            label:
                                "Mot de passe",

                            icon:
                                Icons.lock_outline,

                            obscure:
                                obscurePassword,

                            suffixIcon:

                                IconButton(

                              onPressed: () {

                                setState(() {

                                  obscurePassword =
                                      !obscurePassword;

                                });

                              },

                              icon: Icon(

                                obscurePassword

                                    ? Icons.visibility

                                    : Icons.visibility_off,

                              ),

                            ),

                          ),

                          const SizedBox(

                            height: 30,

                          ),

                          LoginButton(

                            loading: loading,

                            onPressed: login,

                          ),

                          const SizedBox(

                            height: 18,

                          ),

                          Center(

                            child: Text(

                              "Connexion sécurisée",

                              style: TextStyle(

                                color: Colors.grey.shade500,

                                fontSize: 12,

                              ),

                            ),

                          ),

                        ],

                      ),

                    ),

                    const SizedBox(

                      height: 24,

                    ),

                    Text(

                      "Version 1.0.0",

                      style: TextStyle(

                        color:
                            Colors.grey.shade600,

                      ),

                    ),

                  ],

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }

}