// components/bool_filter_button.dart
import 'package:aqaraty/extensions/extension.dart';
import 'package:flutter/material.dart';

class BoolFilterButton extends StatelessWidget {
  final String title;
  final bool? value;
  final void Function(bool?) onApply;

  const BoolFilterButton({
    super.key,
    required this.title,
    required this.value,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isSelected = value != null;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 0.3),
          backgroundColor: isSelected
              ? const Color.fromARGB(47, 68, 137, 255)
              : theme.primaryColor),
      child: Row(children: [
        2.getWidthSizedBox,
        Text(title),
        const Icon(Icons.arrow_drop_down_rounded)
      ]),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("الكل"),
                  leading: Radio<bool?>(
                    value: null,
                    groupValue: value,
                    onChanged: (val) {
                      onApply(null);
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: const Text("نعم"),
                  leading: Radio<bool?>(
                    value: true,
                    groupValue: value,
                    onChanged: (val) {
                      onApply(true);
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: const Text("لا"),
                  leading: Radio<bool?>(
                    value: false,
                    groupValue: value,
                    onChanged: (val) {
                      onApply(false);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
