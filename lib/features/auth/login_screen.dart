import 'package:flutter/material.dart';

import '../../core/storage/secure_storage_service.dart';
import '../../core/notifications/notification_service.dart';

import 'services/auth_service.dart';
import 'splash_screen.dart';
import 'contact_screen.dart';

import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  //--------------------------------------------------
  // LOGIN
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

      final response = await AuthService().login(
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );

      //--------------------------------------
      // SAUVEGARDE DES TOKENS
      //--------------------------------------

      await SecureStorageService.saveAccessToken(
        response.access,
      );

      await SecureStorageService.saveRefreshToken(
        response.refresh,
      );

      await SecureStorageService.saveUserType(
        response.user.userType,
      );

      await SecureStorageService.saveUser(
        response.user.toJson(),
      );

      //--------------------------------------
      // ENREGISTRER LE TOKEN FCM
      //--------------------------------------

      await NotificationService.instance.registerDevice();

      //--------------------------------------

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        ),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Numéro ou mot de passe incorrect !",
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
  // CONTACT
  //--------------------------------------------------

  void openContact() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ContactScreen(),
      ),
    );
  }

  //--------------------------------------------------
  // DISPOSE
  //--------------------------------------------------

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  //--------------------------------------------------
  // BUILD
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

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
              padding: const EdgeInsets.all(24),

              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 420,
                ),

                child: Column(
                  children: [

                    //------------------------------------------------
                    // HEADER
                    //------------------------------------------------

                    const AuthHeader(),

                    const SizedBox(
                      height: 50,
                    ),

                    //------------------------------------------------
                    // CARD
                    //------------------------------------------------

                    Container(
                      padding: const EdgeInsets.all(28),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),

                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 30,
                            color: Colors.black12,
                            offset: Offset(0, 12),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            "Heureux de vous revoir 👋",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          //------------------------------------------------
                          // TELEPHONE
                          //------------------------------------------------

                          AuthTextField(
                            controller: phoneController,
                            label: "Téléphone",
                            icon: Icons.phone_android,
                            keyboardType:
                                TextInputType.phone,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //------------------------------------------------
                          // MOT DE PASSE
                          //------------------------------------------------

                          AuthTextField(
                            controller: passwordController,
                            label: "Mot de passe",
                            icon: Icons.lock_outline,
                            obscure: obscurePassword,

                            suffixIcon: IconButton(
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

                          //------------------------------------------------
                          // BOUTON CONNEXION
                          //------------------------------------------------

                          LoginButton(
                            loading: loading,
                            onPressed: login,
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          //------------------------------------------------
                          // CONNEXION SECURISEE
                          //------------------------------------------------

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
                      height: 20,
                    ),

                    //------------------------------------------------
                    // NOUS CONTACTER
                    //------------------------------------------------

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius:
                            BorderRadius.circular(18),

                        border: Border.all(
                          color: const Color(0xff6214BE)
                              .withOpacity(0.08),
                        ),
                      ),

                      child: Column(
                        children: [

                          //------------------------------------------------
                          // TITRE
                          //------------------------------------------------

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [
                              const Icon(
                                Icons.school_outlined,
                                size: 20,
                                color: Color(0xff6214BE),
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              Text(
                                "Vous découvrez BabiSchool ?",
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                  color:
                                      Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          //------------------------------------------------
                          // DESCRIPTION
                          //------------------------------------------------

                          Text(
                            "L'application est destinée aux, "
                            "parents et enseignants des écoles partenaires.",
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          //------------------------------------------------
                          // BOUTON CONTACT
                          //------------------------------------------------

                          TextButton.icon(
                            onPressed: openContact,

                            icon: const Icon(
                              Icons.headset_mic_outlined,
                              size: 18,
                            ),

                            label: const Text(
                              "Nous contacter",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color(0xff6214BE),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    //------------------------------------------------
                    // VERSION
                    //------------------------------------------------

                    Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: Colors.grey.shade600,
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