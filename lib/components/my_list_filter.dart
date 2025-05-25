import 'package:aqaraty/components/boolen_filter.dart';
import 'package:aqaraty/components/filter_button.dart';
import 'package:aqaraty/components/int_filter_button.dart';
import 'package:aqaraty/enums/enums.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:flutter/material.dart';

class MyListFilter extends StatefulWidget {
  final List<RealEstate> allEstates;
  final void Function(List<RealEstate>) onFilterChanged;
  const MyListFilter(
      {super.key, required this.onFilterChanged, required this.allEstates});

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
  int? minPrice, maxPrice;
  int? minArea, maxArea;
  int? minRooms, maxRooms;
  void filterEstates() {
    final filtered = widget.allEstates.where((estate) {
      if (selectedtypes.isNotEmpty && !selectedtypes.contains(estate.type)) {
        return false;
      }
      if (selectedPropertyTypes.isNotEmpty &&
          !selectedPropertyTypes.contains(estate.propertyType)) {
        return false;
      }
      if (selectedConditions.isNotEmpty &&
          !selectedConditions.contains(estate.condition)) {
        return false;
      }
      if (selectedFurnishings.isNotEmpty &&
          !selectedFurnishings.contains(estate.furnishing)) {
        return false;
      }
      if (selectedDirections.isNotEmpty &&
          !selectedDirections.contains(estate.direction)) {
        return false;
      }

      if (minPrice != null && estate.price < minPrice!) return false;
      if (maxPrice != null && estate.price > maxPrice!) return false;
      if (minArea != null && (estate.area ?? 0) < minArea!) return false;
      if (maxArea != null && (estate.area ?? 0) > maxArea!) return false;
      if (minRooms != null && estate.rooms < minRooms!) return false;
      if (maxRooms != null && estate.rooms > maxRooms!) return false;
      print(estate.price);
      print(minPrice);
      print(maxPrice);

      if (isWithSalon != null && estate.iswithSalon != isWithSalon) {
        return false;
      }
      if (isWithSofa != null && estate.iswithSofa != isWithSofa) return false;
      if (isOffice != null && estate.isOffice != isOffice) return false;

      return true;
    }).toList();

    widget.onFilterChanged(filtered);
  }

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
          onApply: (vals) => setState(() {
            selectedtypes = vals;
            filterEstates();
          }),
        ),
        FilterButtonTile<PropertyType>(
          title: "نوع العقار",
          values: PropertyType.values,
          selectedValues: selectedPropertyTypes,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() {
            selectedPropertyTypes = vals;
            filterEstates();
          }),
        ),
        FilterButtonTile<Condition>(
          title: "الحالة",
          values: Condition.values,
          selectedValues: selectedConditions,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() {
            selectedConditions = vals;
            filterEstates();
          }),
        ),
        FilterButtonTile<Furnishing>(
          title: "الفرش",
          values: Furnishing.values,
          selectedValues: selectedFurnishings,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() {
            selectedFurnishings = vals;

            filterEstates();
          }),
        ),
        FilterButtonTile<Direction>(
          title: "الاتجاهات",
          values: Direction.values,
          selectedValues: selectedDirections,
          getLabel: (e) => e.arName,
          onApply: (vals) => setState(() {
            selectedDirections = vals;

            filterEstates();
          }),
        ),
        IntRangeFilterButton(
          title: 'السعر',
          initialMin: minPrice,
          initialMax: maxPrice,
          onApply: (min, max) {
            setState(() {
              minPrice = min;
              maxPrice = max;
              filterEstates();
            });
          },
        ),
        const SizedBox(width: 10),
        IntRangeFilterButton(
          title: 'المساحة',
          initialMin: minArea,
          initialMax: maxArea,
          onApply: (min, max) {
            setState(() {
              minArea = min;
              maxArea = max;
              filterEstates();
            });
          },
        ),
        const SizedBox(width: 10),
        IntRangeFilterButton(
          title: 'عدد الغرف',
          initialMin: minRooms,
          initialMax: maxRooms,
          onApply: (min, max) {
            setState(() {
              minRooms = min;
              maxRooms = max;
              filterEstates();
            });
          },
        ),
        BoolFilterButton(
          title: "صالون",
          value: isWithSalon,
          onApply: (val) {
            setState(() {
              isWithSalon = val;
              filterEstates();
            });
          },
        ),
        BoolFilterButton(
          title: "صوفا",
          value: isWithSofa,
          onApply: (val) {
            setState(() {
              isWithSofa = val;
              filterEstates();
            });
          },
        ),
        BoolFilterButton(
          title: "مكتب",
          value: isOffice,
          onApply: (val) {
            setState(() {
              isOffice = val;
              filterEstates();
            });
          },
        ),
      ],
    );
  }
}
