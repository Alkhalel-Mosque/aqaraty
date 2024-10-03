import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCheckBox extends StatelessWidget {
  final bool val;
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
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.colorScheme.surfaceContainer,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: CheckboxListTile(
        value: val,
        enabled: editable,
        activeColor: Colors.transparent,
        // fillColor: const WidgetStatePropertyAll(Colors.transparent),
        checkColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
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
