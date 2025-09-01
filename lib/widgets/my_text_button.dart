import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.showBorder = true,
    this.widget,
  });
  final void Function()? onPressed;
  final String text;
  final bool showBorder;
  final Color? color;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    final usedColor = Theme.of(context);
    return TextButton.icon(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(color),
          backgroundColor: WidgetStatePropertyAll(usedColor.focusColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          overlayColor: WidgetStatePropertyAll(usedColor.focusColor),
        ),
        onPressed: onPressed,
        icon: widget,
        label: Text(
          text,
          style: TextStyle(
            color: usedColor.cardColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
