import 'package:flutter/material.dart';

import '../services/profile_service.dart';

class ChangePasswordScreen
    extends StatefulWidget {

  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<ChangePasswordScreen>
      createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final formKey =
      GlobalKey<FormState>();

  final service =
      ProfileService();

  final currentController =
      TextEditingController();

  final newController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  bool loading = false;

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;

  Future<void> save() async {

    if (!formKey.currentState!
        .validate()) {
      return;
    }

    try {

      setState(() {
        loading = true;
      });

      await service.changePassword(

        currentPassword:
            currentController.text,

        newPassword:
            newController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Mot de passe modifié",
          ),
        ),
      );

      Navigator.pop(
        context,
      );

    } catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content:
              Text(e.toString()),
        ),
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xffF7F8FA,
      ),

      appBar: AppBar(
        title: const Text(
          "Mot de passe",
        ),
      ),

      body: Form(

        key: formKey,

        child: ListView(

          padding:
              const EdgeInsets.all(
            20,
          ),

          children: [

            _passwordField(
              controller:
                  currentController,
              label:
                  "Mot de passe actuel",
              visible:
                  showCurrent,
              onToggle: () {

                setState(() {
                  showCurrent =
                      !showCurrent;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            _passwordField(
              controller:
                  newController,
              label:
                  "Nouveau mot de passe",
              visible:
                  showNew,
              onToggle: () {

                setState(() {
                  showNew =
                      !showNew;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            _passwordField(
              controller:
                  confirmController,
              label:
                  "Confirmation",
              visible:
                  showConfirm,
              onToggle: () {

                setState(() {
                  showConfirm =
                      !showConfirm;
                });
              },
            ),

            const SizedBox(
              height: 30,
            ),

            ElevatedButton(

              onPressed:
                  loading
                      ? null
                      : save,

              style:
                  ElevatedButton
                      .styleFrom(

                backgroundColor:
                    const Color(
                  0xff6214BE,
                ),

                padding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 16,
                ),
              ),

              child: loading

                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                          CircularProgressIndicator(
                        color:
                            Colors
                                .white,
                      ),
                    )

                  : const Text(
                      "Modifier",
                      style:
                          TextStyle(
                        color:
                            Colors
                                .white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({

    required TextEditingController
        controller,

    required String label,

    required bool visible,

    required VoidCallback
        onToggle,
  }) {

    return TextFormField(

      controller: controller,

      obscureText:
          !visible,

      decoration:
          InputDecoration(

        labelText:
            label,

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),

        suffixIcon:
            IconButton(

          onPressed:
              onToggle,

          icon: Icon(

            visible

                ? Icons
                    .visibility

                : Icons
                    .visibility_off,
          ),
        ),
      ),

      validator: (value) {

        if (value == null ||
            value.isEmpty) {
          return "Champ obligatoire";
        }

        if (label ==
                "Nouveau mot de passe" &&
            value.length != 6) {

          return "6 chiffres requis";
        }

        if (label ==
                "Confirmation" &&
            value !=
                newController.text) {

          return "Les mots de passe ne correspondent pas";
        }

        return null;
      },
    );
  }
}