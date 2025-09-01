import 'package:aqaraty/api/local_data/features.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/widgets/column_checkbox.dart';
import 'package:flutter/material.dart';

class FeaturesWidget extends StatefulWidget {
  final RealEstate realEstate;
  const FeaturesWidget({super.key, required this.realEstate});

  @override
  State<FeaturesWidget> createState() => _FeaturesWidgetState();
}

class _FeaturesWidgetState extends State<FeaturesWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "الميزات",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            SizedBox(
              height: 180,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Features.values.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 90,
                ),
                itemBuilder: (context, index) {
                  final e = Features.values[index];
                  return ColumnCheckBox(
                    value: widget.realEstate.features!.contains(e),
                    text: e.arName,
                    onChanged: (p0) {
                      if (widget.realEstate.features!.contains(e)) {
                        widget.realEstate.features!.remove(e);
                      } else {
                        widget.realEstate.features!.add(e);
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
