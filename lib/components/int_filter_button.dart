// components/int_range_filter_button.dart
import 'package:aqaraty/extensions/extension.dart';
import 'package:flutter/material.dart';

Widget buildRangeInputFields({
  required String title,
  required int? minValue,
  required int? maxValue,
  required Function(String) onMinChanged,
  required Function(String) onMaxChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 12),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'من'),
              initialValue: minValue?.toString(),
              onChanged: onMinChanged,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'إلى'),
              initialValue: maxValue?.toString(),
              onChanged: onMaxChanged,
            ),
          ),
        ],
      ),
    ],
  );
}
