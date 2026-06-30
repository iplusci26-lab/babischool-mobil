import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../services/profile_service.dart';

class EditProfileScreen
    extends StatefulWidget {

  final ProfileModel profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfileScreen>
      createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final ProfileService service =
      ProfileService();

  final formKey =
      GlobalKey<FormState>();

  late TextEditingController
      firstNameController;

  late TextEditingController
      lastNameController;

  late TextEditingController
      phoneController;

  late TextEditingController
      emailController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController(
      text:
          widget.profile.firstName,
    );

    lastNameController =
        TextEditingController(
      text:
          widget.profile.lastName,
    );

    phoneController =
        TextEditingController(
      text:
          widget.profile.phone,
    );

    emailController =
        TextEditingController(
      text:
          widget.profile.email,
    );
  }

  Future<void> save() async {

    if (!formKey.currentState!
        .validate()) {
      return;
    }

    try {

      setState(() {
        loading = true;
      });

      await service.updateProfile(
        firstName:
            firstNameController.text,
        lastName:
            lastNameController.text,
        phone:
            phoneController.text,
        email:
            emailController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Profil mis à jour",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
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
          "Modifier le profil",
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

            _field(
              controller:
                  firstNameController,
              label: "Prénom",
            ),

            const SizedBox(
              height: 16,
            ),

            _field(
              controller:
                  lastNameController,
              label: "Nom",
            ),

            const SizedBox(
              height: 16,
            ),

            _field(
              controller:
                  phoneController,
              label: "Téléphone",
            ),

            const SizedBox(
              height: 16,
            ),

            _field(
              controller:
                  emailController,
              label: "Email",
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
                      "Enregistrer",
                      style:
                          TextStyle(
                        color: Colors
                            .white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController
        controller,
    required String label,
  }) {

    return TextFormField(

      controller: controller,

      decoration:
          InputDecoration(
        labelText: label,
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),
      ),

      validator: (value) {

        if (value == null ||
            value.isEmpty) {
          return "Champ obligatoire";
        }

        return null;
      },
    );
  }
}