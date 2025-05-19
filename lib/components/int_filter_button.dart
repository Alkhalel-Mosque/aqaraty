// components/int_range_filter_button.dart
import 'package:aqaraty/extensions/extension.dart';
import 'package:flutter/material.dart';

class IntRangeFilterButton extends StatelessWidget {
  final String title;
  final int? initialMin;
  final int? initialMax;
  final void Function(int? min, int? max) onApply;

  const IntRangeFilterButton({
    super.key,
    required this.title,
    this.initialMin,
    this.initialMax,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isSelected = initialMin != null || initialMax != null;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 0.3),
          backgroundColor: isSelected
              ? const Color.fromARGB(47, 68, 137, 255)
              : theme.primaryColor),
      child: Row(children: [
        2.getWidthSizedBox,
        Text(title),
        const Icon(Icons.arrow_drop_down_rounded),
      ]),
      onPressed: () {
        final minController = TextEditingController(
            text: initialMin != null ? initialMin.toString() : '');
        final maxController = TextEditingController(
            text: initialMax != null ? initialMax.toString() : '');

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("تحديد $title", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'من',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: maxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'إلى',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      int? min = int.tryParse(minController.text.trim());
                      int? max = int.tryParse(maxController.text.trim());
                      onApply(min, max);
                      Navigator.pop(context);
                    },
                    child: const Text("تطبيق"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
