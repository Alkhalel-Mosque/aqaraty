import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCheckBox extends StatelessWidget {
  final bool isoffice;
  final bool? val;
  final String text;
  final bool editable;
  final Color? color;
  final Widget? subtitle;
  final Widget? leading;
  final void Function(bool?)? onChanged;

  const MyCheckBox({
    super.key,
    required this.val,
    required this.text,
    this.onChanged,
    this.subtitle,
    this.leading,
    this.color,
    this.editable = true,
    this.isoffice = true,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.colorScheme.surfaceContainer,
      ),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: CheckboxListTile(
        value: val,
        enabled: editable,
        contentPadding: const EdgeInsets.only(right: 10),

        activeColor: theme.focusColor,
        // fillColor: const WidgetStatePropertyAll(Colors.transparent),
        checkColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: isoffice
            ? FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  text,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 15),
              ),
        secondary: leading,
        subtitle: subtitle,
        onChanged: (v) {
          if (editable) {
            onChanged!(v);
            HapticFeedback.heavyImpact();
          }
        },
      ),
    );
  }
}
