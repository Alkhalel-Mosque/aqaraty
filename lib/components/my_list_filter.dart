import 'package:aqaraty/components/boolen_filter.dart';
import 'package:aqaraty/components/filter_button.dart';
import 'package:aqaraty/components/int_filter_button.dart';
import 'package:aqaraty/enums/enums.dart';
import 'package:flutter/material.dart';

class MyListFilter extends StatefulWidget {
  const MyListFilter({super.key});

  @override
  State<MyListFilter> createState() => _MyListFilterState();
}

class _MyListFilterState extends State<MyListFilter> {
  List<PropertyType> selectedPropertyTypes = [];
  List<Condition> selectedConditions = [];
  List<Furnishing> selectedFurnishings = [];
  List<Direction> selectedDirections = [];
  List<Types> selectedtypes = [];
  int? priceMin, priceMax;
  int? areaMin, areaMax;
  int? roomsMin, roomsMax;
  int? floorMin, floorMax;
  bool? isWithSalon;
  bool? isWithSofa;
  bool? isOffice;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        FilterButtonTile<Types>(
          title: " نوع المعاملة ",
          values: Types.values,
          selectedValues: selectedtypes,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() => selectedtypes = vals),
        ),
        FilterButtonTile<PropertyType>(
          title: "نوع العقار",
          values: PropertyType.values,
          selectedValues: selectedPropertyTypes,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() => selectedPropertyTypes = vals),
        ),
        FilterButtonTile<Condition>(
          title: "الحالة",
          values: Condition.values,
          selectedValues: selectedConditions,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() => selectedConditions = vals),
        ),
        FilterButtonTile<Furnishing>(
          title: "الفرش",
          values: Furnishing.values,
          selectedValues: selectedFurnishings,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() => selectedFurnishings = vals),
        ),
        FilterButtonTile<Direction>(
          title: "الاتجاهات",
          values: Direction.values,
          selectedValues: selectedDirections,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() => selectedDirections = vals),
        ),
        IntRangeFilterButton(
          title: "السعر",
          initialMin: priceMin,
          initialMax: priceMax,
          onApply: (min, max) {
            setState(() {
              priceMin = min;
              priceMax = max;
            });
          },
        ),
        IntRangeFilterButton(
          title: "المساحة",
          initialMin: areaMin,
          initialMax: areaMax,
          onApply: (min, max) {
            setState(() {
              areaMin = min;
              areaMax = max;
            });
          },
        ),
        IntRangeFilterButton(
          title: "عدد الغرف",
          initialMin: roomsMin,
          initialMax: roomsMax,
          onApply: (min, max) {
            setState(() {
              roomsMin = min;
              roomsMax = max;
            });
          },
        ),
        BoolFilterButton(
          title: "صالون",
          value: isWithSalon,
          onApply: (val) {
            setState(() {
              isWithSalon = val;
            });
          },
        ),
        BoolFilterButton(
          title: "صوفا",
          value: isWithSofa,
          onApply: (val) {
            setState(() {
              isWithSofa = val;
            });
          },
        ),
        BoolFilterButton(
          title: "مكتب",
          value: isOffice,
          onApply: (val) {
            setState(() {
              isOffice = val;
            });
          },
        ),
      ],
    );
  }
}
