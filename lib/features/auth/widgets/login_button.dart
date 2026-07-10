import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {

  final bool loading;

  final VoidCallback onPressed;

  const LoginButton({

    super.key,

    required this.loading,

    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,

      height: 56,

      child: ElevatedButton(

        onPressed: loading ? null : onPressed,

        style: ElevatedButton.styleFrom(

          backgroundColor: const Color(0xff6214BE),

          foregroundColor: Colors.white,

          elevation: 4,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(16),

          ),

        ),

        child: loading

            ? const SizedBox(

                height: 22,

                width: 22,

                child: CircularProgressIndicator(

                  strokeWidth: 2,

                  color: Colors.white,

                ),

              )

            : const Text(

                "Connexion",

                style: TextStyle(

                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                ),

              ),

      ),

    );

  }

}