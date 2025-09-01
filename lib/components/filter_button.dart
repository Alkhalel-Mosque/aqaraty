import 'package:aqaraty/extensions/extension.dart';
import 'package:flutter/material.dart';

Widget buildMultiSelect<T>(
    {required String title,
    required List<T> options,
    required List<T> selectedValues,
    required Function(List<T>) onChanged,
    required String Function(T) getLabel,
    required BuildContext ctx}) {
  final theme = Theme.of(ctx);
  return ExpansionTile(
    title: Text(title),
    children: options.map((option) {
      final isSelected = selectedValues.contains(option);
      return CheckboxListTile(
        activeColor: theme.focusColor,
        checkColor: theme.canvasColor,
        value: isSelected,
        title: Text(getLabel(option)),
        onChanged: (val) {
          final newList = List<T>.from(selectedValues);
          if (val == true) {
            newList.add(option);
          } else {
            newList.remove(option);
          }
          onChanged(newList);
        },
      );
    }).toList(),
  );
}

Widget buildRangeInput(String label, TextEditingController minCtrl,
    TextEditingController maxCtrl, BuildContext ctx) {
  final theme = Theme.of(ctx);
  return Row(
    children: [
      Expanded(child: Text(label)),
      Expanded(
        child: TextField(
          controller: minCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "من",
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: theme.focusColor,
                width: 2,
              ),
            ),
          ),
        ),
      ),
      3.getWidthSizedBox,
      Expanded(
        child: TextField(
          controller: maxCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "إلى",
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: theme.focusColor,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildBooleanDropdown(
    BuildContext ctx, String label, bool? value, Function(bool?) onChanged) {
  return ListTile(
    title: Text(label),
    trailing: DropdownButton<bool?>(
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Theme.of(ctx).cardColor,
      hint: const Text("الكل"),
      value: value, // تأكد من أن null تبقى null
      items: const [
        DropdownMenuItem(value: null, child: Text("الكل")),
        DropdownMenuItem(value: true, child: Text("نعم")),
        DropdownMenuItem(value: false, child: Text("لا")),
      ],
      onChanged: onChanged,
    ),
  );
}
