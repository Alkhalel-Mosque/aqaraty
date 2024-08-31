import 'package:aqaraty/enums/enums.dart';
import 'package:aqaraty/extensions/extension.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/widgets/my_compobox.dart';
import 'package:aqaraty/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});
  final RealEstate realEstate = RealEstate();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة عقار"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            10.getHightSizedBox,
            MyComboBox(
              text: "نوع العقد",
              items: Types.values.map((e) => e.arName).toList(),
            ),
            10.getHightSizedBox,
            MyComboBox(
              text: "نوع العقار",
              items: PropertyType.values.map((e) => e.arName).toList(),
            ),
            10.getHightSizedBox,
            MyTextFormField(labelText: "الموقع"),
            10.getHightSizedBox,
            MyTextFormField(labelText: "علامة"),
          ],
        ),
      ),
    );
  }
}
