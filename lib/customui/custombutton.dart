import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  Custombutton(
      {super.key,
      this.onPressed,
      this.child,
      this.primary,
      this.onPrimary,
      this.shape,
      this.text});
  Function()? onPressed;
  Widget? child;
  Color? primary;
  Color? onPrimary;
  OutlinedBorder? shape;
  String? text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
            onPrimary: onPrimary, primary: primary, shape: shape));
  }
}
