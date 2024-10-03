import 'package:aqaraty/enums/enums.dart';
import 'package:aqaraty/extensions/extension.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/pages/home_page.dart';
import 'package:aqaraty/utils/toast.dart';
import 'package:aqaraty/widgets/column_checkbox.dart';
import 'package:aqaraty/widgets/my_checkbox.dart';
import 'package:aqaraty/widgets/my_compobox.dart';
import 'package:aqaraty/widgets/my_text_button.dart';
import 'package:aqaraty/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final RealEstate realEstate = RealEstate(
    direction: [],
    features: [],
  );

  void _addRealestate() {
    if (realEstate.type == null) {
      CustomToast.showToast("اختر نوع الإضافة");
      return;
    }
    if (realEstate.propertyType == null) {
      CustomToast.showToast("اختر نوع العقار");
      return;
    }
    if (realEstate.locationArea?.isEmpty ?? false) {
      CustomToast.showToast("يرجى إضافة الموقع");
      return;
    }
    if (realEstate.price == 0) {
      CustomToast.showToast("يرجى إضافة السعر المتوقع");
      return;
    }
    if (realEstate.floor == null) {
      CustomToast.showToast("اختر الطابق");
      return;
    }
    if (realEstate.type!.isOffer && realEstate.rooms == 0) {
      CustomToast.showToast("يرجى إضافة عدد الغرف");
      return;
    }
    if (realEstate.type!.isBuyOrSell && realEstate.direction!.isEmpty) {
      CustomToast.showToast("اختر الاتجاه");
      return;
    }
    if (realEstate.type == Types.buy && realEstate.ownershipType == null) {
      CustomToast.showToast("اختر نوع الملكية");
      return;
    }
    if (realEstate.furnishing == null) {
      CustomToast.showToast("اختر حالة الفرش");
      return;
    }
    if (realEstate.condition == null) {
      CustomToast.showToast("اختر حالة الإكساء");
      return;
    }
    if (realEstate.customerName == null) {
      CustomToast.showToast("يرجى إضافة اسم الزبون");
      return;
    }
    if (realEstate.customerPhone == null) {
      CustomToast.showToast("يرجى إضافة رقم الزبون");
      return;
    }

    data.add(realEstate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة عقار"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            10.getHightSizedBox,
            MyComboBox(
              text: "نوع الإضافة",
              items: Types.values.map((e) => e.arNameTitle).toList(),
              onChanged: (p0) {
                realEstate.type = Types.getFromString(p0!);
                setState(() {});
              },
            ),
            10.getHightSizedBox,
            MyComboBox(
              text: "نوع العقار",
              onChanged: (p0) {
                // realEstate.propertyType = PropertyType.getFromString(p0!);
                setState(() {});
              },
              items: PropertyType.values.map((e) => e.arName).toList(),
            ),
            10.getHightSizedBox,
            MyTextFormField(
              labelText: "الموقع",
              onChanged: (p0) => realEstate.locationArea = p0,
            ),
            10.getHightSizedBox,
            MyTextFormField(labelText: "علامة"),
            10.getHightSizedBox,
            MyTextFormField(
              labelText: "السعر المتوقع",
              textInputType: TextInputType.number,
              maximum: 14,
            ),
            10.getHightSizedBox,
            MyComboBox(
              text: "الطابق",
              items: List.generate(18, (index) => ordinalsAr(index - 2)),
            ),
            10.getHightSizedBox,
            MyTextFormField(
              labelText: "عدد الغرف",
              textInputType: TextInputType.number,
              maximum: 1,
            ),
            5.getHightSizedBox,
            Row(
              children: [
                Expanded(
                  child: MyCheckBox(
                    val: realEstate.iswithSalon,
                    text: "مع صالون",
                    onChanged: (p0) {
                      realEstate.iswithSalon = p0!;
                      setState(() {});
                    },
                  ),
                ),
                5.getWidthSizedBox,
                Expanded(
                  child: MyCheckBox(
                    val: realEstate.iswithSofa,
                    text: "مع صوفا",
                    onChanged: (p0) {
                      realEstate.iswithSofa = p0!;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            5.getHightSizedBox,
            MyTextFormField(
              labelText: "المساحة",
              textInputType: TextInputType.number,
              maximum: 5,
            ),
            5.getHightSizedBox,
            Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Direction.values
                    .map<Widget>((e) => ColumnCheckBox(
                          value: realEstate.direction!.contains(e),
                          text: e.arName,
                          onChanged: (p0) {
                            if (realEstate.direction!.contains(e)) {
                              realEstate.direction!.remove(e);
                            } else {
                              realEstate.direction!.add(e);
                            }
                            setState(() {});
                          },
                        ))
                    .toList()
                  ..insert(
                      0,
                      Text(
                        "  الاتجاه",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )),
              ),
            ),
            5.getHightSizedBox,
            if (realEstate.type?.isBuyOrSell ?? false)
              MyComboBox(
                text: "نوع الملكية",
                items: OwnershipType.values.map((e) => e.arName).toList(),
              ),
            if (realEstate.type?.isBuyOrSell ?? false) 10.getHightSizedBox,
            MyComboBox(
              text: "الإكساء",
              items: Condition.values.map((e) => e.arName).toList(),
            ),
            10.getHightSizedBox,
            MyComboBox(
              text: "الفرش",
              items: Furnishing.values.map((e) => e.arName).toList(),
            ),
            5.getHightSizedBox,
            Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  2.getHightSizedBox,
                  Text(
                    " الميزات",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Features.values.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 90,
                      ),
                      itemBuilder: (context, index) {
                        final e = Features.values[index];
                        return ColumnCheckBox(
                          value: realEstate.features!.contains(e),
                          text: e.arName,
                          onChanged: (p0) {
                            if (realEstate.features!.contains(e)) {
                              realEstate.features!.remove(e);
                            } else {
                              realEstate.features!.add(e);
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
            5.getHightSizedBox,
            MyTextFormField(
              labelText: "معلومات إضافية",
              textInputType: TextInputType.multiline,
            ),
            10.getHightSizedBox,
            MyTextFormField(labelText: "اسم الزبون"),
            10.getHightSizedBox,
            MyTextFormField(labelText: "رقم الزبون"),
            5.getHightSizedBox,
            MyCheckBox(
              val: realEstate.isOffice,
              text: "مكتب",
              onChanged: (p0) {
                realEstate.isOffice = p0!;
                setState(() {});
              },
            ),
            5.getHightSizedBox,
            if (realEstate.isOffice) MyTextFormField(labelText: "اسم المكتب"),
            if (realEstate.isOffice) 10.getHightSizedBox,
            if (realEstate.isOffice) MyTextFormField(labelText: "رقم المكتب"),
            if (realEstate.isOffice) 10.getHightSizedBox,
            CustomTextButton(
              onPressed: _addRealestate,
              widget: const Icon(Icons.save_outlined),
              text: "حفظ",
              color: Colors.greenAccent,
            ),
            50.getHightSizedBox,
          ],
        ),
      ),
    );
  }
}
