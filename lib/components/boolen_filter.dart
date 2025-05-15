// components/bool_filter_button.dart
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
    return OutlinedButton(
      child: Text(title),
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
