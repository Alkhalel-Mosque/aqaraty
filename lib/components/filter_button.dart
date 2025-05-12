import 'package:aqaraty/extensions/extension.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({super.key});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Row(
          children: [
            2.getWidthSizedBox,
            Text("السعر التقريبي"),
            Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }
}
