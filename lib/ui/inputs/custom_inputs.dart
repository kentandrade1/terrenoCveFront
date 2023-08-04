import 'package:flutter/material.dart';

class CustomInputs {
  static InputDecoration loginInputDecoration({
    required String hint,
     String? label,
    required IconData icon,
    Widget? suffixIcon, // Nuevo parámetro para el suffixIcon
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      hintText: hint,
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffixIcon, // Establece el suffixIcon
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static InputDecoration searchInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
    );
  }

  static InputDecoration formInputDecoration({
    required String hint,
     String? label,
    required IconData icon,
    Widget? suffixIcon, // Nuevo parámetro para el suffixIcon
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.indigo),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.indigo),
      ),
      hintText: hint,
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffixIcon, // Establece el suffixIcon
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
