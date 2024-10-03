import 'package:flutter/material.dart';

class ColumnCheckBox extends StatelessWidget {
  const ColumnCheckBox({
    super.key,
    this.onChanged,
    this.value,
    required this.text,
  });
  final void Function(bool?)? onChanged;
  final bool? value;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
