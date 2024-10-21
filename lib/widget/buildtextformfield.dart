import 'package:flutter/material.dart';



enum FormFieldDecorationType { outlined, filled }

class BuildTextFormField extends StatelessWidget {
  final double width;
  final String hintText;
  final String label;
  final IconData iconData;
  final bool enabled;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? initialValue;
  final void Function(String)? onChanged;
  final FormFieldDecorationType decorationType;

  const BuildTextFormField({
    required this.width,
    required this.hintText,
    required this.label,
    required this.iconData,
    required this.enabled,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.initialValue,
    this.onChanged,
    this.decorationType = FormFieldDecorationType.outlined,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? TextEditingController(text: initialValue);

    return TextFormField(
      enabled: enabled,
      keyboardType: keyboardType,
      controller: effectiveController,
      maxLines: maxLines,
      style: TextStyle(
        color: enabled ? Colors.black87 : Colors.black54,
      ),
      decoration: InputDecoration(
        filled: decorationType == FormFieldDecorationType.filled,
        fillColor: decorationType == FormFieldDecorationType.filled
            ? Colors.grey[100]
            : Colors.transparent,
        labelText: label,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.indigo[900]),
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(iconData, color: Colors.indigo[900]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo[900]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo[900]!.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo[900]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
