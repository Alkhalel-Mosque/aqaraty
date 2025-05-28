import 'package:aqaraty/components/my_snackbar.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../enums/enums.dart';
import '../../extensions/extension.dart';
import '../../models/real_estate.dart';
import '../../utils/toast.dart';
import '../../widgets/column_checkbox.dart';
import '../../widgets/my_checkbox.dart';
import '../../widgets/my_compobox.dart';
import '../../widgets/my_text_button.dart';
import '../../widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';

class AddPage extends ConsumerStatefulWidget {
  final RealEstate? realEstate;
  const AddPage({
    super.key,
    this.realEstate,
  });

  @override
  ConsumerState<AddPage> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  bool editable = true;
  final ctl = MapController();
  LatLng? lat;
  // Position? _currentPosition;
  RealEstate realEstate = RealEstate(
    direction: [],
    features: [],
  );
  // RealEstate draft = RealEstate(
  //   direction: [],
  //   features: [],
  // );
  @override
  void initState() {
    if (widget.realEstate != null) {
      realEstate = widget.realEstate!.copyWith();
      editable = false;
    }
    super.initState();
  }

  void _addRealestate() async {
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
    if (realEstate.ownershipType == null) {
      CustomToast.showToast("اختر نوع الملكية");
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
    bool res;
    if (widget.realEstate == null) {
      res = await ref.read(coreProvider).addRealEstate(realEstate);
    } else {
      res = await ref.read(coreProvider).newupdateRealEstate(realEstate);
      // res = await ref.read(coreProvider).updateRealEstate(realEstate);
    }
    if (res) {
      Navigator.pop(context);
    }
  }

  void _deleteRealEstate() async {
    final ensure =
        await MySnackBar.showYesNoDialog(context, "هل أنت متأكد من الحذف؟");
    if (ensure) {
      final res = await ref.read(coreProvider).deleteRealEstate(realEstate.id!);

      if (res) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // final res =
        //     (widget.realEstate != null && widget.realEstate != realEstate) ||
        //         (realEstate != draft);
        // if (res) {
        //   return await MySnackBar.showYesNoDialog(context, "هل تود الخروج ؟");
        // }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة عقار"),
          actions: [
            if (widget.realEstate != null)
              IconButton(
                  onPressed: () {
                    editable = !editable;
                    setState(() {});
                  },
                  icon: Icon(Icons.edit)),
            if (widget.realEstate != null)
              IconButton(onPressed: _deleteRealEstate, icon: Icon(Icons.delete))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              10.getHightSizedBox,
              if (widget.realEstate?.createdBy != null)
                MyTextFormField(
                  labelText: "منشئ الطلب",
                  enabled: false,
                  suffixIcon: const Icon(Icons.account_circle_outlined),
                  initVal: widget.realEstate?.createdBy?.username,
                ),
              10.getHightSizedBox,
              MyComboBox(
                text: realEstate.requestStatus?.arName,
                hint: "الحالة",
                enabled: editable,
                items: RequestStatus.values.map((e) => e.arName).toList(),
                onChanged: (p0) {
                  realEstate.requestStatus = RequestStatus.getFromString(p0!);
                  setState(() {});
                },
              ),
              10.getHightSizedBox,
              MyComboBox(
                text: realEstate.type?.arNameTitle,
                hint: "نوع الإضافة",
                enabled: editable,
                items: Types.values.map((e) => e.arNameTitle).toList(),
                onChanged: (p0) {
                  realEstate.type = Types.getFromString(p0!);
                  setState(() {});
                },
              ),
              10.getHightSizedBox,
              MyComboBox(
                hint: "نوع العقار",
                enabled: editable,
                text: realEstate.propertyType?.arName,
                onChanged: (p0) {
                  realEstate.propertyType = PropertyType.getFromString(p0!);
                  setState(() {});
                },
                items: PropertyType.values.map((e) => e.arName).toList(),
              ),
              10.getHightSizedBox,
              MyTextFormField(
                labelText: "الموقع",
                enabled: editable,
                initVal: realEstate.locationArea,
                onChanged: (p0) => realEstate.locationArea = p0,
              ),
              10.getHightSizedBox,
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 200,
                  child: FlutterMap(
                    mapController: ctl,
                    options: MapOptions(
                      center: LatLng(33.5449, 36.3233), // Damascus coordinates
                      zoom: 17,
                    ),
                    children: [
                      TileLayer(
                        // Bring your own tiles
                        maxZoom: 100,
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
                        userAgentPackageName:
                            'com.example.app', // Add your app identifier
                        // And many more recommended properties!
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: lat ?? LatLng(0, 0),
                            builder: (ctx) =>
                                Icon(Icons.location_pin, color: Colors.red),
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(33.545405, 36.322474),
                            builder: (ctx) =>
                                Icon(Icons.location_pin, color: Colors.red),
                          ),
                        ],
                      ),

                      // MarkerLayer(
                      //   markers: [
                      //     Marker(
                      //       point: LatLng(_currentPosition?.latitude??0, _currentPosition?.longitude??0),
                      //       builder: (ctx) =>
                      //           Icon(Icons.location_pin, color: Colors.blue),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              10.getHightSizedBox,
              MyTextFormField(
                labelText: "علامة",
                enabled: editable,
                initVal: realEstate.locationMark,
                onChanged: (p0) => realEstate.locationMark = p0,
              ),
              10.getHightSizedBox,
              MyTextFormField(
                labelText: "السعر المتوقع",
                enabled: editable,
                initVal: realEstate.price.toString(),
                textInputType: TextInputType.number,
                onChanged: (p0) {
                  realEstate.price = int.parse(p0);
                },
                maximum: 14,
              ),
              10.getHightSizedBox,
              MyComboBox(
                hint: "الطابق",
                enabled: editable,
                text: ordinalsAr(realEstate.floor),
                items: List.generate(18, (index) => ordinalsAr(index - 2)!),
                onChanged: (p0) {
                  //TODO:
                  realEstate.floor = 5;
                  setState(() {});
                },
              ),
              10.getHightSizedBox,
              MyTextFormField(
                labelText: "عدد الغرف",
                enabled: editable,
                initVal: realEstate.rooms.toString(),
                textInputType: TextInputType.number,
                maximum: 1,
                onChanged: (p0) {
                  realEstate.rooms = int.parse(p0);
                },
              ),
              5.getHightSizedBox,
              Row(
                children: [
                  Expanded(
                    child: MyCheckBox(
                      editable: editable,
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
                      editable: editable,
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
                enabled: editable,
                textInputType: TextInputType.number,
                initVal: realEstate.area.toString(),
                maximum: 5,
                onChanged: (p0) {
                  realEstate.area = int.parse(p0);
                },
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
                              if (!editable) {
                                return;
                              }
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
              MyComboBox(
                enabled: editable,
                hint: "نوع الملكية",
                text: realEstate.ownershipType?.arName,
                items: OwnershipType.values.map((e) => e.arName).toList(),
                onChanged: (p0) {
                  realEstate.ownershipType = OwnershipType.getFromString(p0!);
                  setState(() {});
                },
              ),
              if (realEstate.type?.isBuyOrSell ?? false) 10.getHightSizedBox,
              MyComboBox(
                enabled: editable,
                hint: "الإكساء",
                text: realEstate.condition?.arName,
                items: Condition.values.map((e) => e.arName).toList(),
                onChanged: (p0) {
                  realEstate.condition = Condition.getFromString(p0!);
                  setState(() {});
                },
              ),
              10.getHightSizedBox,
              MyComboBox(
                enabled: editable,
                hint: "الفرش",
                text: realEstate.furnishing?.arName,
                items: Furnishing.values.map((e) => e.arName).toList(),
                onChanged: (p0) {
                  realEstate.furnishing = Furnishing.getFromString(p0!);
                  setState(() {});
                },
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
                              if (!editable) {
                                return;
                              }
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
                enabled: editable,
                labelText: "معلومات إضافية",
                initVal: realEstate.additionalInformation,
                textInputType: TextInputType.multiline,
                onChanged: (p0) {
                  realEstate.additionalInformation = p0;
                },
              ),
              10.getHightSizedBox,
              MyTextFormField(
                enabled: editable,
                initVal: realEstate.customerName,
                labelText: "اسم الزبون",
                onChanged: (p0) {
                  realEstate.customerName = p0;
                },
              ),
              10.getHightSizedBox,
              MyTextFormField(
                enabled: editable,
                initVal: realEstate.customerPhone,
                labelText: "رقم الزبون",
                onChanged: (p0) {
                  realEstate.customerPhone = p0;
                },
              ),
              5.getHightSizedBox,
              MyCheckBox(
                editable: editable,
                val: realEstate.isOffice,
                text: "مكتب",
                onChanged: (p0) {
                  realEstate.isOffice = p0!;
                  setState(() {});
                },
              ),
              5.getHightSizedBox,
              if (realEstate.isOffice)
                MyTextFormField(
                  enabled: editable,
                  labelText: "اسم المكتب",
                  initVal: realEstate.officeName,
                  onChanged: (p0) {
                    realEstate.officeName = p0;
                  },
                ),
              if (realEstate.isOffice) 10.getHightSizedBox,
              if (realEstate.isOffice)
                MyTextFormField(
                  enabled: editable,
                  labelText: "رقم المكتب",
                  initVal: realEstate.officePhone,
                  onChanged: (p0) {
                    realEstate.officePhone = p0;
                  },
                ),
              if (realEstate.isOffice) 10.getHightSizedBox,
              if (editable)
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
      ),
    );
  }
}
