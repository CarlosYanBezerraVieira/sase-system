import 'package:flutter/material.dart';

/// Campo de formulário padronizado para entradas simples do SASE.
class SaseFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final Color accentColor;

  const SaseFormTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.validator,
    required this.keyboardType,
    required this.textAlign,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: textAlign,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: accentColor,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
