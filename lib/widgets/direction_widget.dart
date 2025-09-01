// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:aqaraty/api/local_data/direction.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/widgets/column_checkbox.dart';

class DirectionWidget extends StatefulWidget {
  final RealEstate realEstate;
  const DirectionWidget({
    super.key,
    required this.realEstate,
  });

  @override
  State<DirectionWidget> createState() => _DirectionWidgetState();
}

class _DirectionWidgetState extends State<DirectionWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Direction.values
              .map<Widget>((e) => ColumnCheckBox(
                    value: widget.realEstate.direction!.contains(e),
                    text: e.arName,
                    onChanged: (p0) {
                      if (widget.realEstate.direction!.contains(e)) {
                        widget.realEstate.direction!.remove(e);
                      } else {
                        widget.realEstate.direction!.add(e);
                      }
                      setState(() {});
                    },
                  ))
              .toList()
            ..insert(
                0,
                Text(
                  "الاتجاه",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.outline,
                  ),
                )),
        ),
      ),
    );
  }
}
