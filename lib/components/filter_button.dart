import 'package:aqaraty/extensions/extension.dart';
import 'package:flutter/material.dart';

class FilterButtonTile<T> extends StatelessWidget {
  final String title;
  final List<T> values;
  final List<T> selectedValues;
  final String Function(T) getLabel;
  final void Function(List<T>) onApply;

  const FilterButtonTile({
    super.key,
    required this.title,
    required this.values,
    required this.selectedValues,
    required this.getLabel,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedValues.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: 0.3),
            backgroundColor: isSelected
                ? const Color.fromARGB(47, 68, 137, 255)
                : theme.primaryColor),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              List<T> tempSelected = [...selectedValues];
              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("اختر $title",
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        ...values.map((val) {
                          return CheckboxListTile(
                            title: Text(getLabel(val)),
                            value: tempSelected.contains(val),
                            onChanged: (isChecked) {
                              setState(() {
                                if (isChecked == true) {
                                  tempSelected.add(val);
                                } else {
                                  tempSelected.remove(val);
                                }
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            onApply(tempSelected);
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
        },
        child: Row(
          children: [
            2.getWidthSizedBox,
            Text(title),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }
}
