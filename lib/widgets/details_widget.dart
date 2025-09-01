import 'package:aqaraty/api/local_data/condition.dart';
import 'package:aqaraty/api/local_data/furnishing.dart';
import 'package:aqaraty/api/local_data/ownershipType.dart';
import 'package:aqaraty/extensions/extension.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/widgets/my_checkbox.dart';
import 'package:aqaraty/widgets/my_compobox.dart';
import 'package:aqaraty/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';

class DetailsWidget extends StatefulWidget {
  final RealEstate realEstate;
  const DetailsWidget({super.key, required this.realEstate});

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تفاصيل العقار",
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            10.getHightSizedBox,
            Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    iscurrency: true,
                    realEstate: widget.realEstate,
                    labelText: "السعر المتوقع",
                    initVal: widget.realEstate.price?.toString(),
                    textInputType: TextInputType.number,
                    onChanged: (p0) {
                      widget.realEstate.price = int.parse(p0);
                    },
                    maximum: 14,
                  ),
                ),
                10.getWidthSizedBox,
                Expanded(
                  child: MyTextFormField(
                    realEstate: widget.realEstate,
                    initVal: widget.realEstate.area?.toString(),
                    labelText: "المساحة",
                    textInputType: TextInputType.number,
                    maximum: 5,
                    onChanged: (p0) {
                      widget.realEstate.area = int.parse(p0);
                    },
                  ),
                ),
              ],
            ),
            10.getHightSizedBox,
            Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    realEstate: widget.realEstate,
                    initVal: widget.realEstate.rooms?.toString(),
                    labelText: "عدد الغرف",
                    textInputType: TextInputType.number,
                    maximum: 1,
                    onChanged: (p0) {
                      widget.realEstate.rooms = int.parse(p0);
                    },
                  ),
                ),
                10.getWidthSizedBox,
                Expanded(
                  child: Card(
                    child: MyComboBox(
                      hint: "الطابق",
                      text: widget.realEstate.floor != null
                          ? ordinalsAr(widget.realEstate.floor)
                          : null,
                      items: List.generate(18, (index) {
                        final floorNumber = index - 2;
                        return ordinalsAr(floorNumber)!;
                      }),
                      onChanged: (selectedLabel) {
                        if (selectedLabel == null) return;

                        final selectedFloorIndex = List.generate(
                                18, (index) => index - 2)
                            .firstWhere((f) => ordinalsAr(f) == selectedLabel);

                        setState(() {
                          widget.realEstate.floor = selectedFloorIndex;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            10.getHightSizedBox,
            Row(
              children: [
                Expanded(
                  flex: MediaQuery.of(context).size.width > 600 ? 1 : 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width > 600 ? 4.0 : 8.0,
                    ),
                    child: MyCheckBox(
                      val: widget.realEstate.iswithSalon,
                      text: "صالون",
                      onChanged: (p0) {
                        widget.realEstate.iswithSalon = p0!;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: MediaQuery.of(context).size.width > 600 ? 1 : 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width > 600 ? 4.0 : 8.0,
                    ),
                    child: MyCheckBox(
                      val: widget.realEstate.iswithSofa,
                      text: "صوفا",
                      onChanged: (p0) {
                        widget.realEstate.iswithSofa = p0!;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: MediaQuery.of(context).size.width > 600 ? 1 : 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width > 600 ? 4.0 : 8.0,
                    ),
                    child: MyCheckBox(
                      val: widget.realEstate.iswithRoof,
                      text: "سطح",
                      onChanged: (p0) {
                        widget.realEstate.iswithRoof = p0!;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
            15.getHightSizedBox,
            if (widget.realEstate.type?.isBuyOrSell ?? false)
              10.getHightSizedBox,
            Row(
              children: [
                Expanded(
                  child: MyComboBox(
                    hint: "الإكساء",
                    text: widget.realEstate.condition?.arName,
                    items: Condition.values.map((e) => e.arName).toList(),
                    onChanged: (p0) {
                      widget.realEstate.condition =
                          Condition.getFromString(p0!);
                      setState(() {});
                    },
                  ),
                ),
                15.getWidthSizedBox, // تغيير getHightSizedBox إلى getWidthSizedBox
                Expanded(
                  child: MyComboBox(
                    hint: "الفرش",
                    text: widget.realEstate.furnishing?.arName,
                    items: Furnishing.values.map((e) => e.arName).toList(),
                    onChanged: (p0) {
                      widget.realEstate.furnishing =
                          Furnishing.getFromString(p0!);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            15.getHightSizedBox,
            MyComboBox(
              hint: "نوع الملكية",
              text: widget.realEstate.ownershipType?.arName,
              items: OwnershipType.values.map((e) => e.arName).toList(),
              onChanged: (p0) {
                widget.realEstate.ownershipType =
                    OwnershipType.getFromString(p0!);
                setState(() {});
              },
            ),
            15.getHightSizedBox,
          ],
        ),
      ),
    );
  }
}
