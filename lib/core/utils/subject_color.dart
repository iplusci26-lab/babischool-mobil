import 'package:flutter/material.dart';

Color subjectColor(String color) {

  switch (color) {

    case "green":
      return Colors.green;

    case "orange":
      return Colors.orange;

    case "purple":
      return Colors.purple;

    case "teal":
      return Colors.teal;

    case "indigo":
      return Colors.indigo;

    case "amber":
      return Colors.amber;

    case "cyan":
      return Colors.cyan;

    case "deepPurple":
      return Colors.deepPurple;

    case "red":
      return Colors.red;

    case "blueGrey":
      return Colors.blueGrey;

    default:
      return Colors.blue;

  }

}