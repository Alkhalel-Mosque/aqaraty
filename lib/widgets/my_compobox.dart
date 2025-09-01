import 'package:flutter/material.dart';
import '../plugins/custom_dropdown_menu.dart' as dropdown;

class MyComboBox extends StatefulWidget {
  final String hint;
  final String? text;
  final List<String> items;

  final void Function(String?)? onChanged;
  const MyComboBox({
    super.key,
    required this.text,
    required this.items,
    this.hint = 'اضغط للاختيار',
    this.onChanged,
  });

  @override
  State<MyComboBox> createState() => _MyComboBoxState();
}

class _MyComboBoxState extends State<MyComboBox> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return dropdown.DropdownMenu(
      expandedInsets: const EdgeInsets.all(0),
      initialSelection: widget.text,
      label: Text(
        widget.hint,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 16,
          color: theme.colorScheme.outline,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(15),
        )),
      ),
      width: MediaQuery.of(context).size.width / 2,
      menuHeight: MediaQuery.of(context).size.height / 2,
      hintText: widget.hint,
      textStyle: theme.textTheme.bodySmall?.copyWith(
        fontSize: 16,
        color: theme.colorScheme.outline,
      ),
      dropdownMenuEntries: widget.items
          .map((e) => dropdown.DropdownMenuEntry(value: e, label: e))
          .toList(),
      onSelected: widget.onChanged,
    );
  }
}
