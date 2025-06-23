import 'package:flutter/material.dart';

Widget buildMultiSelect<T>({
  required String title,
  required List<T> options,
  required List<T> selectedValues,
  required Function(List<T>) onChanged,
  required String Function(T) getLabel,
}) {
  return ExpansionTile(
    title: Text(title),
    children: options.map((option) {
      final isSelected = selectedValues.contains(option);
      return CheckboxListTile(
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
    TextEditingController maxCtrl) {
  return Row(
    children: [
      Expanded(child: Text(label)),
      Expanded(
        child: TextField(
          controller: minCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "من"),
        ),
      ),
      Expanded(
        child: TextField(
          controller: maxCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "إلى"),
        ),
      ),
    ],
  );
}

Widget buildBooleanDropdown(
    String label, bool? value, Function(bool?) onChanged) {
  return ListTile(
    title: Text(label),
    trailing: DropdownButton<bool?>(
      value: value,
      items: const [
        DropdownMenuItem(value: null, child: Text("الكل")),
        DropdownMenuItem(value: true, child: Text("نعم")),
        DropdownMenuItem(value: false, child: Text("لا")),
      ],
      onChanged: (val) => onChanged(val),
    ),
  );
}
