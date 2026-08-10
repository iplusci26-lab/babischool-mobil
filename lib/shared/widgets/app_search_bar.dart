import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {

  final String hintText;

  final ValueChanged<String>? onChanged;

  final TextEditingController? controller;

  const AppSearchBar({

    super.key,

    required this.hintText,

    this.onChanged,

    this.controller,

  });

  @override
  Widget build(BuildContext context) {

    return Container(

      height: 56,

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(.05),

            blurRadius: 20,

            offset: const Offset(0,8),

          )

        ],

      ),

      child: TextField(

        controller: controller,

        onChanged: onChanged,

        decoration: InputDecoration(

          hintText: hintText,

          border: InputBorder.none,

          prefixIcon: const Icon(

            Icons.search,

            color: Colors.grey,

          ),

          contentPadding: const EdgeInsets.symmetric(

            vertical: 18,

          ),

        ),

      ),

    );

  }

}