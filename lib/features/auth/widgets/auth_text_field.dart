import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {

  final TextEditingController controller;

  final String label;

  final IconData icon;

  final bool obscure;

  final Widget? suffixIcon;

  final TextInputType keyboardType;

  const AuthTextField({

    super.key,

    required this.controller,

    required this.label,

    required this.icon,

    this.obscure = false,

    this.suffixIcon,

    this.keyboardType = TextInputType.text,

  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      obscureText: obscure,

      keyboardType: keyboardType,

      decoration: InputDecoration(

        filled: true,

        fillColor: Colors.grey.shade100,

        labelText: label,

        prefixIcon: Icon(icon),

        suffixIcon: suffixIcon,

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide.none,

        ),

      ),

    );

  }

}