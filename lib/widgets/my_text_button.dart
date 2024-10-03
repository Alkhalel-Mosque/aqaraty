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
    final usedColor = color ?? Theme.of(context).colorScheme.primary;
    return TextButton.icon(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(color),
          backgroundColor: WidgetStatePropertyAll(usedColor.withOpacity(0.2)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          overlayColor: WidgetStatePropertyAll(usedColor.withOpacity(0.3)),
        ),
        onPressed: onPressed,
        icon: widget,
        label: Text(
          text,
          style: TextStyle(
            color: usedColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
