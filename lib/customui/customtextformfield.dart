import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final String? labelText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final bool obscureText;
  final String? hintText;
  final TextInputType? keyboardType;
  final Color? fillColor;

  const CustomForm({
    Key? key,
    this.labelText,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.obscureText = false,
    this.hintText,
    this.keyboardType,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          fillColor: fillColor,
          labelStyle: TextStyle(color: Colors.orange)),
    );
  }
}
