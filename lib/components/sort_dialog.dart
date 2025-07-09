import 'package:flutter/material.dart';

class SortOptions {
  final String sortBy;
  final bool ascending;

  SortOptions({required this.sortBy, required this.ascending});
}

Future<SortOptions?> showSortDialog(BuildContext context,
    {String initialSortBy = 'createdAt', bool initialAscending = true}) {
  String selectedSortField = initialSortBy;
  bool ascending = initialAscending;

  return showDialog<SortOptions>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(" ترتيب العناصر حسب:"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('تاريخ الإضافة'),
                  value: 'createdAt',
                  groupValue: selectedSortField,
                  onChanged: (value) =>
                      setState(() => selectedSortField = value!),
                ),
                RadioListTile<String>(
                  title: const Text('السعر'),
                  value: 'price',
                  groupValue: selectedSortField,
                  onChanged: (value) =>
                      setState(() => selectedSortField = value!),
                ),
                RadioListTile<String>(
                  title: const Text('عدد الغرف'),
                  value: 'rooms',
                  groupValue: selectedSortField,
                  onChanged: (value) =>
                      setState(() => selectedSortField = value!),
                ),
                RadioListTile<String>(
                  title: const Text('المساحة'),
                  value: 'area',
                  groupValue: selectedSortField,
                  onChanged: (value) =>
                      setState(() => selectedSortField = value!),
                ),
                const Divider(),
                RadioListTile<bool>(
                  title: const Text("تصاعدي"),
                  value: true,
                  groupValue: ascending,
                  onChanged: (value) => setState(() => ascending = value!),
                ),
                RadioListTile<bool>(
                  title: const Text("تنازلي"),
                  value: false,
                  groupValue: ascending,
                  onChanged: (value) => setState(() => ascending = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  SortOptions(sortBy: selectedSortField, ascending: ascending),
                );
              },
              child: const Text("تأكيد"),
            ),
          ],
        ),
      );
    },
  );
}
